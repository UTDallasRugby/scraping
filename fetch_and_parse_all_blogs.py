#!/usr/bin/env -S uv run
# /// script
# requires-python = ">=3.12"
# dependencies = [
#     "beautifulsoup4",
#     "lxml",
#     "pandas",
#     "feedparser",
# ]
# ///

"""
Fetch and parse all blog posts from the links file.

Reads blog_post_links.txt, fetches each post, and runs the parser on all content.
"""

import sys
import time
from pathlib import Path
from urllib.request import urlopen, Request
from bs4 import BeautifulSoup
import pandas as pd

# Import extraction functions from parse_blog_stats
from parse_blog_stats import (
    extract_match_scores,
    extract_try_scorers,
    extract_conversions,
    extract_lineups,
    clean_html,
)


def fetch_page(url: str) -> str:
    """Fetch a page with proper headers."""
    req = Request(url, headers={"User-Agent": "Mozilla/5.0"})
    try:
        with urlopen(req, timeout=10) as response:
            return response.read().decode("utf-8")
    except Exception as e:
        print(f"Error fetching {url}: {e}", file=sys.stderr)
        return None


def fix_url(url: str) -> str:
    """Fix double-domain URLs from the scraper."""
    # Fix: https://utdallasrugby.weebly.com//utdallasrugby.weebly.com/path
    # To:  https://utdallasrugby.weebly.com/path
    if "//utdallasrugby.weebly.com" in url:
        parts = url.split("//utdallasrugby.weebly.com")
        if len(parts) > 1:
            return f"https://utdallasrugby.weebly.com{parts[-1]}"
    return url


def parse_blog_post(url: str, date: str, title: str) -> dict:
    """Fetch and parse a single blog post."""
    html = fetch_page(url)
    if not html:
        return None

    soup = BeautifulSoup(html, "lxml")

    # Find the blog post content
    post = soup.find("div", class_="blog-post")
    if not post:
        print(f"  Warning: No blog-post div found in {url}", file=sys.stderr)
        return None

    # Get content
    content_elem = post.find("div", class_="blog-content")
    if not content_elem:
        print(f"  Warning: No blog-content found in {url}", file=sys.stderr)
        return None

    content_html = str(content_elem)
    content_text = clean_html(content_html)

    return {
        "url": url,
        "date": date,
        "title": title,
        "content_text": content_text,
    }


def main():
    """Main execution."""
    links_file = Path("blog_post_links.txt")

    if not links_file.exists():
        print(
            f"Error: {links_file} not found. Run scrape_all_blog_posts.py first.",
            file=sys.stderr,
        )
        sys.exit(1)

    print("Reading blog post links...", file=sys.stderr)

    # Read all links
    blog_posts = []
    with open(links_file, "r") as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            parts = line.split("\t")
            if len(parts) == 3:
                date, title, url = parts
                blog_posts.append(
                    {
                        "date": date,
                        "title": title,
                        "url": fix_url(url),
                    }
                )

    print(f"Found {len(blog_posts)} blog posts to fetch and parse", file=sys.stderr)

    # Track all stats
    all_matches = []
    all_try_scorers = []
    all_conversions = []
    all_lineups = []

    posts_with_stats = 0
    posts_fetched = 0

    # Fetch and parse each post
    for i, post_info in enumerate(blog_posts, 1):
        print(
            f"\n[{i}/{len(blog_posts)}] {post_info['date']}: {post_info['title']}",
            file=sys.stderr,
        )
        print(f"  URL: {post_info['url']}", file=sys.stderr)

        # Fetch post content
        post_data = parse_blog_post(
            post_info["url"], post_info["date"], post_info["title"]
        )

        if not post_data:
            print("  Skipped (could not fetch)", file=sys.stderr)
            continue

        posts_fetched += 1
        content_text = post_data["content_text"]

        # Extract stats
        matches = extract_match_scores(
            content_text, post_info["date"], post_info["title"]
        )
        try_scorers = extract_try_scorers(
            content_text, post_info["date"], post_info["title"]
        )
        conversions = extract_conversions(
            content_text, post_info["date"], post_info["title"]
        )
        lineups = extract_lineups(content_text, post_info["date"], post_info["title"])

        # Count stats found
        stats_count = len(matches) + len(try_scorers) + len(conversions) + len(lineups)

        if stats_count > 0:
            posts_with_stats += 1
            print(
                f"  Found: {len(matches)} matches, {len(try_scorers)} try scorers, "
                f"{len(conversions)} conversions, {len(lineups)} lineup entries",
                file=sys.stderr,
            )

            all_matches.extend(matches)
            all_try_scorers.extend(try_scorers)
            all_conversions.extend(conversions)
            all_lineups.extend(lineups)
        else:
            print("  No stats found", file=sys.stderr)

        # Be polite to the server
        if i < len(blog_posts):
            time.sleep(0.5)

    # Summary
    print("\n" + "=" * 60, file=sys.stderr)
    print("Fetching complete!", file=sys.stderr)
    print(f"Posts fetched: {posts_fetched}/{len(blog_posts)}", file=sys.stderr)
    print(f"Posts with stats: {posts_with_stats}", file=sys.stderr)
    print(f"Total matches: {len(all_matches)}", file=sys.stderr)
    print(f"Total try scorers: {len(all_try_scorers)}", file=sys.stderr)
    print(f"Total conversions: {len(all_conversions)}", file=sys.stderr)
    print(f"Total lineup entries: {len(all_lineups)}", file=sys.stderr)
    print("=" * 60 + "\n", file=sys.stderr)

    # Save to CSV files
    if all_matches:
        df = pd.DataFrame(all_matches)
        df.to_csv("all_blog_matches.csv", index=False)
        print(
            f"Saved {len(all_matches)} matches to all_blog_matches.csv", file=sys.stderr
        )

    if all_try_scorers:
        df = pd.DataFrame(all_try_scorers)
        df.to_csv("all_blog_try_scorers.csv", index=False)
        print(
            f"Saved {len(all_try_scorers)} try scorers to all_blog_try_scorers.csv",
            file=sys.stderr,
        )

    if all_conversions:
        df = pd.DataFrame(all_conversions)
        df.to_csv("all_blog_conversions.csv", index=False)
        print(
            f"Saved {len(all_conversions)} conversions to all_blog_conversions.csv",
            file=sys.stderr,
        )

    if all_lineups:
        df = pd.DataFrame(all_lineups)
        df.to_csv("all_blog_lineups.csv", index=False)
        print(
            f"Saved {len(all_lineups)} lineup entries to all_blog_lineups.csv",
            file=sys.stderr,
        )


if __name__ == "__main__":
    main()

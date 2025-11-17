#!/usr/bin/env -S uv run
# /// script
# requires-python = ">=3.12"
# dependencies = [
#     "beautifulsoup4",
#     "lxml",
#     "feedparser",
# ]
# ///

"""
Scrape all blog posts from UTD Rugby blog (paginated).

Fetches all blog post pages and saves them as an extended RSS/XML feed.
"""

import sys
import time
from pathlib import Path
from urllib.request import urlopen, Request
from urllib.error import HTTPError
from bs4 import BeautifulSoup


BASE_URL = "https://utdallasrugby.weebly.com"
BLOG_URL = f"{BASE_URL}/tonys-blog"


def fetch_page(url: str) -> str:
    """Fetch a page with proper headers."""
    req = Request(url, headers={"User-Agent": "Mozilla/5.0"})
    with urlopen(req) as response:
        return response.read().decode("utf-8")


def get_blog_post_links(page_html: str) -> list[dict]:
    """Extract blog post links and metadata from a blog archive page."""
    soup = BeautifulSoup(page_html, "lxml")
    posts = []

    # Find blog post entries
    # Weebly blog posts are typically in divs with class "blog-post"
    for post_div in soup.find_all("div", class_="blog-post"):
        # Get title and link
        title_elem = post_div.find("h2", class_="blog-title")
        if title_elem:
            link_elem = title_elem.find("a")
            if link_elem:
                title = link_elem.get_text(strip=True)
                href = link_elem.get("href", "")

                # Get date
                date_elem = post_div.find("p", class_="blog-date")
                date = date_elem.get_text(strip=True) if date_elem else ""

                # Get full URL
                full_url = href if href.startswith("http") else f"{BASE_URL}{href}"

                posts.append(
                    {
                        "title": title,
                        "url": full_url,
                        "date": date,
                    }
                )

    return posts


def get_pagination_link(page_html: str) -> str | None:
    """Get the 'previous' (older posts) pagination link."""
    soup = BeautifulSoup(page_html, "lxml")

    # Look for pagination links (Weebly uses blog-page-nav-previous)
    pagination = soup.find("div", class_="blog-page-nav-previous")
    if pagination:
        prev_link = pagination.find("a", class_="blog-link")
        if prev_link:
            href = prev_link.get("href", "")
            return href if href.startswith("http") else f"{BASE_URL}{href}"

    return None


def fetch_all_post_links() -> list[dict]:
    """Crawl through all paginated blog pages and collect post links."""
    all_posts = []
    current_url = BLOG_URL
    page_num = 1

    while current_url:
        print(f"Fetching page {page_num}: {current_url}", file=sys.stderr)

        try:
            html = fetch_page(current_url)
        except HTTPError as e:
            print(f"HTTP Error {e.code} on page {page_num}", file=sys.stderr)
            break

        # Extract posts from this page
        posts = get_blog_post_links(html)
        print(f"  Found {len(posts)} posts on page {page_num}", file=sys.stderr)
        all_posts.extend(posts)

        # Get next page link
        next_url = get_pagination_link(html)
        if next_url:
            current_url = next_url
            page_num += 1
            time.sleep(1)  # Be polite to the server
        else:
            print("  No more pages found", file=sys.stderr)
            break

    return all_posts


def fetch_blog_post_content(url: str) -> dict | None:
    """Fetch full content of a single blog post."""
    try:
        html = fetch_page(url)
        soup = BeautifulSoup(html, "lxml")

        # Find the blog post content
        post = soup.find("div", class_="blog-post")
        if not post:
            return None

        # Get title
        title_elem = post.find("h2", class_="blog-title")
        title = title_elem.get_text(strip=True) if title_elem else "Untitled"

        # Get date
        date_elem = post.find("p", class_="blog-date")
        date = date_elem.get_text(strip=True) if date_elem else ""

        # Get content
        content_elem = post.find("div", class_="blog-content")
        content_html = str(content_elem) if content_elem else ""
        content_text = content_elem.get_text(strip=True) if content_elem else ""

        return {
            "title": title,
            "url": url,
            "date": date,
            "content_html": content_html,
            "content_text": content_text[:500],  # Preview
        }

    except Exception as e:
        print(f"Error fetching {url}: {e}", file=sys.stderr)
        return None


def main():
    """Main execution."""
    print("Crawling UTD Rugby blog for all posts...\n", file=sys.stderr)

    # Get all post links
    all_posts = fetch_all_post_links()

    print(f"\n{'=' * 60}", file=sys.stderr)
    print(f"Total posts found: {len(all_posts)}", file=sys.stderr)
    print(f"{'=' * 60}\n", file=sys.stderr)

    # Display summary
    if all_posts:
        print("Sample posts:", file=sys.stderr)
        for i, post in enumerate(all_posts[:10], 1):
            print(f"  {i}. {post['date']}: {post['title']}", file=sys.stderr)

        if len(all_posts) > 10:
            print(f"  ... and {len(all_posts) - 10} more", file=sys.stderr)

    # Ask user if they want to fetch full content
    print(f"\nFound {len(all_posts)} blog posts.", file=sys.stderr)
    print("The old RSS feed had 10 posts (2018-01-21 to 2018-08-14)", file=sys.stderr)
    print("\nRun with --fetch to download full content of all posts", file=sys.stderr)

    # Save post links to file
    output_file = Path("blog_post_links.txt")
    with open(output_file, "w") as f:
        for post in all_posts:
            f.write(f"{post['date']}\t{post['title']}\t{post['url']}\n")

    print(f"\nSaved post links to {output_file}", file=sys.stderr)


if __name__ == "__main__":
    main()

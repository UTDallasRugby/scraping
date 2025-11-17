#!/usr/bin/env -S uv run
# /// script
# requires-python = ">=3.12"
# dependencies = [
#     "feedparser",
#     "beautifulsoup4",
#     "pandas",
#     "lxml",
# ]
# ///

"""
Parse rugby stats from old blog posts in static/old_feed.xml.

Extracts match scores, try scorers, conversions, and team lineups from
unstructured blog post content and outputs to CSV files.
"""

import feedparser
import re
import sys
from datetime import datetime
from pathlib import Path
from bs4 import BeautifulSoup
import pandas as pd


def clean_html(html_content: str) -> str:
    """Remove HTML tags and normalize whitespace from content."""
    soup = BeautifulSoup(html_content, "lxml")
    # Get text and normalize whitespace
    text = soup.get_text(separator=" ")
    text = re.sub(r"\s+", " ", text).strip()
    return text


def extract_match_scores(text: str, post_date: str, post_title: str) -> list[dict]:
    """Extract match scores from text using regex patterns."""
    matches = []

    # Pattern 1: "UTD 55, ACU 0" or "UT Dallas 55, ACU 0"
    pattern1 = r"(?:UTD|UT Dallas)\s+(\d+)[,\s]+(?:to\s+)?(\w+(?:\s+\w+)?)['\s]*(\d+)"
    for match in re.finditer(pattern1, text, re.IGNORECASE):
        utd_score = int(match.group(1))
        opponent = match.group(2).strip()
        opp_score = int(match.group(3))

        matches.append(
            {
                "date": post_date,
                "opponent": opponent,
                "utd_score": utd_score,
                "opponent_score": opp_score,
                "confidence": "high",
                "notes": "",
                "source_title": post_title,
            }
        )

    # Pattern 2: "UD 22, UTD 17" (opponent first)
    pattern2 = r"(\w+(?:\s+\w+)?)\s+(\d+)[,\s]+(?:to\s+)?(?:UTD|UT Dallas)\s+(\d+)"
    for match in re.finditer(pattern2, text, re.IGNORECASE):
        opponent = match.group(1).strip()
        opp_score = int(match.group(2))
        utd_score = int(match.group(3))

        # Skip if we already found this match in pattern1
        if not any(
            m["opponent"] == opponent and m["utd_score"] == utd_score for m in matches
        ):
            matches.append(
                {
                    "date": post_date,
                    "opponent": opponent,
                    "utd_score": utd_score,
                    "opponent_score": opp_score,
                    "confidence": "high",
                    "notes": "",
                    "source_title": post_title,
                }
            )

    # Pattern 3: "UT Dallas 40, Texas St. 33" (with periods in abbreviations)
    pattern3 = r"(?:UTD|UT Dallas)\s+(\d+)[,\s]+(\w+(?:\s+\w+)?\.?)\s+(\d+)"
    for match in re.finditer(pattern3, text, re.IGNORECASE):
        utd_score = int(match.group(1))
        opponent = match.group(2).strip()
        opp_score = int(match.group(3))

        # Skip duplicates
        if not any(
            m["opponent"] == opponent and m["utd_score"] == utd_score for m in matches
        ):
            matches.append(
                {
                    "date": post_date,
                    "opponent": opponent,
                    "utd_score": utd_score,
                    "opponent_score": opp_score,
                    "confidence": "high",
                    "notes": "",
                    "source_title": post_title,
                }
            )

    # Pattern 4: Looser pattern for "score even at 17" (half-time scores)
    pattern4 = r"score\s+even\s+at\s+(\d+)"
    for match in re.finditer(pattern4, text, re.IGNORECASE):
        score = int(match.group(1))
        matches.append(
            {
                "date": post_date,
                "opponent": "Unknown",
                "utd_score": score,
                "opponent_score": score,
                "confidence": "medium",
                "notes": "Half-time score (tied)",
                "source_title": post_title,
            }
        )

    return matches


def extract_try_scorers(text: str, post_date: str, post_title: str) -> list[dict]:
    """Extract try scorers from text using regex patterns."""
    try_scorers = []

    # Pattern 1: "Jackson (3 Trys)" or "Jackson (1 Try)"
    # Use word boundary to avoid capturing "was Jackson"
    pattern1 = r"\b([A-Z][\w]+(?:\s+[A-Z]\.?)?)\s+\((\d+)\s+Trys?\)"
    for match in re.finditer(pattern1, text):
        player_name = match.group(1).strip()
        tries = int(match.group(2))

        try_scorers.append(
            {
                "date": post_date,
                "player_name": player_name,
                "tries_scored": tries,
                "confidence": "high",
                "notes": "",
                "source_title": post_title,
            }
        )

    # Pattern 2: "Lewis, Eric, Aly, Edmund all scoring 1 Try each"
    pattern2 = r"([\w\s,]+?)\s+(?:all\s+)?scoring\s+(\d+)\s+Trys?\s+each"
    for match in re.finditer(pattern2, text, re.IGNORECASE):
        players_str = match.group(1).strip()
        tries = int(match.group(2))

        # Split by commas and "and"
        players = re.split(r",\s*|\s+and\s+", players_str)
        for player in players:
            player = player.strip()
            if player and len(player) > 1:  # Skip single letters/empty
                try_scorers.append(
                    {
                        "date": post_date,
                        "player_name": player,
                        "tries_scored": tries,
                        "confidence": "medium",
                        "notes": "Extracted from list",
                        "source_title": post_title,
                    }
                )

    # Pattern 3: "Daniel managed to score a try"
    pattern3 = r"(\w+)\s+(?:managed\s+to\s+)?scor(?:e|ed)\s+a\s+try"
    for match in re.finditer(pattern3, text, re.IGNORECASE):
        player_name = match.group(1).strip()

        # Skip common words that might match
        if player_name.lower() not in ["to", "the", "and", "we", "they"]:
            try_scorers.append(
                {
                    "date": post_date,
                    "player_name": player_name,
                    "tries_scored": 1,
                    "confidence": "medium",
                    "notes": "Narrative mention",
                    "source_title": post_title,
                }
            )

    return try_scorers


def extract_conversions(text: str, post_date: str, post_title: str) -> list[dict]:
    """Extract conversion stats from text."""
    conversions = []

    # Pattern: "Lewis Hopkins did convert 5 of 9 Trys"
    pattern = (
        r"(\w+(?:\s+\w+)?)\s+(?:did\s+)?convert(?:ed)?\s+(\d+)\s+of\s+(\d+)\s+Trys?"
    )
    for match in re.finditer(pattern, text, re.IGNORECASE):
        kicker_name = match.group(1).strip()
        made = int(match.group(2))
        attempted = int(match.group(3))

        conversions.append(
            {
                "date": post_date,
                "kicker_name": kicker_name,
                "conversions_made": made,
                "conversions_attempted": attempted,
                "confidence": "high",
                "notes": "",
                "source_title": post_title,
            }
        )

    return conversions


def extract_lineups(text: str, post_date: str, post_title: str) -> list[dict]:
    """Extract team lineups from numbered position lists."""
    lineups = []

    # Pattern: "1. Player Name," or "15. Player Name" (numbered positions)
    # Look for sequences of numbered positions (1-15 for starters, 16+ for reserves)
    pattern = r"(\d+)\.\s+([\w\s]+?)(?:,|;|\n|<br|\.)"

    matches = list(re.finditer(pattern, text))

    # Only extract if we have a reasonable lineup (at least 10 positions)
    if len(matches) >= 10:
        for match in matches:
            position_num = int(match.group(1))
            player_name = match.group(2).strip()

            # Skip if player name is suspiciously short or long
            if len(player_name) < 2 or len(player_name) > 30:
                continue

            # Determine if starter or reserve
            role = "Starter" if position_num <= 15 else "Reserve"

            lineups.append(
                {
                    "date": post_date,
                    "position": position_num,
                    "player_name": player_name,
                    "role": role,
                    "confidence": "high" if len(matches) >= 15 else "medium",
                    "notes": "",
                    "source_title": post_title,
                }
            )

    return lineups


def parse_feed(
    xml_path: Path,
) -> tuple[pd.DataFrame, pd.DataFrame, pd.DataFrame, pd.DataFrame]:
    """Parse RSS feed and extract all stats."""

    # Parse the RSS feed
    feed = feedparser.parse(str(xml_path))

    all_matches = []
    all_try_scorers = []
    all_conversions = []
    all_lineups = []

    print(f"Processing {len(feed.entries)} blog posts...", file=sys.stderr)

    for entry in feed.entries:
        title = entry.get("title", "Untitled")
        pub_date = entry.get("published", "")

        # Parse date to YYYY-MM-DD format
        formatted_date = pub_date  # Fallback to original
        if pub_date:
            try:
                # Try RSS date format first
                dt = datetime.strptime(pub_date, "%a, %d %b %Y %H:%M:%S %z")
                formatted_date = dt.strftime("%Y-%m-%d")
            except ValueError:
                try:
                    # Try without timezone
                    dt = datetime.strptime(pub_date, "%a, %d %b %Y %H:%M:%S %Z")
                    formatted_date = dt.strftime("%Y-%m-%d")
                except ValueError:
                    # Keep original if parsing fails
                    pass

        # Get content (either content:encoded or description)
        content = entry.get("content", [{}])[0].get("value", "") or entry.get(
            "description", ""
        )

        # Clean HTML
        clean_text = clean_html(content)

        print(f"  - {title} ({formatted_date})", file=sys.stderr)

        # Extract stats from this post
        matches = extract_match_scores(clean_text, formatted_date, title)
        try_scorers = extract_try_scorers(clean_text, formatted_date, title)
        conversions = extract_conversions(clean_text, formatted_date, title)
        lineups = extract_lineups(clean_text, formatted_date, title)

        all_matches.extend(matches)
        all_try_scorers.extend(try_scorers)
        all_conversions.extend(conversions)
        all_lineups.extend(lineups)

        print(
            f"    Found: {len(matches)} matches, {len(try_scorers)} try scorers, "
            f"{len(conversions)} conversion stats, {len(lineups)} lineup entries",
            file=sys.stderr,
        )

    # Convert to DataFrames
    df_matches = pd.DataFrame(all_matches)
    df_try_scorers = pd.DataFrame(all_try_scorers)
    df_conversions = pd.DataFrame(all_conversions)
    df_lineups = pd.DataFrame(all_lineups)

    return df_matches, df_try_scorers, df_conversions, df_lineups


def main():
    """Main execution function."""
    xml_path = Path("static/old_feed.xml")

    if not xml_path.exists():
        print(f"Error: {xml_path} not found", file=sys.stderr)
        sys.exit(1)

    print(f"Parsing {xml_path}...", file=sys.stderr)

    # Parse feed and extract stats
    df_matches, df_try_scorers, df_conversions, df_lineups = parse_feed(xml_path)

    # Output to CSV files
    output_files = {
        "blog_matches.csv": df_matches,
        "blog_try_scorers.csv": df_try_scorers,
        "blog_conversions.csv": df_conversions,
        "blog_lineups.csv": df_lineups,
    }

    print("\n" + "=" * 60, file=sys.stderr)
    print("Summary:", file=sys.stderr)
    print("=" * 60, file=sys.stderr)

    for filename, df in output_files.items():
        if not df.empty:
            df.to_csv(filename, index=False, encoding="utf-8")
            print(f"✓ {filename}: {len(df)} rows", file=sys.stderr)
        else:
            print(f"✗ {filename}: No data extracted", file=sys.stderr)

    print(
        "\nDone! Review the CSV files and check the 'notes' column for flagged entries.",
        file=sys.stderr,
    )


if __name__ == "__main__":
    main()

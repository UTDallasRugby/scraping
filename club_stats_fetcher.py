#!/usr/bin/env -S uv run
# /// script
# requires-python = ">=3.12"
# dependencies = [
#     "requests",
# ]
# ///

import requests
from typing import List, Dict
import json
from pathlib import Path
from datetime import datetime

BASE_URL = "https://usarugbystats.com/api"

def fetch_club_stats(club_id: str, season: str) -> Dict:
    """Fetch all stats for a specific club and season."""
    stats = {}
    endpoints = {
        "pts": "points",
        "tr": "tries",
        "cv": "conversions",
        "pk": "penalty kicks",
        "dg": "drop goals",
        "started": "started",
        "played": "games played",
        "yc": "yellow cards",
        "rc": "red cards"
    }
    
    for endpoint, stat_name in endpoints.items():
        try:
            url = f"{BASE_URL}/stats/club/{endpoint}/{club_id}/{season}"
            response = requests.get(url)
            response.raise_for_status()
            stats[stat_name] = response.json()
            print(f"Successfully fetched {stat_name} for club {club_id} in {season}")
        except requests.exceptions.RequestException as e:
            print(f"Error fetching {stat_name} for club {club_id} in {season}: {e}")
    
    return stats

def get_seasons(start_year: int = 2014, end_year: int = None) -> List[str]:
    """Generate list of seasons from start_year to current year."""
    if end_year is None:
        end_year = datetime.now().year
    
    seasons = []
    for year in range(start_year, end_year):
        seasons.append(f"{year}-{year+1}")
    return seasons

def fetch_all_club_stats() -> Dict:
    """Fetch stats for all clubs across all seasons."""
    all_stats = {}
    # For now, just fetch UTD Rugby stats as we know their ID
    club_id = "696"
    club_name = "UTD Rugby"
    
    seasons = get_seasons()
    print(f"\nFetching stats for {club_name} (ID: {club_id})")
    
    club_stats = {}
    for season in seasons:
        club_stats[season] = fetch_club_stats(club_id, season)
    
    all_stats[club_id] = {
        'name': club_name,
        'stats': club_stats
    }
    
    return all_stats

def save_stats(stats: Dict, filename: str = "all_club_stats.json"):
    """Save stats to a JSON file."""
    output_path = Path(filename)
    with output_path.open('w') as f:
        json.dump(stats, f, indent=2)
    print(f"\nStats saved to {filename}")

if __name__ == "__main__":
    stats = fetch_all_club_stats()
    save_stats(stats)

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

BASE_URL = "https://usarugbystats.com/api/stats/club"
TEAM_ID = "696"

SEASONS = [
    "2021-2022",
    "2019-2020", 
    "2018-2019",
    "2017-2018",
    "2016-2017",
    "2015-2016",
    "2014-2015"
]

ENDPOINTS = {
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

def fetch_stats(stat_type: str, season: str) -> Dict:
    """Fetch stats for a specific endpoint and season."""
    url = f"{BASE_URL}/{stat_type}/{TEAM_ID}/{season}"
    response = requests.get(url)
    response.raise_for_status()
    return response.json()

def fetch_all_stats() -> Dict:
    """Fetch all stats for all seasons."""
    all_stats = {}
    
    for season in SEASONS:
        season_stats = {}
        for endpoint, stat_name in ENDPOINTS.items():
            try:
                data = fetch_stats(endpoint, season)
                season_stats[stat_name] = data
                print(f"Successfully fetched {stat_name} for {season}")
            except requests.exceptions.RequestException as e:
                print(f"Error fetching {stat_name} for {season}: {e}")
        
        all_stats[season] = season_stats
    
    return all_stats

def save_stats(stats: Dict, filename: str = "rugby_stats.json"):
    """Save stats to a JSON file."""
    output_path = Path(filename)
    with output_path.open('w') as f:
        json.dump(stats, f, indent=2)
    print(f"Stats saved to {filename}")

if __name__ == "__main__":
    stats = fetch_all_stats()
    save_stats(stats)

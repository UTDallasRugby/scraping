# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a rugby statistics archival project focused on preserving UTD Rugby team data from the defunct USA Rugby stats system (usarugbystats.com). The project combines multiple data collection approaches (API fetching, web scraping) with a data visualization frontend built using Evidence.dev.

**Team ID**: 696 (UTD Rugby)

## Architecture

The project has three main components:

### 1. Data Collection Scripts (Root Directory)

**API Fetchers** (preferred method):
- `api_fetcher.py` - Fetches stats for hardcoded seasons (2014-2022)
- `club_stats_fetcher.py` - More flexible, auto-generates season ranges
- Both scripts use the USA Rugby Stats API: `https://usarugbystats.com/api/stats/club/{endpoint}/{team_id}/{season}`

**Stat Endpoints**: pts (points), tr (tries), cv (conversions), pk (penalty kicks), dg (drop goals), started, played (games), yc (yellow cards), rc (red cards)

**Web Scrapers** (fallback):
- `utd_rugby_stats/` - Scrapy project for scraping embed pages
- `scrap_games.py` and `scrap_player.py` - Individual scrapers

**Output**: JSON files (`rugby_stats.json`, `all_club_stats.json`)

### 2. Data Analysis (SQL Files)

DuckDB-based SQL scripts for analyzing the JSON data:
- `analyze_rugby_stats.sql` - Main analysis queries (points leaders, tries, games played, disciplinary records)
- `points_and_tries.sql` - Focused analysis on scoring stats
- `pull_stats.sql` and `analyze_stats.sql` - Additional analysis queries

All scripts use DuckDB's `read_json_auto()` to load and query JSON directly.

### 3. Frontend Visualization (`frontend/`)

Evidence.dev application for interactive data visualization:
- **Data Source**: DuckDB database at `frontend/sources/needful_things/needful_things.duckdb`
- **Pages**: Markdown files in `frontend/pages/` (currently shows demo data)
- **Connection**: Configured in `frontend/sources/needful_things/connection.yaml`

## Common Commands

### Data Collection

Run API fetchers using uv:
```bash
# Fetch stats for all seasons
uv run api_fetcher.py
uv run club_stats_fetcher.py

# Run Scrapy spider
scrapy crawl season
```

### Data Analysis

Analyze stats using DuckDB:
```bash
duckdb < analyze_rugby_stats.sql
duckdb < points_and_tries.sql
```

### Frontend Development

Navigate to `frontend/` directory first:
```bash
cd frontend

# Install dependencies
npm install

# Run data sources (refresh DuckDB data)
npm run sources

# Start dev server
npm run dev

# Build for production
npm run build

# Preview production build
npm run preview
```

## Key Technical Details

- **Python Scripts**: Use uv with inline script dependencies (PEP 723)
- **Data Format**: JSON output from API/scrapers, loaded into DuckDB for analysis
- **Seasons**: Data available from 2014-2015 through 2021-2022 (2020-2021 missing due to COVID)
- **Evidence.dev**: Uses SQL queries in markdown files to generate interactive reports
- **Version Control**: Uses Jujutsu (jj) - see global CLAUDE.md for workflow

## Data Pipeline

1. **Collect**: Run Python scripts to fetch data from usarugbystats.com API → JSON files
2. **Analyze**: Query JSON files using DuckDB SQL scripts
3. **Visualize**: Load data into Evidence frontend's DuckDB database and create markdown reports

## Important Notes

- The USA Rugby stats API (`usarugbystats.com`) may be deprecated - this project preserves historical data
- The frontend currently contains Evidence.dev demo data and needs to be connected to actual rugby stats
- Season 2020-2021 data is missing (likely due to COVID-19 pandemic)

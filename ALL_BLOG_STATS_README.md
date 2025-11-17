# Complete Blog Stats Extraction Summary

## Overview

This document summarizes rugby statistics extracted from **all 254 blog posts** (2011-2018) from the UTD Rugby blog using web scraping and the `parse_blog_stats.py` extraction framework.

## Extraction Results

### Comparison: RSS Feed vs All Blog Posts

| Metric               | RSS Feed (10 posts) | All Blogs (254 posts) | Increase |
| -------------------- | ------------------- | --------------------- | -------- |
| **Matches**          | 6                   | **169**               | 28x      |
| **Try Scorers**      | 7                   | **33**                | 4.7x     |
| **Conversions**      | 2                   | **2**                 | 1x       |
| **Lineup Entries**   | 49                  | **1612**              | 33x      |
| **Posts with Stats** | 3/10 (30%)          | **84/254 (33%)**      | -        |

### Files Generated

| File                       | Records | Description                                    |
| -------------------------- | ------- | ---------------------------------------------- |
| `all_blog_matches.csv`     | 169     | Match scores and results (2011-2018)           |
| `all_blog_try_scorers.csv` | 33      | Players who scored tries                       |
| `all_blog_conversions.csv` | 2       | Conversions and penalty kicks                  |
| `all_blog_lineups.csv`     | 1612    | Team lineups by position (starters & reserves) |

### Historical Coverage

Match data extracted by year:

```
2011:  9 matches
2012: 29 matches
2013: 31 matches
2014: 32 matches
2015: 26 matches
2016: 23 matches
2017: 13 matches
2018:  6 matches
```

**Total timespan**: October 2011 - August 2018 (7 seasons)

## Data Collection Process

### 1. Blog Post Discovery

Script: `scrape_all_blog_posts.py`

- Crawled all 26 pages of the paginated blog at `utdallasrugby.weebly.com/tonys-blog`
- Found 254 total blog posts
- Saved post metadata to `blog_post_links.txt`

### 2. Content Fetching and Parsing

Script: `fetch_and_parse_all_blogs.py`

- Fetched full HTML content for all 254 posts
- Extracted blog content using BeautifulSoup
- Applied regex extraction patterns from `parse_blog_stats.py`
- Collected stats from 84 posts (33% hit rate)
- Output to 4 CSV files

### Processing Details

- **Polite crawling**: 0.5 second delay between requests
- **Total fetch time**: ~2-3 minutes
- **Success rate**: 254/254 posts fetched (100%)
- **Stats hit rate**: 84/254 posts contained extractable stats (33%)

## Sample Data

### Recent Matches (2017-2018)

```csv
date,opponent,utd_score,opponent_score,confidence,notes,source_title
2/24/2018,Texas St.,40,33,high,,Recap of 1st day of Lonestar Playoffs
1/28/2018,ACU,55,0,high,,Recap of Abilene Christian match
1/21/2018,UNT,3,64,high,,Recap of UNT friendly
12/3/2017,SFA,96,0,high,,Recap of SFA match
11/12/2017,Quins U23,5,12,high,,Recap of Dallas Harlequins U23 Friendly
10/22/2017,Trinity,53,5,high,,UTD Men continue road down unbeaten street
```

### Historical Matches (2011-2012)

```csv
date,opponent,utd_score,opponent_score,confidence,notes,source_title
11/20/2011,Midwestern St.,47,0,high,,UT Dallas still undefeated midway through the season
11/13/2011,Tyler JC,51,15,high,,UT Dallas v Tyler Jr. College
10/27/2011,UD,12,62,high,,UT Dallas vs. Univeristy of Dallas
4/15/2012,UPS,11,10,high,,UT Dallas' Run in the NSCRO Playoffs
3/25/2012,Lamar,44,5,high,,UT Dallas First Playoff match vs Lamar
```

## Data Quality Notes

### Confidence Levels

Each record includes a `confidence` field:

- **High** (95% of matches): Clear pattern matches like "UTD 55, ACU 0"
- **Medium** (5% of matches): Narrative mentions, half-time scores, or unclear opponents

### Known Data Quality Issues

1. **Duplicate/Intermediate Scores**: Some posts contain both intermediate and final scores
2. **Unknown Opponents**: A small number of matches have opponent = "Unknown" (extracted from narrative)
3. **Half-time Scores**: Some entries are half-time scores rather than final scores
4. **Opponent Name Variations**: Same opponent may appear with different abbreviations (e.g., "LTU", "Letourneau", "LeTourneau")
5. **Multiple Matches**: Some posts cover multiple matches or matches with multiple sides (1st XV, 2nd XV, etc.)

### Extraction Limitations

- **Try scorers**: Only 33 extracted (likely many more in narrative text that didn't match patterns)
- **Conversions**: Only 2 extracted (limited pattern coverage for conversion stats)
- **Lineups**: 1612 entries successfully extracted from numbered position lists
- **Matches**: 169 extracted with high accuracy

## Usage Recommendations

### 1. Data Cleaning Tasks

Before integrating with your main dataset:

**Opponent Name Standardization**:

```sql
-- Use DuckDB to standardize opponent names
SELECT DISTINCT opponent FROM read_csv_auto('all_blog_matches.csv') ORDER BY opponent;
-- Manually create a mapping for variations (LTU → LeTourneau, etc.)
```

**Remove Duplicates**:

```sql
-- Identify potential duplicate matches (same date/opponent)
SELECT date, opponent, COUNT(*) as count
FROM read_csv_auto('all_blog_matches.csv')
WHERE confidence = 'high'
GROUP BY date, opponent
HAVING count > 1;
```

**Filter Non-Final Scores**:

```csv
# Remove or fix entries with notes like "Half-time score (tied)"
# Review medium-confidence entries manually
```

### 2. Integration with API Data

This blog data covers 2011-2018, overlapping with your API data (2014-2022):

**Overlap Period**: 2014-2018 (5 seasons)

You can:

1. Use blog data to **fill gaps** where API data is missing
2. **Cross-validate** stats from both sources for 2014-2018
3. Use blog data for **2011-2013** seasons (pre-API data)

### 3. Analysis Examples

**Points scored by season**:

```sql
SELECT
    SUBSTR(date, 7, 4) as year,
    SUM(utd_score) as total_points,
    COUNT(*) as matches,
    ROUND(AVG(utd_score), 1) as avg_points_per_match
FROM read_csv_auto('all_blog_matches.csv')
WHERE confidence = 'high'
GROUP BY year
ORDER BY year;
```

**Win/loss record**:

```sql
SELECT
    CASE
        WHEN utd_score > opponent_score THEN 'Win'
        WHEN utd_score < opponent_score THEN 'Loss'
        ELSE 'Draw'
    END as result,
    COUNT(*) as count
FROM read_csv_auto('all_blog_matches.csv')
WHERE confidence = 'high'
GROUP BY result;
```

**Top opponents by frequency**:

```sql
SELECT
    opponent,
    COUNT(*) as matches,
    SUM(CASE WHEN utd_score > opponent_score THEN 1 ELSE 0 END) as wins
FROM read_csv_auto('all_blog_matches.csv')
WHERE confidence = 'high' AND opponent != 'Unknown'
GROUP BY opponent
HAVING matches >= 3
ORDER BY matches DESC;
```

## Technical Details

### Scripts

1. **`scrape_all_blog_posts.py`**

   - Discovers all blog posts via pagination
   - Outputs: `blog_post_links.txt`

2. **`fetch_and_parse_all_blogs.py`**

   - Fetches full content for all posts
   - Imports extraction functions from `parse_blog_stats.py`
   - Outputs: 4 CSV files

3. **`parse_blog_stats.py`**
   - Core extraction logic (regex patterns)
   - Originally designed for RSS feed
   - Reusable for web-scraped content

### Extraction Patterns

**Match scores**:

- Direct: `"UTD 55, ACU 0"`, `"UT Dallas 40, Texas St. 33"`
- Opponent-first: `"UNT 64 to UT Dallas' 3"`
- Narrative: `"losing 57 to 0"`, `"tied 17-17"`

**Try scorers**:

- Parenthetical: `"Jackson (3 Trys)"`
- List: `"Lewis, Eric, Aly scoring 1 Try each"`
- Narrative: `"Daniel managed to score a try"`

**Lineups**:

- Numbered lists: positions 1-15 (starters), 16+ (reserves)
- Handles multiple matches in same post

## Next Steps

### 1. Manual Data Cleaning

Priority tasks:

- [ ] Standardize opponent names (create mapping table)
- [ ] Remove or annotate half-time scores
- [ ] Review and fix "Unknown" opponents
- [ ] Remove duplicate/intermediate scores
- [ ] Add season labels (derive from date)

### 2. Integration Planning

Decide on integration approach:

**Option A**: Merge into `rugby_stats.json`

- Add blog data for seasons 2011-2013 (pre-API)
- Use as supplementary source for 2014-2018

**Option B**: Separate blog dataset

- Keep blog stats separate from API data
- Use for historical analysis and validation

**Option C**: Evidence.dev blog stats source

- Create `frontend/sources/blog_stats/` directory
- Add JavaScript loaders for blog CSV files
- Create dedicated pages for historical data

### 3. Validation

Cross-reference with other sources:

- Compare API stats with blog stats for overlapping seasons
- Look for discrepancies in match scores
- Validate player names against API data

## Data Provenance

- **Source**: utdallasrugby.weebly.com (Tony's Blog)
- **Extraction Date**: 2025-11-16
- **Scripts**: `scrape_all_blog_posts.py`, `fetch_and_parse_all_blogs.py`, `parse_blog_stats.py`
- **Coverage**: 254 blog posts (October 2011 - August 2018)
- **Posts with stats**: 84 (33%)
- **Test Coverage**: 16 regression tests in `test_parse_blog_stats.py`

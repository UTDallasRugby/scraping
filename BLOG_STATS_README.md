# Blog Stats Extraction Summary

## Overview

This document summarizes the rugby statistics extracted from the old blog posts in `static/old_feed.xml` using the `parse_blog_stats.py` script.

## Extraction Results

### Files Generated

| File                   | Records | Description              |
| ---------------------- | ------- | ------------------------ |
| `blog_matches.csv`     | 4       | Match scores and results |
| `blog_try_scorers.csv` | 6       | Players who scored tries |
| `blog_conversions.csv` | 1       | Conversion statistics    |
| `blog_lineups.csv`     | 49      | Team lineups by position |

### Source Posts Analyzed

The script processed **10 blog posts** from the RSS feed (2018-01-21 to 2018-08-14). Only 3 posts contained extractable statistics:

1. **"Recap of Abilene Christian match"** (2018-01-28)

   - 1 match, 6 try scorers, 1 conversion stat, 21 lineup entries

2. **"Recap of 1st day of Lonestar Playoffs"** (2018-02-24)

   - 3 match scores, 0 try scorers, 0 conversions, 0 lineups

3. **"Recap of UNT friendly"** (2018-01-21)
   - 0 matches, 0 try scorers, 0 conversions, 28 lineup entries

## Data Quality Notes

### Confidence Levels

Each record includes a `confidence` field:

- **High**: Clear pattern match (e.g., "UTD 55, ACU 0" or "Jackson (3 Trys)")
- **Medium**: Extracted from narrative or lists (e.g., "Lewis, Eric, Aly scoring 1 Try each")

### Known Issues for Manual Review

#### 1. Duplicate Match Scores (Texas St. on 2018-02-24)

Two scores were extracted from the same match:

```csv
2018-02-24,Texas St.,33,31,high,,Recap of 1st day of Lonestar Playoffs
2018-02-24,Texas St.,40,33,high,,Recap of 1st day of Lonestar Playoffs
```

**Context**: The blog post mentions both the score during play (33-31) and the final score (40-33).

**Action Required**: Keep only the final score (40-33) and delete the intermediate score.

#### 2. Half-Time Score (2018-02-24)

One record is a half-time score (tied 17-17) rather than a final score:

```csv
2018-02-24,Unknown,17,17,medium,Half-time score (tied),Recap of 1st day of Lonestar Playoffs
```

**Context**: From UD vs UTD match (first half ended 17-17, UD won 22-17).

**Action Required**: Either delete this entry or update it with the final score and opponent.

#### 3. Missing Opponent for Half-Time Score

The half-time score entry has `opponent: "Unknown"` because the regex couldn't definitively match it.

**Action Required**: From the blog context, the opponent was University of Dallas (UD). Update manually if needed.

## Usage Recommendations

### 1. Manual Data Cleaning

Before integrating with your main dataset:

```bash
# Review the CSV files
cat blog_matches.csv
cat blog_try_scorers.csv
cat blog_conversions.csv
cat blog_lineups.csv
```

Manually fix the issues noted above by editing the CSV files.

### 2. Integration with Main Dataset

After cleaning, you can:

**Option A: Merge into existing JSON**

- Manually add cleaned entries to `rugby_stats.json` under appropriate seasons

**Option B: Create separate analysis**

- Use DuckDB to query the blog stats alongside your API data:

```sql
-- Load and analyze blog stats
SELECT
    date,
    opponent,
    utd_score,
    opponent_score,
    source_title
FROM read_csv_auto('blog_matches.csv')
ORDER BY date;
```

**Option C: Add to Evidence.dev**

- Create new JavaScript sources in `frontend/sources/blog_stats/` to load these CSVs
- Add corresponding pages to visualize historical blog data

### 3. Verification Against API Data

Compare blog stats with API data for overlapping seasons (2017-2018):

```sql
-- Example: Compare player stats
SELECT
    b.player_name,
    b.tries_scored AS blog_tries,
    a.tries AS api_tries
FROM read_csv_auto('blog_try_scorers.csv') b
LEFT JOIN read_json_auto('rugby_stats.json') a
    ON b.player_name = a.person.display_name
WHERE a.season = '2017-2018';
```

## Script Details

### Running the Parser

```bash
# Extract stats from the XML feed
uv run parse_blog_stats.py

# Output files are written to the current directory
ls -lh blog_*.csv
```

### Running Tests

A comprehensive test suite ensures the parser doesn't regress on known blog posts:

```bash
# Run all tests
uv run pytest test_parse_blog_stats.py -v

# Run specific test class
uv run pytest test_parse_blog_stats.py::TestAbilenChristianRecap -v

# Run tests with coverage
uv run pytest test_parse_blog_stats.py -v --tb=short
```

**Test Coverage** (16 tests):

- ✅ Abilene Christian match extraction (4 tests)
- ✅ Lonestar Playoffs extraction (2 tests)
- ✅ UNT friendly lineup extraction (1 test)
- ✅ HTML cleaning (2 tests)
- ✅ Edge cases and error handling (4 tests)
- ✅ Data quality and confidence scoring (3 tests)

The tests use actual content from the blog posts to prevent regressions.

### Extraction Patterns

The script uses regex patterns to extract:

- **Match scores**: `"UTD 55, ACU 0"`, `"UT Dallas 40, Texas St. 33"`
- **Try scorers**: `"Jackson (3 Trys)"`, `"Lewis, Eric scoring 1 Try each"`
- **Conversions**: `"Lewis Hopkins converted 5 of 9 Trys"`
- **Lineups**: Numbered position lists (1-15 starters, 16+ reserves)

### Limitations

1. **Unstructured text**: Stats embedded in narrative prose are harder to extract accurately
2. **Variations**: Different authors use different formats for scores/stats
3. **Context**: Cannot always distinguish between intermediate and final scores
4. **Missing data**: Many posts (7/10) had no extractable stats

## Next Steps

1. **Manual review**: Check the CSV files and fix the known issues above
2. **Validation**: Cross-reference with any other sources (photos, memory, etc.)
3. **Integration**: Decide how to incorporate this data into your main dataset
4. **Expansion**: If more blog posts exist in other XML exports, run the parser on those too

## Data Provenance

- **Source**: `static/old_feed.xml` (RSS 2.0 feed from utdallasrugby.weebly.com)
- **Extraction Date**: 2025-11-16
- **Parser**: `parse_blog_stats.py` (uv Python script)
- **Coverage**: 10 blog posts (2018-01-21 to 2018-08-14)

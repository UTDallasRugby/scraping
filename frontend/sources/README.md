# Data Sources

This directory contains data source configurations for the Evidence.dev frontend.

## Overview

Evidence.dev sources execute queries against data sources and cache results as Parquet files. Each subdirectory represents one data source, containing:

- `connection.yaml` - Data source configuration
- Query files (`.js` or `.sql`) - One file per table

## Available Sources

### rugby_stats

**Type**: JavaScript
**Description**: UTD Rugby statistics from 2014-2022 seasons
**Location**: `sources/rugby_stats/`

#### Configuration

```yaml
name: rugby_stats
type: javascript
```

JavaScript sources load data using Node.js. Each `.js` file exports a `data` array that becomes a table in Evidence.

#### Data Tables

The rugby_stats source provides 7 tables, all flattened from the nested `rugby_stats.json` file:

1. **all_points** (35 rows)

   - `season` (string): Season identifier (e.g., "2021-2022")
   - `player_name` (string): Player's display name
   - `points` (number): Total points scored

2. **all_tries** (35 rows)

   - `season` (string): Season identifier
   - `player_name` (string): Player's display name
   - `tries` (number): Total tries scored

3. **all_conversions** (17 rows)

   - `season` (string): Season identifier
   - `player_name` (string): Player's display name
   - `conversions` (number): Total conversion kicks made

4. **all_penalty_kicks** (6 rows)

   - `season` (string): Season identifier
   - `player_name` (string): Player's display name
   - `penalty_kicks` (number): Total penalty kicks made

5. **all_games_played** (35 rows)

   - `season` (string): Season identifier
   - `player_name` (string): Player's display name
   - `games` (number): Total games played

6. **all_yellow_cards** (10 rows)

   - `season` (string): Season identifier
   - `player_name` (string): Player's display name
   - `yellow_cards` (number): Total yellow cards received

7. **all_red_cards** (4 rows)
   - `season` (string): Season identifier
   - `player_name` (string): Player's display name
   - `red_cards` (number): Total red cards received

#### Seasons Covered

Data spans 7 seasons (2020-2021 missing due to COVID-19):

- 2021-2022
- 2019-2020
- 2018-2019
- 2017-2018
- 2016-2017
- 2015-2016
- 2014-2015

#### Source Data

**Source file**: `/Users/emiller/src/personal/rugby-scraping/rugby_stats.json`

**Original structure** (nested):

```json
{
  "2021-2022": {
    "points": [
      {
        "person": {"display_name": "Player Name"},
        "pts": 100
      }
    ],
    "tries": [...],
    ...
  }
}
```

**Flattened structure** (exported):

```javascript
[
  {
    season: "2021-2022",
    player_name: "Player Name",
    points: 100,
  },
];
```

#### How the Flattening Works

Each JavaScript loader file (e.g., `all_points.js`) follows this pattern:

1. **Read JSON file** using Node.js `fs.readFileSync()`
2. **Iterate through seasons** (all 7 hardcoded)
3. **Extract stat array** from nested structure (e.g., `seasonData.points`)
4. **Flatten each entry** to simple object with primitive types:
   - Extract season string
   - Extract player name from nested `person.display_name`
   - Extract stat value, parse as integer
   - Filter out zero/null values
5. **Export as `{ data }`** array

Example from `all_points.js`:

```javascript
import { readFileSync } from "fs";
import { fileURLToPath } from "url";
import { dirname, join } from "path";

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const jsonPath = join(__dirname, "../../../rugby_stats.json");
const rawData = readFileSync(jsonPath, "utf8");
const jsonData = JSON.parse(rawData);

const seasons = [
  "2021-2022",
  "2019-2020",
  "2018-2019",
  "2017-2018",
  "2016-2017",
  "2015-2016",
  "2014-2015",
];

const data = [];

for (const season of seasons) {
  const seasonData = jsonData[season];
  if (!seasonData || !seasonData.points) continue;

  for (const entry of seasonData.points) {
    const points = parseInt(entry.pts, 10);
    if (points && points > 0) {
      data.push({
        season: season,
        player_name: entry.person?.display_name || "Unknown",
        points: points,
      });
    }
  }
}

export { data };
```

#### Querying in Pages

Use standard DuckDB SQL in markdown pages:

```sql
SELECT * FROM rugby_stats.all_points
WHERE season = '2021-2022'
ORDER BY points DESC
LIMIT 10
```

#### Refreshing Data

When the source JSON file or loader files change:

```bash
cd frontend
npm run sources
```

Output shows row counts for each table:

```
all_conversions ✔ Finished, wrote 17 rows.
all_games_played ✔ Finished, wrote 35 rows.
all_penalty_kicks ✔ Finished, wrote 6 rows.
all_points ✔ Finished, wrote 35 rows.
all_red_cards ✔ Finished, wrote 4 rows.
all_tries ✔ Finished, wrote 35 rows.
all_yellow_cards ✔ Finished, wrote 10 rows.
```

#### Common Issues

**Problem**: "No { data } object exported"

- **Cause**: JavaScript file doesn't export `data` variable
- **Fix**: Ensure file ends with `export { data };`

**Problem**: "Nested objects not supported"

- **Cause**: Data array contains objects or arrays
- **Fix**: Flatten all nested structures to primitive types (string, number, boolean, Date)

**Problem**: Data not updating in browser

- **Cause**: Parquet cache not refreshed
- **Fix**: Run `npm run sources` after changing source files

**Problem**: Stale cache or errors

- **Cause**: Corrupted cache files
- **Fix**: `rm -rf .evidence .evidence-cache && npm run sources`

## Adding New Data Sources

### JavaScript Source

1. Create directory: `sources/[source_name]/`
2. Create `connection.yaml`:
   ```yaml
   name: source_name
   type: javascript
   ```
3. Create `.js` loader files:

   ```javascript
   // Load data from file, API, or hardcode
   const data = [
     { col1: "value", col2: 123 },
     // ... primitive types only
   ];

   export { data };
   ```

4. Run `npm run sources` to generate cache
5. Query in pages: `SELECT * FROM source_name.table_name`

### SQL Source (DuckDB)

1. Create directory: `sources/[source_name]/`
2. Create `connection.yaml`:
   ```yaml
   name: source_name
   type: duckdb
   options:
     filename: path/to/database.duckdb
   ```
3. Create `.sql` query files:
   ```sql
   SELECT * FROM my_table;
   ```
4. Run `npm run sources`

**Note**: DuckDB sources require an existing `.duckdb` database file. You cannot use `read_json_auto()` or similar functions to load external files in source queries.

## File Organization

```
sources/
├── README.md (this file)
└── rugby_stats/
    ├── connection.yaml
    ├── all_points.js
    ├── all_tries.js
    ├── all_conversions.js
    ├── all_penalty_kicks.js
    ├── all_games_played.js
    ├── all_yellow_cards.js
    └── all_red_cards.js
```

**Important**: Do not place `.md` or documentation files in source subdirectories (e.g., `rugby_stats/`). Evidence processes ALL files in those directories, and non-query files may cause errors. Keep documentation at `sources/README.md` level.

## See Also

- `frontend/CLAUDE.md` - Evidence.dev architecture guide
- Root `CLAUDE.md` - Overall project documentation
- https://evidence.dev/docs/data-sources - Official Evidence.dev data source docs

# Evidence.dev: Flatten JSON Data

Convert nested JSON structures to Evidence.dev-compatible flat arrays.

## When to Use This Skill

Use this skill when:

- You have nested JSON data that needs to be loaded into Evidence.dev
- You encounter "Nested objects not supported" errors
- You need to transform complex data structures to primitive types
- You're migrating from SQL-based data loading to JavaScript sources

## What This Skill Does

1. Analyzes nested JSON structures
2. Identifies flattening strategies
3. Generates JavaScript code to flatten data
4. Ensures all output uses primitive types only (string, number, boolean, Date)
5. Handles common nesting patterns (objects, arrays, multi-level nesting)

## Evidence.dev Data Constraints

Evidence JavaScript sources can only export data with **primitive types**:

✅ **Allowed types:**

- `string`
- `number`
- `boolean`
- `Date`

❌ **Not allowed:**

- Nested objects: `{ user: { name: "John" } }`
- Arrays: `{ tags: ["a", "b", "c"] }`
- null/undefined (filter these out)
- Functions, classes, other complex types

## Flattening Patterns

### Pattern 1: Nested Objects

**Original Structure:**

```json
{
  "person": {
    "name": "John Doe",
    "id": 123
  },
  "stats": {
    "points": 100,
    "tries": 5
  }
}
```

**Flattening Strategy:**
Move nested properties to top level with descriptive names.

**JavaScript Code:**

```javascript
const data = [];

for (const entry of jsonData) {
  data.push({
    person_name: entry.person.name, // Flattened
    person_id: entry.person.id, // Flattened
    stats_points: entry.stats.points, // Flattened
    stats_tries: entry.stats.tries, // Flattened
  });
}

export { data };
```

### Pattern 2: Array of Items

**Original Structure:**

```json
{
  "player": "John Doe",
  "seasons": ["2020", "2021", "2022"]
}
```

**Flattening Strategy:**
Create one row per array item (denormalize).

**JavaScript Code:**

```javascript
const data = [];

for (const entry of jsonData) {
  // Create one row per season
  for (const season of entry.seasons) {
    data.push({
      player: entry.player,
      season: season, // Denormalized
    });
  }
}

export { data };
```

**Alternative Strategy (if array is small):**
Convert array to delimited string.

```javascript
const data = [];

for (const entry of jsonData) {
  data.push({
    player: entry.player,
    seasons: entry.seasons.join(", "), // "2020, 2021, 2022"
  });
}

export { data };
```

### Pattern 3: Nested Seasons/Time Periods

**Original Structure:**

```json
{
  "2021-2022": {
    "points": [{ "person": { "display_name": "John" }, "pts": 100 }]
  },
  "2020-2021": {
    "points": [{ "person": { "display_name": "Jane" }, "pts": 75 }]
  }
}
```

**Flattening Strategy:**
Iterate through all seasons, add season as a column.

**JavaScript Code:**

```javascript
const data = [];

const seasons = ["2021-2022", "2020-2021", "2019-2020"];

for (const season of seasons) {
  const seasonData = jsonData[season];
  if (!seasonData || !seasonData.points) continue;

  for (const entry of seasonData.points) {
    const points = parseInt(entry.pts, 10);
    if (points && points > 0) {
      data.push({
        season: season, // Added as column
        player_name: entry.person?.display_name || "Unknown",
        points: points,
      });
    }
  }
}

export { data };
```

### Pattern 4: Deep Nesting (3+ levels)

**Original Structure:**

```json
{
  "team": {
    "info": {
      "name": "UTD Rugby",
      "location": {
        "city": "Dallas",
        "state": "TX"
      }
    },
    "stats": {
      "wins": 10
    }
  }
}
```

**Flattening Strategy:**
Flatten all levels, using dotted or underscored naming.

**JavaScript Code:**

```javascript
const data = [];

for (const entry of jsonData) {
  data.push({
    team_name: entry.team.info.name,
    team_city: entry.team.info.location.city,
    team_state: entry.team.info.location.state,
    team_wins: entry.team.stats.wins,
  });
}

export { data };
```

### Pattern 5: Mixed Types (Dates, Numbers as Strings)

**Original Structure:**

```json
{
  "date": "2023-01-15",
  "value": "100",
  "active": "true"
}
```

**Flattening Strategy:**
Convert to proper primitive types.

**JavaScript Code:**

```javascript
const data = [];

for (const entry of jsonData) {
  data.push({
    date: new Date(entry.date), // string → Date
    value: Number(entry.value), // string → number
    active: entry.active === "true", // string → boolean
  });
}

export { data };
```

## Step-by-Step Flattening Process

### Step 1: Analyze the Source Data

Read the source file and understand its structure:

```javascript
import { readFileSync } from "fs";

const data = JSON.parse(readFileSync("data.json", "utf8"));

// Log first few records to understand structure
console.log(JSON.stringify(data, null, 2).slice(0, 500));
```

### Step 2: Identify Nesting Patterns

Ask yourself:

1. Are there nested objects? Which properties?
2. Are there arrays? How should they be denormalized?
3. Are there multiple levels (seasons, years, categories)?
4. What are the key fields that should become columns?

### Step 3: Design the Flat Schema

Decide what columns the flat data should have:

```javascript
// Target schema (all primitive types):
{
  season: string,
  player_name: string,
  player_id: number,
  points: number,
  team_name: string
}
```

### Step 4: Write the Flattening Code

Template for JavaScript source file:

```javascript
import { readFileSync } from "fs";
import { fileURLToPath } from "url";
import { dirname, join } from "path";

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

// Load source data
const jsonPath = join(__dirname, "../../../source_data.json");
const rawData = readFileSync(jsonPath, "utf8");
const jsonData = JSON.parse(rawData);

// Initialize flat data array
const data = [];

// Flattening logic goes here
// (Use patterns from above based on your data structure)

// Example: Nested seasons with array of stats
for (const season in jsonData) {
  for (const entry of jsonData[season].stats_array) {
    data.push({
      season: season,
      field1: entry.nested.field1,
      field2: entry.nested.field2,
      value: Number(entry.value),
    });
  }
}

// Export for Evidence
export { data };
```

### Step 5: Test the Flattening

Run the file directly with Node.js:

```bash
node frontend/sources/[source_name]/[table].js
```

Should output the flattened data (if you add `console.log(data)` before export).

### Step 6: Validate Data Types

Add type validation before export:

```javascript
// Before export { data };
const sampleRecord = data[0];
console.log(
  "Data types:",
  Object.keys(sampleRecord)
    .map(
      (key) =>
        `${key}: ${sampleRecord[key] instanceof Date ? "Date" : typeof sampleRecord[key]}`,
    )
    .join(", "),
);

// Check for nested objects
const hasNestedObjects = data.some((record) =>
  Object.values(record).some(
    (val) => val !== null && typeof val === "object" && !(val instanceof Date),
  ),
);

if (hasNestedObjects) {
  console.error("ERROR: Data contains nested objects!");
  process.exit(1);
}

export { data };
```

### Step 7: Run in Evidence

```bash
cd frontend
npm run sources
```

Should output:

```
[source_name]:
  [table] ✔ Finished, wrote X rows.
```

## Common Flattening Challenges

### Challenge 1: Optional/Missing Fields

**Problem:** Some records have fields, others don't.

```json
{"name": "John", "stats": {"points": 100}}  // Has stats
{"name": "Jane"}  // Missing stats
```

**Solution:** Use optional chaining and defaults:

```javascript
data.push({
  name: entry.name,
  points: entry.stats?.points || 0, // Default to 0 if missing
  has_stats: Boolean(entry.stats), // Track if stats existed
});
```

### Challenge 2: Dynamic Keys

**Problem:** Object keys are data (not known in advance).

```json
{
  "2021": 100,
  "2022": 150,
  "2023": 200
}
```

**Solution:** Denormalize into rows:

```javascript
for (const year in entry) {
  data.push({
    year: year,
    value: entry[year],
  });
}
```

### Challenge 3: Arrays of Different Length

**Problem:** Each record has a different number of array items.

```json
{"player": "John", "games": [1, 2, 3, 4, 5]}  // 5 games
{"player": "Jane", "games": [1, 2]}  // 2 games
```

**Solution:** Create one row per game:

```javascript
for (const entry of jsonData) {
  for (const game of entry.games) {
    data.push({
      player: entry.player,
      game_id: game,
    });
  }
}
```

### Challenge 4: Null Values

**Problem:** Data contains null values.

```json
{ "name": "John", "value": null }
```

**Solution:** Filter or convert nulls:

```javascript
data.push({
  name: entry.name,
  value: entry.value !== null ? Number(entry.value) : 0, // Convert null to 0
  has_value: entry.value !== null, // Track if value existed
});

// Or filter out nulls entirely:
if (entry.value !== null) {
  data.push({
    name: entry.name,
    value: Number(entry.value),
  });
}
```

## Real-World Example: Rugby Stats

The rugby_stats source in this project demonstrates flattening a complex nested JSON:

**Original Structure:**

```json
{
  "2021-2022": {
    "points": [
      {
        "person": {"display_name": "John Doe", "id": 123},
        "pts": "100"
      }
    ],
    "tries": [...]
  },
  "2020-2021": {...}
}
```

**Flattened to 7 Tables:**

- all_points
- all_tries
- all_conversions
- all_penalty_kicks
- all_games_played
- all_yellow_cards
- all_red_cards

**Key Flattening Decisions:**

1. Season keys → `season` column
2. Nested `person.display_name` → `player_name` column
3. String numbers ("100") → parsed to integers
4. Multiple stat types → separate tables (not one wide table)
5. Zero/null values → filtered out

**See:** `frontend/sources/rugby_stats/all_points.js` for full implementation.

## Type Conversion Reference

| Original Type    | Target Type | Conversion Code                      |
| ---------------- | ----------- | ------------------------------------ |
| String number    | number      | `Number(val)` or `parseInt(val, 10)` |
| String boolean   | boolean     | `val === 'true'` or `Boolean(val)`   |
| String date      | Date        | `new Date(val)`                      |
| Nested string    | string      | `obj.nested.field`                   |
| Array of strings | string      | `arr.join(', ')`                     |
| Array of objects | Denormalize | Create row per item                  |

## Validation Checklist

Before finalizing flattened data:

- [ ] All values are primitive types (string, number, boolean, Date)
- [ ] No nested objects remain
- [ ] No arrays remain (or converted to strings)
- [ ] Null values are handled (filtered or converted)
- [ ] Numbers are actually numbers (not strings)
- [ ] Dates are Date objects (not strings)
- [ ] Column names are descriptive and clear
- [ ] Data loss is acceptable (if denormalizing)
- [ ] Running `npm run sources` succeeds
- [ ] Expected row count is correct

## See Also

- `evidence-dev:setup-javascript-source` - Create new JavaScript sources
- `evidence-dev:troubleshoot-sources` - Debug source errors
- `frontend/sources/rugby_stats/` - Example flattening implementation
- `frontend/CLAUDE.md` - Evidence.dev architecture guide
- https://evidence.dev/docs/data-sources/javascript - Official JavaScript source docs

# Evidence.dev: Setup JavaScript Source

Set up a new JavaScript data source for an Evidence.dev project.

## When to Use This Skill

Use this skill when you need to:

- Create a new JavaScript data source in an Evidence.dev frontend
- Configure a new source directory with connection.yaml
- Generate template JavaScript loader files
- Set up proper directory structure for Evidence sources

## What This Skill Does

1. Creates source directory: `frontend/sources/[source_name]/`
2. Generates `connection.yaml` with JavaScript type configuration
3. Creates template `.js` loader files
4. Validates Evidence.dev project structure
5. Provides guidance on data flattening and export patterns

## Instructions

### Step 1: Validate Evidence.dev Project

First, verify this is an Evidence.dev project:

```bash
# Check for Evidence.dev markers
ls frontend/package.json frontend/evidence.config.yaml frontend/sources/
```

If any of these are missing, this is not an Evidence.dev project. Ask the user if they want to initialize one.

### Step 2: Gather Requirements

Ask the user:

1. **Source name**: What should this data source be called? (e.g., "rugby_stats", "user_data")
2. **Data origin**: Where is the data coming from? (JSON file, API, hardcoded, other)
3. **Table names**: What tables should this source provide? (one .js file per table)

### Step 3: Create Source Directory

```bash
mkdir -p frontend/sources/[source_name]
```

### Step 4: Create connection.yaml

Create `frontend/sources/[source_name]/connection.yaml`:

```yaml
name: [source_name]
type: javascript
```

### Step 5: Generate Template Loader Files

For each table, create a `.js` file following this pattern:

**Template for loading from JSON file:**

```javascript
import { readFileSync } from "fs";
import { fileURLToPath } from "url";
import { dirname, join } from "path";

// Get current file's directory
const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

// Load data source
const jsonPath = join(__dirname, "../../../path/to/data.json");
const rawData = readFileSync(jsonPath, "utf8");
const jsonData = JSON.parse(rawData);

// Flatten and transform data
const data = [];

// TODO: Add data processing logic here
// Example: Iterate through nested structure and flatten
for (const item of jsonData.items) {
  data.push({
    // Only primitive types: string, number, boolean, Date
    id: String(item.id),
    value: Number(item.value),
    active: Boolean(item.active),
    created_at: new Date(item.timestamp),
  });
}

// CRITICAL: Must export exactly as shown
export { data };
```

**Template for hardcoded/static data:**

```javascript
// Hardcoded data
const data = [
  {
    id: "1",
    name: "Example",
    value: 100,
    active: true,
  },
  {
    id: "2",
    name: "Another",
    value: 200,
    active: false,
  },
];

export { data };
```

**Template for API fetching:**

```javascript
// For API sources, you'll need to fetch during build time
// Evidence runs sources during npm run sources (Node.js context)
const response = await fetch("https://api.example.com/data");
const apiData = await response.json();

const data = apiData.items.map((item) => ({
  id: String(item.id),
  name: item.name,
  value: Number(item.value),
}));

export { data };
```

### Step 6: Critical Requirements

Remind the user of **Evidence.dev JavaScript source constraints**:

1. **Export format**: Must use `export { data };` (exact format)
2. **Primitive types only**: Objects can only contain:
   - `string`
   - `number`
   - `boolean`
   - `Date`
3. **No nested structures**: Flatten all nested objects/arrays before export
4. **File naming**: Filename becomes table name
   - `all_points.js` → `[source_name].all_points` table
5. **Array of objects**: `data` must be an array of objects

### Step 7: Verify Setup

After creating files:

```bash
cd frontend
npm run sources
```

Expected output:

```
[source_name]:
  [table1] ✔ Finished, wrote X rows.
  [table2] ✔ Finished, wrote Y rows.
```

If errors occur, check:

- Does each .js file export `{ data }`?
- Does data contain only primitive types?
- Is connection.yaml formatted correctly?

### Step 8: Query in Pages

Show the user how to query the new source:

```markdown
## In frontend/pages/example.md:

\`\`\`sql my_query
SELECT \* FROM [source_name].[table_name]
ORDER BY value DESC
LIMIT 10
\`\`\`

<DataTable data={my_query} />
```

## Common Patterns

### Flattening Nested JSON

If the source data is nested:

```javascript
// Original nested structure
{
  "2021": {
    "stats": [
      {
        "person": {"name": "John", "id": 123},
        "value": 100
      }
    ]
  }
}

// Flatten to:
const data = [];
for (const year in jsonData) {
  for (const entry of jsonData[year].stats) {
    data.push({
      year: year,  // string
      person_name: entry.person.name,  // string (flattened)
      person_id: entry.person.id,  // number (flattened)
      value: entry.value  // number
    });
  }
}
```

### Filtering and Validation

Add data quality checks:

```javascript
for (const item of jsonData) {
  const value = parseInt(item.value, 10);

  // Only include valid, non-zero values
  if (value && value > 0) {
    data.push({
      id: item.id,
      value: value,
    });
  }
}
```

## Troubleshooting

**Error: "No { data } object exported"**

- Fix: Ensure file ends with `export { data };`

**Error: "Nested objects not allowed"**

- Fix: Flatten all objects/arrays to primitive types

**Error: "Cannot find module"**

- Fix: Check file paths in `readFileSync()` and `import` statements

**Data not showing in pages**

- Fix: Run `npm run sources` to refresh cache
- Check terminal output for row counts

**Stale cache**

- Fix: `rm -rf frontend/.evidence frontend/.evidence-cache && npm run sources`

## File Organization

Result should look like:

```
frontend/
└── sources/
    └── [source_name]/
        ├── connection.yaml
        ├── table1.js
        ├── table2.js
        └── table3.js
```

**Important**: Do NOT add .md files or READMEs inside `sources/[source_name]/`. Evidence processes all files in this directory. Keep documentation at `sources/README.md` or `frontend/CLAUDE.md`.

## See Also

- `frontend/CLAUDE.md` - Evidence.dev architecture guide
- `frontend/sources/README.md` - Data source documentation
- `frontend/sources/rugby_stats/` - Example JavaScript source implementation
- https://evidence.dev/docs/data-sources/javascript - Official JavaScript source docs

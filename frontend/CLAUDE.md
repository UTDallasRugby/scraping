# Evidence.dev Frontend Guide

This directory contains an Evidence.dev application for visualizing UTD Rugby statistics.

## Evidence.dev Architecture

Evidence.dev uses a **USQL (Universal SQL)** architecture that separates data sourcing from querying:

### How USQL Works

1. **Source Queries** (in `sources/`)

   - Execute against actual data sources (databases, APIs, files)
   - Use the data source's native SQL dialect or JavaScript
   - Run during `npm run sources` command
   - Results are converted to compressed Parquet files

2. **Cached Data** (in `static/data/`)

   - Parquet files stored at `static/data/[source_name]/[table_name].parquet`
   - Compressed and optimized for browser loading
   - Updated only when `npm run sources` is run

3. **Browser Queries** (in `pages/`)
   - Markdown files with SQL code blocks
   - Execute against cached Parquet files using DuckDB WASM
   - Run in the browser, not against original data source
   - Fast and cost-effective (no API calls)

**Key Insight**: Source queries ≠ Page queries. Sources populate the cache, pages query the cache.

### Data Source Types

Evidence supports multiple source types, configured via `connection.yaml`:

#### JavaScript Sources

```yaml
name: my_source
type: javascript
```

**Requirements:**

- Each `.js` file exports `export { data }`
- `data` must be an array of objects
- Objects can only contain primitive types: `string`, `number`, `boolean`, `Date`
- Nested objects/arrays must be flattened before export
- File name becomes table name (e.g., `all_points.js` → `my_source.all_points` table)

#### SQL Sources (DuckDB, PostgreSQL, etc.)

```yaml
name: my_source
type: duckdb
options:
  filename: path/to/database.duckdb
```

**Requirements:**

- Each `.sql` file is a query that returns a result set
- Uses native SQL dialect of the database
- Can't use `read_json_auto()` or similar for external files (database must exist)

## Project Structure

```
frontend/
├── pages/               # Markdown pages (rendered as web pages)
│   ├── index.md        # Home page
│   ├── rugby-stats.md  # Stats dashboard
│   └── disciplinary.md # Disciplinary records
├── sources/             # Data source queries
│   └── rugby_stats/    # JavaScript source for rugby data
│       ├── connection.yaml
│       ├── all_points.js
│       ├── all_tries.js
│       └── ... (7 total tables)
├── static/              # Static assets and cached data
│   └── data/           # Parquet cache (generated, not committed)
├── partials/           # Reusable markdown components
├── package.json
└── evidence.config.yaml # Evidence configuration
```

## Common Workflows

### Development Workflow

1. **Start dev server**

   ```bash
   cd frontend
   npm run dev
   ```

   Server runs at http://localhost:3000/

2. **Modify data sources**

   - Edit `.js` or `.sql` files in `sources/`
   - Run `npm run sources` to refresh cache
   - Browser auto-reloads with new data

3. **Modify pages**
   - Edit `.md` files in `pages/`
   - Changes hot-reload automatically
   - No need to run `npm run sources`

### Data Source Workflow

1. **Create new source**

   - Create directory: `sources/[source_name]/`
   - Add `connection.yaml` with type configuration
   - Create `.js` or `.sql` query files

2. **Refresh data**

   ```bash
   npm run sources
   ```

   - Executes all source queries
   - Updates Parquet cache
   - Shows row counts for each table

3. **Query in pages**
   ```sql
   SELECT * FROM [source_name].[table_name]
   ```

### Troubleshooting

#### Cache Issues

If you see stale data or unexpected errors:

```bash
rm -rf .evidence .evidence-cache
npm run sources
```

#### Source Errors

Common issues:

- **"No { data } object exported"**: JavaScript file must use `export { data }`
- **"Nested objects not allowed"**: Flatten all objects/arrays to primitive types
- **"Database does not exist"**: DuckDB sources need existing `.duckdb` file
- **"IO Error: No files found"**: Can't use `read_json_auto()` in source queries

#### Data Not Updating

- Did you run `npm run sources` after changing source files?
- Check terminal output for errors during source execution
- Verify Parquet files updated: `ls -l static/data/[source_name]/`

## Query Syntax in Pages

Evidence pages use markdown with SQL code blocks:

````markdown
```sql my_query_name
SELECT * FROM rugby_stats.all_points
ORDER BY points DESC
LIMIT 10
```

<DataTable data={my_query_name} />
````

**Key Points:**

- Query name (e.g., `my_query_name`) is required
- Use schema.table format: `[source_name].[table_name]`
- DuckDB SQL dialect (same as DuckDB WASM)
- Results available as `{query_name}` variable

## Evidence Components

Common components for displaying data:

- `<DataTable data={query} />` - Sortable, filterable table
- `<BarChart data={query} x=col y=col />` - Bar chart
- `<LineChart data={query} x=col y=col />` - Line chart
- `<BigValue data={query} value=col />` - Single metric display
- `<Value data={query} column=col />` - Inline value

See https://evidence.dev/components for full component library.

## Best Practices

1. **Keep sources simple**: Each `.js` file = one table with flat structure
2. **Run sources frequently**: After any source file change
3. **Use specific queries**: Don't `SELECT *` if you only need a few columns
4. **Leverage caching**: Complex transformations in sources, simple queries in pages
5. **Check file exclusions**: `.md` and other docs may cause issues in `sources/` directories

## See Also

- `sources/README.md` - Data source documentation for this project
- Root `CLAUDE.md` - Overall project architecture
- https://evidence.dev/docs - Official Evidence.dev documentation

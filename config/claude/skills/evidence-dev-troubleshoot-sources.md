# Evidence.dev: Troubleshoot Sources

Diagnose and fix common Evidence.dev source issues.

## When to Use This Skill

Use this skill when you encounter:

- Errors running `npm run sources`
- Stale or incorrect data in the frontend
- Source queries not generating expected tables
- Cache-related issues
- JavaScript source export errors
- Data not updating in browser

## What This Skill Does

1. Diagnoses common Evidence.dev source errors
2. Validates source configuration and file structure
3. Checks cache integrity
4. Verifies data export formats
5. Provides targeted fixes for specific error messages

## Diagnostic Workflow

### Step 1: Identify the Error Type

Run `npm run sources` and observe the output. Common error patterns:

**Error Category 1: Export Format Errors**

```
Error: No { data } object exported
Error: data is not an array
Error: Unexpected token export
```

**Error Category 2: Data Structure Errors**

```
Error: Nested objects not supported
Error: Invalid data type
Error: Cannot serialize object
```

**Error Category 3: File/Module Errors**

```
Error: Cannot find module
Error: ENOENT: no such file or directory
Error: Unexpected identifier
```

**Error Category 4: Cache Errors**

```
Error: EISDIR: illegal operation on a directory
Error: Unexpected end of JSON input (loading cache)
INTERNAL Error: Attempted to dereference shared_ptr that is NULL!
```

**Error Category 5: Connection Errors**

```
Error: Database does not exist
Error: Cannot open database in read-only mode
Error: Connection failed
```

### Step 2: Run Diagnostics

Based on the error category, run these checks:

#### For Export Format Errors

**Check 1: Verify export syntax**

```bash
# Find all JavaScript source files and check their exports
grep -r "export" frontend/sources/ --include="*.js"
```

Look for:

- `export { data };` ✅ Correct
- `export const data = [...]` ❌ Wrong
- `export default data` ❌ Wrong
- `module.exports = { data }` ❌ Wrong (CommonJS, not ES modules)

**Fix**: Update all JavaScript files to use:

```javascript
export { data };
```

**Check 2: Verify data is an array**

```javascript
// At the end of each .js file, before export
console.log("Data type:", Array.isArray(data) ? "Array" : typeof data);
console.log("Data length:", data.length);
```

Run `npm run sources` and check console output.

**Fix**: Ensure `data` is always an array:

```javascript
const data = []; // Not an object or other type
```

#### For Data Structure Errors

**Check 1: Inspect data for nested objects/arrays**

Add temporary logging to source file:

```javascript
// Before export { data };
console.log("Sample data:", JSON.stringify(data[0], null, 2));
```

Look for nested structures:

```javascript
// ❌ BAD: Nested object
{
  name: "John",
  stats: { points: 100, tries: 5 }  // Nested object
}

// ❌ BAD: Array property
{
  name: "John",
  tags: ["player", "forward"]  // Array
}

// ✅ GOOD: Flat primitive types
{
  name: "John",
  points: 100,
  tries: 5
}
```

**Fix**: Flatten all nested structures (use `evidence-dev:flatten-json-data` skill for help).

**Check 2: Verify data types**

Only these types are allowed:

- `string`
- `number`
- `boolean`
- `Date`

**Fix**: Convert all values to primitive types:

```javascript
data.push({
  id: String(item.id), // Force to string
  value: Number(item.value), // Force to number
  active: Boolean(item.active), // Force to boolean
  created: new Date(item.timestamp), // Convert to Date
});
```

#### For File/Module Errors

**Check 1: Verify file paths**

```bash
# List all source files
find frontend/sources -type f -name "*.js" -o -name "*.sql" -o -name "connection.yaml"
```

**Check 2: Validate import paths in JavaScript files**

Look for:

```javascript
const jsonPath = join(__dirname, "../../../rugby_stats.json");
```

Verify the relative path is correct:

```bash
# From the source file location, check if path exists
ls frontend/sources/rugby_stats/../../../rugby_stats.json
# Should resolve to: rugby_stats.json in project root
```

**Fix**: Correct the relative path based on actual file location.

**Check 3: Validate connection.yaml syntax**

```bash
# Check YAML is valid
cat frontend/sources/[source_name]/connection.yaml
```

Should be:

```yaml
name: source_name
type: javascript
```

No tabs, proper indentation, no extra fields for JavaScript sources.

#### For Cache Errors

**Check 1: Inspect cache directory**

```bash
# Check cache size and modification times
ls -lR frontend/.evidence/cache/ 2>/dev/null || echo "No cache found"
ls -lR frontend/.evidence-cache/ 2>/dev/null || echo "No cache found"
```

**Check 2: Check for corrupted Parquet files**

```bash
# Check Parquet files
find frontend/static/data -name "*.parquet" -exec ls -lh {} \;
```

Look for:

- 0-byte files (corrupted)
- Very old timestamps (stale)

**Fix 1: Clear cache and rebuild**

```bash
cd frontend
rm -rf .evidence .evidence-cache static/data
npm run sources
```

**Fix 2: If specific table is corrupted**

```bash
rm -rf frontend/static/data/[source_name]/[table_name].parquet
npm run sources
```

#### For Connection Errors

**Check 1: Verify source type matches configuration**

For JavaScript sources:

```yaml
name: rugby_stats
type: javascript # Must be javascript, not duckdb
```

For DuckDB sources:

```yaml
name: my_db
type: duckdb
options:
  filename: path/to/database.duckdb # File must exist
```

**Check 2: Verify database file exists (DuckDB sources only)**

```bash
ls -lh frontend/sources/[source_name]/database.duckdb
```

**Fix**:

- For JavaScript sources: Remove `options` from connection.yaml
- For DuckDB sources: Create database file first, then configure source

### Step 3: Verify Fix

After applying fixes:

1. **Clear cache completely**

   ```bash
   cd frontend
   rm -rf .evidence .evidence-cache static/data
   ```

2. **Run sources with verbose output**

   ```bash
   npm run sources 2>&1 | tee source-output.log
   ```

3. **Check output for success**

   ```
   [source_name]:
     table1 ✔ Finished, wrote X rows.
     table2 ✔ Finished, wrote Y rows.
   ```

4. **Verify Parquet files created**

   ```bash
   find frontend/static/data/[source_name] -name "*.parquet" -exec ls -lh {} \;
   ```

5. **Test in browser**

   ```bash
   npm run dev
   ```

   Visit http://localhost:3000/ and check if data loads.

## Common Error Messages and Fixes

### "No { data } object exported"

**Cause**: JavaScript file doesn't use correct export syntax.

**Fix**:

```javascript
// At end of file
export { data }; // Must be this exact format
```

### "Nested objects not supported"

**Cause**: Data array contains objects or arrays.

**Fix**: Flatten all nested structures:

```javascript
// Before
{ name: "John", stats: { points: 100 } }

// After
{ name: "John", points: 100 }
```

Use `evidence-dev:flatten-json-data` skill for complex cases.

### "Cannot find module '../../../data.json'"

**Cause**: Relative path to data file is incorrect.

**Fix**: Verify path from source file location:

```javascript
// If source file is: frontend/sources/rugby_stats/all_points.js
// And data file is: rugby_stats.json (project root)
// Path should be:
const jsonPath = join(__dirname, "../../../rugby_stats.json");
```

### "Database does not exist"

**Cause**: Using `type: duckdb` but database file doesn't exist.

**Fix 1**: Switch to JavaScript source if loading from JSON/files:

```yaml
type: javascript # Not duckdb
```

**Fix 2**: Create database file first if using DuckDB:

```bash
duckdb my_database.duckdb < create_tables.sql
```

### "Unexpected end of JSON input" (cache loading)

**Cause**: Corrupted cache files.

**Fix**:

```bash
cd frontend
rm -rf .evidence .evidence-cache
npm run sources
```

### "EISDIR: illegal operation on a directory"

**Cause**: Evidence is trying to process a directory as a file (possibly a .md file causing issues).

**Fix**: Remove non-source files from `sources/[source_name]/` directory:

```bash
# Remove .md files from source directories
find frontend/sources/*/  -maxdepth 1 -name "*.md" -delete
```

Keep documentation at `frontend/sources/README.md` only.

## Validation Checklist

Run through this checklist to verify source configuration:

- [ ] `connection.yaml` exists in source directory
- [ ] `type: javascript` is set correctly
- [ ] All `.js` files end with `export { data };`
- [ ] `data` is an array of objects
- [ ] All objects contain only primitive types (string, number, boolean, Date)
- [ ] No nested objects or arrays in data
- [ ] No `.md` or documentation files in source subdirectories
- [ ] File paths in `readFileSync()` are correct
- [ ] Running `npm run sources` shows row counts
- [ ] Parquet files exist in `static/data/[source_name]/`
- [ ] Data appears correctly in browser at http://localhost:3000/

## Debugging Tips

### Add logging to source files

Temporarily add console.log statements:

```javascript
console.log("Loading data from:", jsonPath);
console.log("Parsed JSON keys:", Object.keys(jsonData));
console.log("Data length:", data.length);
console.log("Sample record:", data[0]);
console.log(
  "Data types:",
  Object.keys(data[0]).map((k) => `${k}: ${typeof data[0][k]}`),
);

export { data };
```

Run `npm run sources` and review output.

### Test individual source files

Run a source file directly with Node.js:

```bash
node frontend/sources/rugby_stats/all_points.js
```

This will show JavaScript errors before Evidence processes the file.

### Check Evidence version

```bash
cd frontend
npm list @evidence-dev/evidence
```

Some bugs are fixed in newer versions. Consider updating if using old version.

## See Also

- `evidence-dev:setup-javascript-source` - Set up new sources correctly
- `evidence-dev:flatten-json-data` - Fix nested data structures
- `frontend/CLAUDE.md` - Evidence.dev architecture guide
- `frontend/sources/README.md` - Data source documentation
- https://evidence.dev/docs/troubleshooting - Official troubleshooting docs

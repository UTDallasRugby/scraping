import { readFileSync } from 'fs';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

// Load the rugby stats JSON file from the frontend directory
const jsonPath = join(__dirname, '../../rugby_stats.json');
const rawData = readFileSync(jsonPath, 'utf-8');
const rugbyData = JSON.parse(rawData);

// Export the data - wrap in array with single row containing the full object
// so DuckDB can query it as: SELECT * FROM rugby_stats.rugby_data
const data = [{ seasons: rugbyData }];

export { data };

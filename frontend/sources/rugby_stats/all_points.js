import { readFileSync } from 'fs';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';

// Get the directory of the current module
const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

// Read the rugby stats JSON file
const jsonPath = join(__dirname, '../../../rugby_stats.json');
const rawData = readFileSync(jsonPath, 'utf8');
const jsonData = JSON.parse(rawData);

// Define all seasons
const seasons = [
  '2021-2022',
  '2019-2020',
  '2018-2019',
  '2017-2018',
  '2016-2017',
  '2015-2016',
  '2014-2015'
];

// Flatten points data
const data = [];

for (const season of seasons) {
  const seasonData = jsonData[season];
  if (!seasonData || !seasonData.points) {
    continue;
  }

  for (const entry of seasonData.points) {
    const points = parseInt(entry.pts, 10);
    if (points && points > 0) {
      data.push({
        season: season,
        player_name: entry.person?.display_name || 'Unknown',
        points: points
      });
    }
  }
}

export { data };

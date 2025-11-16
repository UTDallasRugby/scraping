import { readFileSync } from 'fs';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const jsonPath = join(__dirname, '../../../rugby_stats.json');
const rawData = readFileSync(jsonPath, 'utf8');
const jsonData = JSON.parse(rawData);

const seasons = [
  '2021-2022', '2019-2020', '2018-2019',
  '2017-2018', '2016-2017', '2015-2016', '2014-2015'
];

const data = [];

for (const season of seasons) {
  const seasonData = jsonData[season];
  if (!seasonData || !seasonData['penalty kicks']) continue;

  for (const entry of seasonData['penalty kicks']) {
    const penalty_kicks = parseInt(entry.pk, 10);
    if (penalty_kicks && penalty_kicks > 0) {
      data.push({
        season: season,
        player_name: entry.person?.display_name || 'Unknown',
        penalty_kicks: penalty_kicks
      });
    }
  }
}

export { data };

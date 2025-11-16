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
  if (!seasonData || !seasonData.conversions) continue;

  for (const entry of seasonData.conversions) {
    const conversions = parseInt(entry.cv, 10);
    if (conversions && conversions > 0) {
      data.push({
        season: season,
        player_name: entry.person?.display_name || 'Unknown',
        conversions: conversions
      });
    }
  }
}

export { data };

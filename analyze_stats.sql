-- Read the JSON files
CREATE TABLE raw_club_stats AS 
SELECT * FROM read_json_auto('/Users/emiller/src/personal/rugby-scraping/all_club_stats.json');

CREATE TABLE raw_rugby_stats AS 
SELECT * FROM read_json_auto('/Users/emiller/src/personal/rugby-scraping/rugby_stats.json');

-- Create a view for player stats by season from the raw stats
CREATE VIEW player_stats_by_season AS
WITH seasons AS (
  SELECT DISTINCT key as season
  FROM raw_rugby_stats,
  json_object_keys(json::json) as key
  WHERE key != 'struct'
),
stats_categories AS (
  SELECT unnest(ARRAY['points', 'tries', 'conversions', 'penalty kicks', 'drop goals', 'started', 'games played', 'yellow cards', 'red cards']) as category
),
flattened_stats AS (
  SELECT 
    s.season,
    sc.category,
    json_extract_path(json::json, s.season, sc.category) as stats_array
  FROM raw_rugby_stats, seasons s, stats_categories sc
  WHERE json_extract_path(json::json, s.season, sc.category) IS NOT NULL
)
SELECT
  season,
  category,
  json_extract_path(stat::json, 'person', 'display_name') as player_name,
  json_extract_path(stat::json, 'person', 'id') as player_id,
  CASE 
    WHEN category = 'points' THEN json_extract_path(stat::json, 'pts')::INTEGER
    WHEN category = 'tries' THEN json_extract_path(stat::json, 'tr')::INTEGER
    WHEN category = 'conversions' THEN json_extract_path(stat::json, 'cv')::INTEGER
    WHEN category = 'penalty kicks' THEN json_extract_path(stat::json, 'pk')::INTEGER
    WHEN category = 'drop goals' THEN json_extract_path(stat::json, 'dg')::INTEGER
    WHEN category = 'started' THEN json_extract_path(stat::json, 'started')::INTEGER
    WHEN category = 'games played' THEN json_extract_path(stat::json, 'played')::INTEGER
    WHEN category = 'yellow cards' THEN json_extract_path(stat::json, 'yc')::INTEGER
    WHEN category = 'red cards' THEN json_extract_path(stat::json, 'rc')::INTEGER
  END as value
FROM flattened_stats,
json_array_elements(stats_array::json) as stat
WHERE stat IS NOT NULL;

-- Create some useful views

-- Top scorers by season
CREATE VIEW top_scorers_by_season AS
SELECT 
  season,
  player_name,
  value as points
FROM player_stats_by_season
WHERE category = 'points'
ORDER BY season DESC, points DESC;

-- Player participation
CREATE VIEW player_participation AS
SELECT 
  season,
  player_name,
  value as games_played
FROM player_stats_by_season
WHERE category = 'games played'
ORDER BY season DESC, games_played DESC;

-- Disciplinary record
CREATE VIEW disciplinary_record AS
SELECT 
  season,
  player_name,
  SUM(CASE WHEN category = 'yellow cards' THEN value ELSE 0 END) as yellow_cards,
  SUM(CASE WHEN category = 'red cards' THEN value ELSE 0 END) as red_cards
FROM player_stats_by_season
WHERE category IN ('yellow cards', 'red cards')
GROUP BY season, player_name
HAVING yellow_cards > 0 OR red_cards > 0
ORDER BY season DESC, yellow_cards DESC, red_cards DESC;

-- Example queries to run:

-- View top scorers for each season
SELECT * FROM top_scorers_by_season;

-- View player participation across seasons
SELECT * FROM player_participation;

-- View disciplinary records
SELECT * FROM disciplinary_record;

-- View total stats by player across all seasons
SELECT 
  player_name,
  SUM(CASE WHEN category = 'points' THEN value ELSE 0 END) as total_points,
  SUM(CASE WHEN category = 'tries' THEN value ELSE 0 END) as total_tries,
  SUM(CASE WHEN category = 'conversions' THEN value ELSE 0 END) as total_conversions,
  SUM(CASE WHEN category = 'penalty kicks' THEN value ELSE 0 END) as total_penalty_kicks,
  SUM(CASE WHEN category = 'games played' THEN value ELSE 0 END) as total_games
FROM player_stats_by_season
GROUP BY player_name
HAVING total_points > 0
ORDER BY total_points DESC;

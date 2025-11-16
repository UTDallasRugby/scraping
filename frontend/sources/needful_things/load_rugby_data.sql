-- Load UTD Rugby stats from JSON into DuckDB
-- This script creates tables for all 9 stat categories using UNION ALL approach

-- Points Leaders (all seasons)
CREATE OR REPLACE TABLE points_leaders AS
WITH base_stats AS (
  SELECT * FROM read_json_auto('/Users/emiller/src/personal/rugby-scraping/rugby_stats.json')
)
SELECT
  '2021-2022' as season,
  p.value->'person'->>'display_name' as player_name,
  p.value->'person'->>'id' as player_id,
  CAST(p.value->>'pts' AS INTEGER) as points
FROM base_stats,
     UNNEST(base_stats."2021-2022".points) AS p(value)

UNION ALL

SELECT
  '2019-2020' as season,
  p.value->'person'->>'display_name' as player_name,
  p.value->'person'->>'id' as player_id,
  CAST(p.value->>'pts' AS INTEGER) as points
FROM base_stats,
     UNNEST(base_stats."2019-2020".points) AS p(value)

UNION ALL

SELECT
  '2018-2019' as season,
  p.value->'person'->>'display_name' as player_name,
  p.value->'person'->>'id' as player_id,
  CAST(p.value->>'pts' AS INTEGER) as points
FROM base_stats,
     UNNEST(base_stats."2018-2019".points) AS p(value)

UNION ALL

SELECT
  '2017-2018' as season,
  p.value->'person'->>'display_name' as player_name,
  p.value->'person'->>'id' as player_id,
  CAST(p.value->>'pts' AS INTEGER) as points
FROM base_stats,
     UNNEST(base_stats."2017-2018".points) AS p(value)

UNION ALL

SELECT
  '2016-2017' as season,
  p.value->'person'->>'display_name' as player_name,
  p.value->'person'->>'id' as player_id,
  CAST(p.value->>'pts' AS INTEGER) as points
FROM base_stats,
     UNNEST(base_stats."2016-2017".points) AS p(value)

UNION ALL

SELECT
  '2015-2016' as season,
  p.value->'person'->>'display_name' as player_name,
  p.value->'person'->>'id' as player_id,
  CAST(p.value->>'pts' AS INTEGER) as points
FROM base_stats,
     UNNEST(base_stats."2015-2016".points) AS p(value)

UNION ALL

SELECT
  '2014-2015' as season,
  p.value->'person'->>'display_name' as player_name,
  p.value->'person'->>'id' as player_id,
  CAST(p.value->>'pts' AS INTEGER) as points
FROM base_stats,
     UNNEST(base_stats."2014-2015".points) AS p(value);

-- Tries Leaders (all seasons)
CREATE OR REPLACE TABLE tries_leaders AS
WITH base_stats AS (
  SELECT * FROM read_json_auto('/Users/emiller/src/personal/rugby-scraping/rugby_stats.json')
)
SELECT
  '2021-2022' as season,
  t.value->'person'->>'display_name' as player_name,
  t.value->'person'->>'id' as player_id,
  CAST(t.value->>'tr' AS INTEGER) as tries
FROM base_stats,
     UNNEST(base_stats."2021-2022".tries) AS t(value)

UNION ALL

SELECT
  '2019-2020' as season,
  t.value->'person'->>'display_name' as player_name,
  t.value->'person'->>'id' as player_id,
  CAST(t.value->>'tr' AS INTEGER) as tries
FROM base_stats,
     UNNEST(base_stats."2019-2020".tries) AS t(value)

UNION ALL

SELECT
  '2018-2019' as season,
  t.value->'person'->>'display_name' as player_name,
  t.value->'person'->>'id' as player_id,
  CAST(t.value->>'tr' AS INTEGER) as tries
FROM base_stats,
     UNNEST(base_stats."2018-2019".tries) AS t(value)

UNION ALL

SELECT
  '2017-2018' as season,
  t.value->'person'->>'display_name' as player_name,
  t.value->'person'->>'id' as player_id,
  CAST(t.value->>'tr' AS INTEGER) as tries
FROM base_stats,
     UNNEST(base_stats."2017-2018".tries) AS t(value)

UNION ALL

SELECT
  '2016-2017' as season,
  t.value->'person'->>'display_name' as player_name,
  t.value->'person'->>'id' as player_id,
  CAST(t.value->>'tr' AS INTEGER) as tries
FROM base_stats,
     UNNEST(base_stats."2016-2017".tries) AS t(value)

UNION ALL

SELECT
  '2015-2016' as season,
  t.value->'person'->>'display_name' as player_name,
  t.value->'person'->>'id' as player_id,
  CAST(t.value->>'tr' AS INTEGER) as tries
FROM base_stats,
     UNNEST(base_stats."2015-2016".tries) AS t(value)

UNION ALL

SELECT
  '2014-2015' as season,
  t.value->'person'->>'display_name' as player_name,
  t.value->'person'->>'id' as player_id,
  CAST(t.value->>'tr' AS INTEGER) as tries
FROM base_stats,
     UNNEST(base_stats."2014-2015".tries) AS t(value);

-- Conversions Leaders
CREATE OR REPLACE TABLE conversions_leaders AS
WITH base_stats AS (
  SELECT * FROM read_json_auto('/Users/emiller/src/personal/rugby-scraping/rugby_stats.json')
)
SELECT
  '2021-2022' as season,
  c.value->'person'->>'display_name' as player_name,
  c.value->'person'->>'id' as player_id,
  CAST(c.value->>'cv' AS INTEGER) as conversions
FROM base_stats,
     UNNEST(base_stats."2021-2022".conversions) AS c(value)

UNION ALL

SELECT
  '2019-2020' as season,
  c.value->'person'->>'display_name' as player_name,
  c.value->'person'->>'id' as player_id,
  CAST(c.value->>'cv' AS INTEGER) as conversions
FROM base_stats,
     UNNEST(base_stats."2019-2020".conversions) AS c(value)

UNION ALL

SELECT
  '2018-2019' as season,
  c.value->'person'->>'display_name' as player_name,
  c.value->'person'->>'id' as player_id,
  CAST(c.value->>'cv' AS INTEGER) as conversions
FROM base_stats,
     UNNEST(base_stats."2018-2019".conversions) AS c(value)

UNION ALL

SELECT
  '2017-2018' as season,
  c.value->'person'->>'display_name' as player_name,
  c.value->'person'->>'id' as player_id,
  CAST(c.value->>'cv' AS INTEGER) as conversions
FROM base_stats,
     UNNEST(base_stats."2017-2018".conversions) AS c(value)

UNION ALL

SELECT
  '2016-2017' as season,
  c.value->'person'->>'display_name' as player_name,
  c.value->'person'->>'id' as player_id,
  CAST(c.value->>'cv' AS INTEGER) as conversions
FROM base_stats,
     UNNEST(base_stats."2016-2017".conversions) AS c(value)

UNION ALL

SELECT
  '2015-2016' as season,
  c.value->'person'->>'display_name' as player_name,
  c.value->'person'->>'id' as player_id,
  CAST(c.value->>'cv' AS INTEGER) as conversions
FROM base_stats,
     UNNEST(base_stats."2015-2016".conversions) AS c(value)

UNION ALL

SELECT
  '2014-2015' as season,
  c.value->'person'->>'display_name' as player_name,
  c.value->'person'->>'id' as player_id,
  CAST(c.value->>'cv' AS INTEGER) as conversions
FROM base_stats,
     UNNEST(base_stats."2014-2015".conversions) AS c(value);

-- Penalty Kicks Leaders
CREATE OR REPLACE TABLE penalty_kicks_leaders AS
WITH base_stats AS (
  SELECT * FROM read_json_auto('/Users/emiller/src/personal/rugby-scraping/rugby_stats.json')
)
SELECT
  '2021-2022' as season,
  pk.value->'person'->>'display_name' as player_name,
  pk.value->'person'->>'id' as player_id,
  CAST(pk.value->>'pk' AS INTEGER) as penalty_kicks
FROM base_stats,
     UNNEST(base_stats."2021-2022"."penalty kicks") AS pk(value)

UNION ALL

SELECT
  '2019-2020' as season,
  pk.value->'person'->>'display_name' as player_name,
  pk.value->'person'->>'id' as player_id,
  CAST(pk.value->>'pk' AS INTEGER) as penalty_kicks
FROM base_stats,
     UNNEST(base_stats."2019-2020"."penalty kicks") AS pk(value)

UNION ALL

SELECT
  '2018-2019' as season,
  pk.value->'person'->>'display_name' as player_name,
  pk.value->'person'->>'id' as player_id,
  CAST(pk.value->>'pk' AS INTEGER) as penalty_kicks
FROM base_stats,
     UNNEST(base_stats."2018-2019"."penalty kicks") AS pk(value)

UNION ALL

SELECT
  '2017-2018' as season,
  pk.value->'person'->>'display_name' as player_name,
  pk.value->'person'->>'id' as player_id,
  CAST(pk.value->>'pk' AS INTEGER) as penalty_kicks
FROM base_stats,
     UNNEST(base_stats."2017-2018"."penalty kicks") AS pk(value)

UNION ALL

SELECT
  '2016-2017' as season,
  pk.value->'person'->>'display_name' as player_name,
  pk.value->'person'->>'id' as player_id,
  CAST(pk.value->>'pk' AS INTEGER) as penalty_kicks
FROM base_stats,
     UNNEST(base_stats."2016-2017"."penalty kicks") AS pk(value)

UNION ALL

SELECT
  '2015-2016' as season,
  pk.value->'person'->>'display_name' as player_name,
  pk.value->'person'->>'id' as player_id,
  CAST(pk.value->>'pk' AS INTEGER) as penalty_kicks
FROM base_stats,
     UNNEST(base_stats."2015-2016"."penalty kicks") AS pk(value)

UNION ALL

SELECT
  '2014-2015' as season,
  pk.value->'person'->>'display_name' as player_name,
  pk.value->'person'->>'id' as player_id,
  CAST(pk.value->>'pk' AS INTEGER) as penalty_kicks
FROM base_stats,
     UNNEST(base_stats."2014-2015"."penalty kicks") AS pk(value);

-- Drop Goals Leaders
CREATE OR REPLACE TABLE drop_goals_leaders AS
WITH base_stats AS (
  SELECT * FROM read_json_auto('/Users/emiller/src/personal/rugby-scraping/rugby_stats.json')
)
SELECT
  '2021-2022' as season,
  dg.value->'person'->>'display_name' as player_name,
  dg.value->'person'->>'id' as player_id,
  CAST(dg.value->>'dg' AS INTEGER) as drop_goals
FROM base_stats,
     UNNEST(base_stats."2021-2022"."drop goals") AS dg(value)

UNION ALL

SELECT
  '2019-2020' as season,
  dg.value->'person'->>'display_name' as player_name,
  dg.value->'person'->>'id' as player_id,
  CAST(dg.value->>'dg' AS INTEGER) as drop_goals
FROM base_stats,
     UNNEST(base_stats."2019-2020"."drop goals") AS dg(value)

UNION ALL

SELECT
  '2018-2019' as season,
  dg.value->'person'->>'display_name' as player_name,
  dg.value->'person'->>'id' as player_id,
  CAST(dg.value->>'dg' AS INTEGER) as drop_goals
FROM base_stats,
     UNNEST(base_stats."2018-2019"."drop goals") AS dg(value)

UNION ALL

SELECT
  '2017-2018' as season,
  dg.value->'person'->>'display_name' as player_name,
  dg.value->'person'->>'id' as player_id,
  CAST(dg.value->>'dg' AS INTEGER) as drop_goals
FROM base_stats,
     UNNEST(base_stats."2017-2018"."drop goals") AS dg(value)

UNION ALL

SELECT
  '2016-2017' as season,
  dg.value->'person'->>'display_name' as player_name,
  dg.value->'person'->>'id' as player_id,
  CAST(dg.value->>'dg' AS INTEGER) as drop_goals
FROM base_stats,
     UNNEST(base_stats."2016-2017"."drop goals") AS dg(value)

UNION ALL

SELECT
  '2015-2016' as season,
  dg.value->'person'->>'display_name' as player_name,
  dg.value->'person'->>'id' as player_id,
  CAST(dg.value->>'dg' AS INTEGER) as drop_goals
FROM base_stats,
     UNNEST(base_stats."2015-2016"."drop goals") AS dg(value)

UNION ALL

SELECT
  '2014-2015' as season,
  dg.value->'person'->>'display_name' as player_name,
  dg.value->'person'->>'id' as player_id,
  CAST(dg.value->>'dg' AS INTEGER) as drop_goals
FROM base_stats,
     UNNEST(base_stats."2014-2015"."drop goals") AS dg(value);

-- Games Played
CREATE OR REPLACE TABLE games_played AS
WITH base_stats AS (
  SELECT * FROM read_json_auto('/Users/emiller/src/personal/rugby-scraping/rugby_stats.json')
)
SELECT
  '2021-2022' as season,
  gp.value->'person'->>'display_name' as player_name,
  gp.value->'person'->>'id' as player_id,
  CAST(gp.value->>'played' AS INTEGER) as games
FROM base_stats,
     UNNEST(base_stats."2021-2022"."games played") AS gp(value)

UNION ALL

SELECT
  '2019-2020' as season,
  gp.value->'person'->>'display_name' as player_name,
  gp.value->'person'->>'id' as player_id,
  CAST(gp.value->>'played' AS INTEGER) as games
FROM base_stats,
     UNNEST(base_stats."2019-2020"."games played") AS gp(value)

UNION ALL

SELECT
  '2018-2019' as season,
  gp.value->'person'->>'display_name' as player_name,
  gp.value->'person'->>'id' as player_id,
  CAST(gp.value->>'played' AS INTEGER) as games
FROM base_stats,
     UNNEST(base_stats."2018-2019"."games played") AS gp(value)

UNION ALL

SELECT
  '2017-2018' as season,
  gp.value->'person'->>'display_name' as player_name,
  gp.value->'person'->>'id' as player_id,
  CAST(gp.value->>'played' AS INTEGER) as games
FROM base_stats,
     UNNEST(base_stats."2017-2018"."games played") AS gp(value)

UNION ALL

SELECT
  '2016-2017' as season,
  gp.value->'person'->>'display_name' as player_name,
  gp.value->'person'->>'id' as player_id,
  CAST(gp.value->>'played' AS INTEGER) as games
FROM base_stats,
     UNNEST(base_stats."2016-2017"."games played") AS gp(value)

UNION ALL

SELECT
  '2015-2016' as season,
  gp.value->'person'->>'display_name' as player_name,
  gp.value->'person'->>'id' as player_id,
  CAST(gp.value->>'played' AS INTEGER) as games
FROM base_stats,
     UNNEST(base_stats."2015-2016"."games played") AS gp(value)

UNION ALL

SELECT
  '2014-2015' as season,
  gp.value->'person'->>'display_name' as player_name,
  gp.value->'person'->>'id' as player_id,
  CAST(gp.value->>'played' AS INTEGER) as games
FROM base_stats,
     UNNEST(base_stats."2014-2015"."games played") AS gp(value);

-- Yellow Cards
CREATE OR REPLACE TABLE yellow_cards AS
WITH base_stats AS (
  SELECT * FROM read_json_auto('/Users/emiller/src/personal/rugby-scraping/rugby_stats.json')
)
SELECT
  '2021-2022' as season,
  yc.value->'person'->>'display_name' as player_name,
  yc.value->'person'->>'id' as player_id,
  CAST(yc.value->>'yc' AS INTEGER) as yellow_cards
FROM base_stats,
     UNNEST(base_stats."2021-2022"."yellow cards") AS yc(value)

UNION ALL

SELECT
  '2019-2020' as season,
  yc.value->'person'->>'display_name' as player_name,
  yc.value->'person'->>'id' as player_id,
  CAST(yc.value->>'yc' AS INTEGER) as yellow_cards
FROM base_stats,
     UNNEST(base_stats."2019-2020"."yellow cards") AS yc(value)

UNION ALL

SELECT
  '2018-2019' as season,
  yc.value->'person'->>'display_name' as player_name,
  yc.value->'person'->>'id' as player_id,
  CAST(yc.value->>'yc' AS INTEGER) as yellow_cards
FROM base_stats,
     UNNEST(base_stats."2018-2019"."yellow cards") AS yc(value)

UNION ALL

SELECT
  '2017-2018' as season,
  yc.value->'person'->>'display_name' as player_name,
  yc.value->'person'->>'id' as player_id,
  CAST(yc.value->>'yc' AS INTEGER) as yellow_cards
FROM base_stats,
     UNNEST(base_stats."2017-2018"."yellow cards") AS yc(value)

UNION ALL

SELECT
  '2016-2017' as season,
  yc.value->'person'->>'display_name' as player_name,
  yc.value->'person'->>'id' as player_id,
  CAST(yc.value->>'yc' AS INTEGER) as yellow_cards
FROM base_stats,
     UNNEST(base_stats."2016-2017"."yellow cards") AS yc(value)

UNION ALL

SELECT
  '2015-2016' as season,
  yc.value->'person'->>'display_name' as player_name,
  yc.value->'person'->>'id' as player_id,
  CAST(yc.value->>'yc' AS INTEGER) as yellow_cards
FROM base_stats,
     UNNEST(base_stats."2015-2016"."yellow cards") AS yc(value)

UNION ALL

SELECT
  '2014-2015' as season,
  yc.value->'person'->>'display_name' as player_name,
  yc.value->'person'->>'id' as player_id,
  CAST(yc.value->>'yc' AS INTEGER) as yellow_cards
FROM base_stats,
     UNNEST(base_stats."2014-2015"."yellow cards") AS yc(value);

-- Red Cards
CREATE OR REPLACE TABLE red_cards AS
WITH base_stats AS (
  SELECT * FROM read_json_auto('/Users/emiller/src/personal/rugby-scraping/rugby_stats.json')
)
SELECT
  '2021-2022' as season,
  rc.value->'person'->>'display_name' as player_name,
  rc.value->'person'->>'id' as player_id,
  CAST(rc.value->>'rc' AS INTEGER) as red_cards
FROM base_stats,
     UNNEST(base_stats."2021-2022"."red cards") AS rc(value)

UNION ALL

SELECT
  '2019-2020' as season,
  rc.value->'person'->>'display_name' as player_name,
  rc.value->'person'->>'id' as player_id,
  CAST(rc.value->>'rc' AS INTEGER) as red_cards
FROM base_stats,
     UNNEST(base_stats."2019-2020"."red cards") AS rc(value)

UNION ALL

SELECT
  '2018-2019' as season,
  rc.value->'person'->>'display_name' as player_name,
  rc.value->'person'->>'id' as player_id,
  CAST(rc.value->>'rc' AS INTEGER) as red_cards
FROM base_stats,
     UNNEST(base_stats."2018-2019"."red cards") AS rc(value)

UNION ALL

SELECT
  '2017-2018' as season,
  rc.value->'person'->>'display_name' as player_name,
  rc.value->'person'->>'id' as player_id,
  CAST(rc.value->>'rc' AS INTEGER) as red_cards
FROM base_stats,
     UNNEST(base_stats."2017-2018"."red cards") AS rc(value)

UNION ALL

SELECT
  '2016-2017' as season,
  rc.value->'person'->>'display_name' as player_name,
  rc.value->'person'->>'id' as player_id,
  CAST(rc.value->>'rc' AS INTEGER) as red_cards
FROM base_stats,
     UNNEST(base_stats."2016-2017"."red cards") AS rc(value)

UNION ALL

SELECT
  '2015-2016' as season,
  rc.value->'person'->>'display_name' as player_name,
  rc.value->'person'->>'id' as player_id,
  CAST(rc.value->>'rc' AS INTEGER) as red_cards
FROM base_stats,
     UNNEST(base_stats."2015-2016"."red cards") AS rc(value)

UNION ALL

SELECT
  '2014-2015' as season,
  rc.value->'person'->>'display_name' as player_name,
  rc.value->'person'->>'id' as player_id,
  CAST(rc.value->>'rc' AS INTEGER) as red_cards
FROM base_stats,
     UNNEST(base_stats."2014-2015"."red cards") AS rc(value);

-- All-time aggregations
CREATE OR REPLACE VIEW points_all_time AS
SELECT player_name, SUM(points) as total_points, COUNT(DISTINCT season) as seasons_played
FROM points_leaders
GROUP BY player_name
ORDER BY total_points DESC;

CREATE OR REPLACE VIEW tries_all_time AS
SELECT player_name, SUM(tries) as total_tries, COUNT(DISTINCT season) as seasons_played
FROM tries_leaders
GROUP BY player_name
ORDER BY total_tries DESC;

CREATE OR REPLACE VIEW conversions_all_time AS
SELECT player_name, SUM(conversions) as total_conversions, COUNT(DISTINCT season) as seasons_played
FROM conversions_leaders
GROUP BY player_name
ORDER BY total_conversions DESC;

CREATE OR REPLACE VIEW penalty_kicks_all_time AS
SELECT player_name, SUM(penalty_kicks) as total_penalty_kicks, COUNT(DISTINCT season) as seasons_played
FROM penalty_kicks_leaders
GROUP BY player_name
ORDER BY total_penalty_kicks DESC;

CREATE OR REPLACE VIEW games_played_all_time AS
SELECT player_name, SUM(games) as total_games, COUNT(DISTINCT season) as seasons_played
FROM games_played
GROUP BY player_name
ORDER BY total_games DESC;

CREATE OR REPLACE VIEW yellow_cards_all_time AS
SELECT player_name, SUM(yellow_cards) as total_yellow_cards, COUNT(DISTINCT season) as seasons_played
FROM yellow_cards
GROUP BY player_name
ORDER BY total_yellow_cards DESC;

CREATE OR REPLACE VIEW red_cards_all_time AS
SELECT player_name, SUM(red_cards) as total_red_cards, COUNT(DISTINCT season) as seasons_played
FROM red_cards
GROUP BY player_name
ORDER BY total_red_cards DESC;

-- Kicking Stats (conversions + penalty kicks combined)
CREATE OR REPLACE VIEW kicking_stats AS
SELECT
  COALESCE(c.player_name, pk.player_name) as player_name,
  COALESCE(c.total_conversions, 0) as total_conversions,
  COALESCE(pk.total_penalty_kicks, 0) as total_penalty_kicks,
  0 as total_drop_goals,
  COALESCE(c.total_conversions, 0) + COALESCE(pk.total_penalty_kicks, 0) as total_kicks,
  (COALESCE(c.total_conversions, 0) * 2) + (COALESCE(pk.total_penalty_kicks, 0) * 3) as kicking_points
FROM conversions_all_time c
FULL OUTER JOIN penalty_kicks_all_time pk ON c.player_name = pk.player_name
WHERE COALESCE(c.total_conversions, 0) + COALESCE(pk.total_penalty_kicks, 0) > 0
ORDER BY kicking_points DESC;

-- Disciplinary Record (combined yellow and red cards)
CREATE OR REPLACE VIEW disciplinary_record AS
SELECT
  COALESCE(yc.season, rc.season) as season,
  COALESCE(yc.player_name, rc.player_name) as player_name,
  COALESCE(yc.yellow_cards, 0) as yellow_cards,
  COALESCE(rc.red_cards, 0) as red_cards,
  COALESCE(yc.yellow_cards, 0) + (COALESCE(rc.red_cards, 0) * 2) as total_card_points
FROM yellow_cards yc
FULL OUTER JOIN red_cards rc ON yc.season = rc.season AND yc.player_name = rc.player_name
WHERE COALESCE(yc.yellow_cards, 0) + COALESCE(rc.red_cards, 0) > 0
ORDER BY total_card_points DESC, season DESC;

-- Player Stats by Season (unified view)
CREATE OR REPLACE VIEW player_stats_by_season AS
SELECT season, 'points' as category, player_name, player_id, points as value FROM points_leaders
UNION ALL
SELECT season, 'tries' as category, player_name, player_id, tries as value FROM tries_leaders
UNION ALL
SELECT season, 'conversions' as category, player_name, player_id, conversions as value FROM conversions_leaders
UNION ALL
SELECT season, 'penalty kicks' as category, player_name, player_id, penalty_kicks as value FROM penalty_kicks_leaders
UNION ALL
SELECT season, 'drop goals' as category, player_name, player_id, drop_goals as value FROM drop_goals_leaders
UNION ALL
SELECT season, 'games played' as category, player_name, player_id, games as value FROM games_played
UNION ALL
SELECT season, 'yellow cards' as category, player_name, player_id, yellow_cards as value FROM yellow_cards
UNION ALL
SELECT season, 'red cards' as category, player_name, player_id, red_cards as value FROM red_cards;

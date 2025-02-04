.mode box
.headers on

-- Load the JSON files
CREATE TABLE rugby_stats AS SELECT * FROM read_json_auto('rugby_stats.json');

-- First, let's see what seasons we have data for
SELECT column_name 
FROM (SELECT * FROM rugby_stats LIMIT 1) t1
UNPIVOT (val FOR column_name IN (*))
WHERE column_name != 'struct'
ORDER BY column_name DESC;

-- Points leaders by season (only for seasons with data)
WITH season_points AS (
    SELECT '2021-2022' as season, unnest("2021-2022".points) as point_record FROM rugby_stats WHERE "2021-2022".points IS NOT NULL
    UNION ALL
    SELECT '2019-2020', unnest("2019-2020".points) FROM rugby_stats WHERE "2019-2020".points IS NOT NULL
    UNION ALL
    SELECT '2018-2019', unnest("2018-2019".points) FROM rugby_stats WHERE "2018-2019".points IS NOT NULL
)
SELECT 
    season,
    point_record.pts::INTEGER as points,
    point_record.person.display_name as player,
    point_record.person.id as player_id
FROM season_points
ORDER BY season DESC, points DESC;

-- Tries leaders by season
WITH season_tries AS (
    SELECT '2021-2022' as season, unnest("2021-2022".tries) as try_record FROM rugby_stats WHERE "2021-2022".tries IS NOT NULL
    UNION ALL
    SELECT '2019-2020', unnest("2019-2020".tries) FROM rugby_stats WHERE "2019-2020".tries IS NOT NULL
    UNION ALL
    SELECT '2018-2019', unnest("2018-2019".tries) FROM rugby_stats WHERE "2018-2019".tries IS NOT NULL
)
SELECT 
    season,
    try_record.tr::INTEGER as tries,
    try_record.person.display_name as player,
    try_record.person.id as player_id
FROM season_tries
ORDER BY season DESC, tries DESC;

-- Games played by season
WITH season_games AS (
    SELECT '2021-2022' as season, unnest("2021-2022"."games played") as game_record FROM rugby_stats WHERE "2021-2022"."games played" IS NOT NULL
    UNION ALL
    SELECT '2019-2020', unnest("2019-2020"."games played") FROM rugby_stats WHERE "2019-2020"."games played" IS NOT NULL
    UNION ALL
    SELECT '2018-2019', unnest("2018-2019"."games played") FROM rugby_stats WHERE "2018-2019"."games played" IS NOT NULL
)
SELECT 
    season,
    game_record.played::INTEGER as games,
    game_record.person.display_name as player,
    game_record.person.id as player_id
FROM season_games
ORDER BY season DESC, games DESC;

-- Disciplinary record (yellow and red cards) by season
WITH season_yellow_cards AS (
    SELECT '2021-2022' as season, unnest("2021-2022"."yellow cards") as yc_record FROM rugby_stats WHERE "2021-2022"."yellow cards" IS NOT NULL
    UNION ALL
    SELECT '2019-2020', unnest("2019-2020"."yellow cards") FROM rugby_stats WHERE "2019-2020"."yellow cards" IS NOT NULL
    UNION ALL
    SELECT '2018-2019', unnest("2018-2019"."yellow cards") FROM rugby_stats WHERE "2018-2019"."yellow cards" IS NOT NULL
),
season_red_cards AS (
    SELECT '2021-2022' as season, unnest("2021-2022"."red cards") as rc_record FROM rugby_stats WHERE "2021-2022"."red cards" IS NOT NULL
    UNION ALL
    SELECT '2019-2020', unnest("2019-2020"."red cards") FROM rugby_stats WHERE "2019-2020"."red cards" IS NOT NULL
    UNION ALL
    SELECT '2018-2019', unnest("2018-2019"."red cards") FROM rugby_stats WHERE "2018-2019"."red cards" IS NOT NULL
)
SELECT 
    COALESCE(yc.season, rc.season) as season,
    COALESCE(yc.player, rc.player) as player,
    COALESCE(yc.yellow_cards, 0) as yellow_cards,
    COALESCE(rc.red_cards, 0) as red_cards
FROM (
    SELECT 
        season,
        yc_record.person.display_name as player,
        yc_record.yc::INTEGER as yellow_cards
    FROM season_yellow_cards
) yc
FULL OUTER JOIN (
    SELECT 
        season,
        rc_record.person.display_name as player,
        rc_record.rc::INTEGER as red_cards
    FROM season_red_cards
) rc ON yc.season = rc.season AND yc.player = rc.player
WHERE COALESCE(yellow_cards, 0) > 0 OR COALESCE(red_cards, 0) > 0
ORDER BY season DESC, yellow_cards DESC, red_cards DESC;

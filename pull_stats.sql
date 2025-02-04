.mode box
.headers on

-- Load the JSON files
CREATE TABLE rugby_stats AS SELECT * FROM read_json_auto('rugby_stats.json');

-- Create a flattened view of points for a single season to test
WITH season_points AS (
    SELECT 
        unnest("2021-2022".points) as point_record
    FROM rugby_stats
)
SELECT 
    '2021-2022' as season,
    point_record.pts::INTEGER as points,
    point_record.person.display_name as player,
    point_record.person.id as player_id
FROM season_points
ORDER BY points DESC;

-- Now let's look at tries for that season
WITH season_tries AS (
    SELECT 
        unnest("2021-2022".tries) as try_record
    FROM rugby_stats
)
SELECT 
    '2021-2022' as season,
    try_record.tr::INTEGER as tries,
    try_record.person.display_name as player,
    try_record.person.id as player_id
FROM season_tries
ORDER BY tries DESC;

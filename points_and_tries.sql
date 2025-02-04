.mode box
.headers on

-- All-time points leaders
WITH base_stats AS (
  SELECT * FROM read_json_auto('all_club_stats.json')
),
all_points AS (
    SELECT p.value->'person'->>'display_name' as player,
           CAST(p.value->>'pts' AS INTEGER) as points
    FROM base_stats,
         UNNEST(base_stats."696".stats."2021-2022".points) AS p(value)
    WHERE CAST(p.value->>'pts' AS INTEGER) > 0

    UNION ALL

    SELECT p.value->'person'->>'display_name' as player,
           CAST(p.value->>'pts' AS INTEGER) as points
    FROM base_stats,
         UNNEST(base_stats."696".stats."2019-2020".points) AS p(value)
    WHERE CAST(p.value->>'pts' AS INTEGER) > 0

    UNION ALL

    SELECT p.value->'person'->>'display_name' as player,
           CAST(p.value->>'pts' AS INTEGER) as points
    FROM base_stats,
         UNNEST(base_stats."696".stats."2018-2019".points) AS p(value)
    WHERE CAST(p.value->>'pts' AS INTEGER) > 0

    UNION ALL

    SELECT p.value->'person'->>'display_name' as player,
           CAST(p.value->>'pts' AS INTEGER) as points
    FROM base_stats,
         UNNEST(base_stats."696".stats."2017-2018".points) AS p(value)
    WHERE CAST(p.value->>'pts' AS INTEGER) > 0

    UNION ALL

    SELECT p.value->'person'->>'display_name' as player,
           CAST(p.value->>'pts' AS INTEGER) as points
    FROM base_stats,
         UNNEST(base_stats."696".stats."2016-2017".points) AS p(value)
    WHERE CAST(p.value->>'pts' AS INTEGER) > 0

    UNION ALL

    SELECT p.value->'person'->>'display_name' as player,
           CAST(p.value->>'pts' AS INTEGER) as points
    FROM base_stats,
         UNNEST(base_stats."696".stats."2015-2016".points) AS p(value)
    WHERE CAST(p.value->>'pts' AS INTEGER) > 0

    UNION ALL

    SELECT p.value->'person'->>'display_name' as player,
           CAST(p.value->>'pts' AS INTEGER) as points
    FROM base_stats,
         UNNEST(base_stats."696".stats."2014-2015".points) AS p(value)
    WHERE CAST(p.value->>'pts' AS INTEGER) > 0
)
SELECT 
    player,
    SUM(points) as total_points,
    COUNT(*) as seasons_played
FROM all_points
GROUP BY player
ORDER BY total_points DESC
LIMIT 10;

-- Add a visual separator
SELECT '----------------------------------------' as "Season Separator";

-- Points leaders by season
WITH base_stats AS (
  SELECT * FROM read_json_auto('all_club_stats.json')
)
SELECT 
    '2021-2022' as season,
    RANK() OVER (ORDER BY CAST(p.value->>'pts' AS INTEGER) DESC) as rank,
    CAST(p.value->>'pts' AS INTEGER) as points,
    p.value->'person'->>'display_name' as player
FROM base_stats,
     UNNEST(base_stats."696".stats."2021-2022".points) AS p(value)
WHERE CAST(p.value->>'pts' AS INTEGER) > 0
QUALIFY rank <= 5

UNION ALL

SELECT 
    '2019-2020' as season,
    RANK() OVER (ORDER BY CAST(p.value->>'pts' AS INTEGER) DESC) as rank,
    CAST(p.value->>'pts' AS INTEGER) as points,
    p.value->'person'->>'display_name' as player
FROM base_stats,
     UNNEST(base_stats."696".stats."2019-2020".points) AS p(value)
WHERE CAST(p.value->>'pts' AS INTEGER) > 0
QUALIFY rank <= 5

UNION ALL

SELECT 
    '2018-2019' as season,
    RANK() OVER (ORDER BY CAST(p.value->>'pts' AS INTEGER) DESC) as rank,
    CAST(p.value->>'pts' AS INTEGER) as points,
    p.value->'person'->>'display_name' as player
FROM base_stats,
     UNNEST(base_stats."696".stats."2018-2019".points) AS p(value)
WHERE CAST(p.value->>'pts' AS INTEGER) > 0
QUALIFY rank <= 5

UNION ALL

SELECT 
    '2017-2018' as season,
    RANK() OVER (ORDER BY CAST(p.value->>'pts' AS INTEGER) DESC) as rank,
    CAST(p.value->>'pts' AS INTEGER) as points,
    p.value->'person'->>'display_name' as player
FROM base_stats,
     UNNEST(base_stats."696".stats."2017-2018".points) AS p(value)
WHERE CAST(p.value->>'pts' AS INTEGER) > 0
QUALIFY rank <= 5

UNION ALL

SELECT 
    '2016-2017' as season,
    RANK() OVER (ORDER BY CAST(p.value->>'pts' AS INTEGER) DESC) as rank,
    CAST(p.value->>'pts' AS INTEGER) as points,
    p.value->'person'->>'display_name' as player
FROM base_stats,
     UNNEST(base_stats."696".stats."2016-2017".points) AS p(value)
WHERE CAST(p.value->>'pts' AS INTEGER) > 0
QUALIFY rank <= 5

UNION ALL

SELECT 
    '2015-2016' as season,
    RANK() OVER (ORDER BY CAST(p.value->>'pts' AS INTEGER) DESC) as rank,
    CAST(p.value->>'pts' AS INTEGER) as points,
    p.value->'person'->>'display_name' as player
FROM base_stats,
     UNNEST(base_stats."696".stats."2015-2016".points) AS p(value)
WHERE CAST(p.value->>'pts' AS INTEGER) > 0
QUALIFY rank <= 5

UNION ALL

SELECT 
    '2014-2015' as season,
    RANK() OVER (ORDER BY CAST(p.value->>'pts' AS INTEGER) DESC) as rank,
    CAST(p.value->>'pts' AS INTEGER) as points,
    p.value->'person'->>'display_name' as player
FROM base_stats,
     UNNEST(base_stats."696".stats."2014-2015".points) AS p(value)
WHERE CAST(p.value->>'pts' AS INTEGER) > 0
QUALIFY rank <= 5

ORDER BY season DESC, points DESC;

-- Add a visual separator
SELECT '----------------------------------------' as "Season Separator";

-- Try scorers by season
WITH base_stats AS (
  SELECT * FROM read_json_auto('all_club_stats.json')
)
SELECT 
    '2021-2022' as season,
    RANK() OVER (ORDER BY CAST(t.value->>'tr' AS INTEGER) DESC) as rank,
    CAST(t.value->>'tr' AS INTEGER) as tries,
    t.value->'person'->>'display_name' as player
FROM base_stats,
     UNNEST(base_stats."696".stats."2021-2022".tries) AS t(value)
WHERE CAST(t.value->>'tr' AS INTEGER) > 0
QUALIFY rank <= 5

UNION ALL

SELECT 
    '2019-2020' as season,
    RANK() OVER (ORDER BY CAST(t.value->>'tr' AS INTEGER) DESC) as rank,
    CAST(t.value->>'tr' AS INTEGER) as tries,
    t.value->'person'->>'display_name' as player
FROM base_stats,
     UNNEST(base_stats."696".stats."2019-2020".tries) AS t(value)
WHERE CAST(t.value->>'tr' AS INTEGER) > 0
QUALIFY rank <= 5

UNION ALL

SELECT 
    '2018-2019' as season,
    RANK() OVER (ORDER BY CAST(t.value->>'tr' AS INTEGER) DESC) as rank,
    CAST(t.value->>'tr' AS INTEGER) as tries,
    t.value->'person'->>'display_name' as player
FROM base_stats,
     UNNEST(base_stats."696".stats."2018-2019".tries) AS t(value)
WHERE CAST(t.value->>'tr' AS INTEGER) > 0
QUALIFY rank <= 5

UNION ALL

SELECT 
    '2017-2018' as season,
    RANK() OVER (ORDER BY CAST(t.value->>'tr' AS INTEGER) DESC) as rank,
    CAST(t.value->>'tr' AS INTEGER) as tries,
    t.value->'person'->>'display_name' as player
FROM base_stats,
     UNNEST(base_stats."696".stats."2017-2018".tries) AS t(value)
WHERE CAST(t.value->>'tr' AS INTEGER) > 0
QUALIFY rank <= 5

UNION ALL

SELECT 
    '2016-2017' as season,
    RANK() OVER (ORDER BY CAST(t.value->>'tr' AS INTEGER) DESC) as rank,
    CAST(t.value->>'tr' AS INTEGER) as tries,
    t.value->'person'->>'display_name' as player
FROM base_stats,
     UNNEST(base_stats."696".stats."2016-2017".tries) AS t(value)
WHERE CAST(t.value->>'tr' AS INTEGER) > 0
QUALIFY rank <= 5

UNION ALL

SELECT 
    '2015-2016' as season,
    RANK() OVER (ORDER BY CAST(t.value->>'tr' AS INTEGER) DESC) as rank,
    CAST(t.value->>'tr' AS INTEGER) as tries,
    t.value->'person'->>'display_name' as player
FROM base_stats,
     UNNEST(base_stats."696".stats."2015-2016".tries) AS t(value)
WHERE CAST(t.value->>'tr' AS INTEGER) > 0
QUALIFY rank <= 5

UNION ALL

SELECT 
    '2014-2015' as season,
    RANK() OVER (ORDER BY CAST(t.value->>'tr' AS INTEGER) DESC) as rank,
    CAST(t.value->>'tr' AS INTEGER) as tries,
    t.value->'person'->>'display_name' as player
FROM base_stats,
     UNNEST(base_stats."696".stats."2014-2015".tries) AS t(value)
WHERE CAST(t.value->>'tr' AS INTEGER) > 0
QUALIFY rank <= 5

ORDER BY season DESC, tries DESC;

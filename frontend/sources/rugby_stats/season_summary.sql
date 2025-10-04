-- Season summary with top scorers
WITH season_points AS (
    SELECT '2021-2022' as season, unnest("2021-2022".points) as point_record
    FROM read_json_auto('../../../rugby_stats.json')
    WHERE "2021-2022".points IS NOT NULL
    UNION ALL
    SELECT '2019-2020', unnest("2019-2020".points)
    FROM read_json_auto('../../../rugby_stats.json')
    WHERE "2019-2020".points IS NOT NULL
    UNION ALL
    SELECT '2018-2019', unnest("2018-2019".points)
    FROM read_json_auto('../../../rugby_stats.json')
    WHERE "2018-2019".points IS NOT NULL
    UNION ALL
    SELECT '2017-2018', unnest("2017-2018".points)
    FROM read_json_auto('../../../rugby_stats.json')
    WHERE "2017-2018".points IS NOT NULL
    UNION ALL
    SELECT '2016-2017', unnest("2016-2017".points)
    FROM read_json_auto('../../../rugby_stats.json')
    WHERE "2016-2017".points IS NOT NULL
    UNION ALL
    SELECT '2015-2016', unnest("2015-2016".points)
    FROM read_json_auto('../../../rugby_stats.json')
    WHERE "2015-2016".points IS NOT NULL
    UNION ALL
    SELECT '2014-2015', unnest("2014-2015".points)
    FROM read_json_auto('../../../rugby_stats.json')
    WHERE "2014-2015".points IS NOT NULL
),
ranked_points AS (
    SELECT
        season,
        point_record.pts::INTEGER as points,
        point_record.person.display_name as player,
        ROW_NUMBER() OVER (PARTITION BY season ORDER BY point_record.pts::INTEGER DESC) as rank
    FROM season_points
)
SELECT
    season,
    SUM(points) as total_points,
    MAX(CASE WHEN rank = 1 THEN player END) as top_scorer,
    MAX(CASE WHEN rank = 1 THEN points END) as top_points
FROM ranked_points
GROUP BY season
ORDER BY season DESC

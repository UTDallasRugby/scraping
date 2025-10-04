-- Points leaders across all seasons
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
)
SELECT
    season,
    point_record.pts::INTEGER as points,
    point_record.person.display_name as player,
    point_record.person.id as player_id
FROM season_points
ORDER BY season DESC, points DESC

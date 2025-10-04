-- Tries leaders across all seasons
WITH season_tries AS (
    SELECT '2021-2022' as season, unnest("2021-2022".tries) as try_record
    FROM read_json_auto('../../../rugby_stats.json')
    WHERE "2021-2022".tries IS NOT NULL
    UNION ALL
    SELECT '2019-2020', unnest("2019-2020".tries)
    FROM read_json_auto('../../../rugby_stats.json')
    WHERE "2019-2020".tries IS NOT NULL
    UNION ALL
    SELECT '2018-2019', unnest("2018-2019".tries)
    FROM read_json_auto('../../../rugby_stats.json')
    WHERE "2018-2019".tries IS NOT NULL
    UNION ALL
    SELECT '2017-2018', unnest("2017-2018".tries)
    FROM read_json_auto('../../../rugby_stats.json')
    WHERE "2017-2018".tries IS NOT NULL
    UNION ALL
    SELECT '2016-2017', unnest("2016-2017".tries)
    FROM read_json_auto('../../../rugby_stats.json')
    WHERE "2016-2017".tries IS NOT NULL
    UNION ALL
    SELECT '2015-2016', unnest("2015-2016".tries)
    FROM read_json_auto('../../../rugby_stats.json')
    WHERE "2015-2016".tries IS NOT NULL
    UNION ALL
    SELECT '2014-2015', unnest("2014-2015".tries)
    FROM read_json_auto('../../../rugby_stats.json')
    WHERE "2014-2015".tries IS NOT NULL
)
SELECT
    season,
    try_record.tr::INTEGER as tries,
    try_record.person.display_name as player,
    try_record.person.id as player_id
FROM season_tries
ORDER BY season DESC, tries DESC

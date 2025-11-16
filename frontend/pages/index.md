---
title: UTD Rugby Stats Archive
---

# UTD Rugby Statistics Archive

Welcome to the UTD Rugby historical statistics archive. This site preserves team and player statistics from the USA Rugby Stats system (2014-2022).

## 📊 View Statistics

<BigLink href="/rugby-stats">
    <h2>Team Statistics Dashboard</h2>
    <p>Browse points leaders, try scorers, kicking stats, and games played</p>
</BigLink>

<BigLink href="/disciplinary">
    <h2>Disciplinary Records</h2>
    <p>View yellow and red card statistics across all seasons</p>
</BigLink>

## About This Archive

After USA Rugby's bankruptcy in 2020, their stats system was moved to Rugby Xplorer. This archive preserves UTD Rugby's historical data from **usarugbystats.com** across **7 seasons** (2014-2022).

### Data Coverage

This archive contains **9 comprehensive stat categories** from all available seasons:

- **Points** - Season and career scoring leaders
- **Tries** - Top try scorers by season
- **Conversions** - Conversion kicking statistics
- **Penalty Kicks** - Successful penalty attempts
- **Drop Goals** - Drop goal statistics
- **Games Played** - Player match appearances
- **Games Started** - Starting lineup appearances
- **Yellow Cards** - Disciplinary warnings
- **Red Cards** - Ejections and serious infractions

### Quick Stats

```sql total_stats
WITH base_stats AS (
  SELECT * FROM rugby_stats.rugby_data
),
all_players AS (
  SELECT DISTINCT
    p.value->'person'->>'display_name' as player_name,
    '2021-2022' as season
  FROM base_stats, UNNEST(base_stats.seasons."2021-2022".points) AS p(value)
  UNION
  SELECT DISTINCT
    p.value->'person'->>'display_name' as player_name,
    '2019-2020' as season
  FROM base_stats, UNNEST(base_stats.seasons."2019-2020".points) AS p(value)
  UNION
  SELECT DISTINCT
    p.value->'person'->>'display_name' as player_name,
    '2018-2019' as season
  FROM base_stats, UNNEST(base_stats.seasons."2018-2019".points) AS p(value)
  UNION
  SELECT DISTINCT
    p.value->'person'->>'display_name' as player_name,
    '2017-2018' as season
  FROM base_stats, UNNEST(base_stats.seasons."2017-2018".points) AS p(value)
  UNION
  SELECT DISTINCT
    p.value->'person'->>'display_name' as player_name,
    '2016-2017' as season
  FROM base_stats, UNNEST(base_stats.seasons."2016-2017".points) AS p(value)
  UNION
  SELECT DISTINCT
    p.value->'person'->>'display_name' as player_name,
    '2015-2016' as season
  FROM base_stats, UNNEST(base_stats.seasons."2015-2016".points) AS p(value)
  UNION
  SELECT DISTINCT
    p.value->'person'->>'display_name' as player_name,
    '2014-2015' as season
  FROM base_stats, UNNEST(base_stats.seasons."2014-2015".points) AS p(value)
),
points_data AS (
  SELECT CAST(p.value->>'pts' AS INTEGER) as points
  FROM base_stats, UNNEST(base_stats.seasons."2021-2022".points) AS p(value)
  UNION ALL
  SELECT CAST(p.value->>'pts' AS INTEGER)
  FROM base_stats, UNNEST(base_stats.seasons."2019-2020".points) AS p(value)
  UNION ALL
  SELECT CAST(p.value->>'pts' AS INTEGER)
  FROM base_stats, UNNEST(base_stats.seasons."2018-2019".points) AS p(value)
  UNION ALL
  SELECT CAST(p.value->>'pts' AS INTEGER)
  FROM base_stats, UNNEST(base_stats.seasons."2017-2018".points) AS p(value)
  UNION ALL
  SELECT CAST(p.value->>'pts' AS INTEGER)
  FROM base_stats, UNNEST(base_stats.seasons."2016-2017".points) AS p(value)
  UNION ALL
  SELECT CAST(p.value->>'pts' AS INTEGER)
  FROM base_stats, UNNEST(base_stats.seasons."2015-2016".points) AS p(value)
  UNION ALL
  SELECT CAST(p.value->>'pts' AS INTEGER)
  FROM base_stats, UNNEST(base_stats.seasons."2014-2015".points) AS p(value)
),
tries_data AS (
  SELECT CAST(t.value->>'tr' AS INTEGER) as tries
  FROM base_stats, UNNEST(base_stats.seasons."2021-2022".tries) AS t(value)
  UNION ALL
  SELECT CAST(t.value->>'tr' AS INTEGER)
  FROM base_stats, UNNEST(base_stats.seasons."2019-2020".tries) AS t(value)
  UNION ALL
  SELECT CAST(t.value->>'tr' AS INTEGER)
  FROM base_stats, UNNEST(base_stats.seasons."2018-2019".tries) AS t(value)
  UNION ALL
  SELECT CAST(t.value->>'tr' AS INTEGER)
  FROM base_stats, UNNEST(base_stats.seasons."2017-2018".tries) AS t(value)
  UNION ALL
  SELECT CAST(t.value->>'tr' AS INTEGER)
  FROM base_stats, UNNEST(base_stats.seasons."2016-2017".tries) AS t(value)
  UNION ALL
  SELECT CAST(t.value->>'tr' AS INTEGER)
  FROM base_stats, UNNEST(base_stats.seasons."2015-2016".tries) AS t(value)
  UNION ALL
  SELECT CAST(t.value->>'tr' AS INTEGER)
  FROM base_stats, UNNEST(base_stats.seasons."2014-2015".tries) AS t(value)
)
SELECT
    COUNT(DISTINCT player_name) as total_players,
    COUNT(DISTINCT season) as total_seasons,
    (SELECT SUM(points) FROM points_data) as total_points,
    (SELECT SUM(tries) FROM tries_data) as total_tries
FROM all_players
```

<BigValue
    data={total_stats}
    value=total_players
    title="Total Players"
/>

<BigValue
    data={total_stats}
    value=total_seasons
    title="Seasons Tracked"
/>

<BigValue
    data={total_stats}
    value=total_points
    title="Total Points Scored"
/>

<BigValue
    data={total_stats}
    value=total_tries
    title="Total Tries"
/>

---

_Data sourced from USA Rugby Stats API before its deprecation_

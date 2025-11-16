---
title: UTD Rugby Statistics
---

# UTD Rugby Team Statistics

Historical stats from the USA Rugby Stats system (2014-2022)

```sql points_leaders
WITH base_stats AS (
  SELECT * FROM read_json_auto('../../rugby_stats.json')
)
SELECT
  '2021-2022' as season,
  p.value->'person'->>'display_name' as player_name,
  CAST(p.value->>'pts' AS INTEGER) as points
FROM base_stats, UNNEST(base_stats."2021-2022".points) AS p(value)
UNION ALL
SELECT
  '2019-2020' as season,
  p.value->'person'->>'display_name' as player_name,
  CAST(p.value->>'pts' AS INTEGER) as points
FROM base_stats, UNNEST(base_stats."2019-2020".points) AS p(value)
UNION ALL
SELECT
  '2018-2019' as season,
  p.value->'person'->>'display_name' as player_name,
  CAST(p.value->>'pts' AS INTEGER) as points
FROM base_stats, UNNEST(base_stats."2018-2019".points) AS p(value)
UNION ALL
SELECT
  '2017-2018' as season,
  p.value->'person'->>'display_name' as player_name,
  CAST(p.value->>'pts' AS INTEGER) as points
FROM base_stats, UNNEST(base_stats."2017-2018".points) AS p(value)
UNION ALL
SELECT
  '2016-2017' as season,
  p.value->'person'->>'display_name' as player_name,
  CAST(p.value->>'pts' AS INTEGER) as points
FROM base_stats, UNNEST(base_stats."2016-2017".points) AS p(value)
UNION ALL
SELECT
  '2015-2016' as season,
  p.value->'person'->>'display_name' as player_name,
  CAST(p.value->>'pts' AS INTEGER) as points
FROM base_stats, UNNEST(base_stats."2015-2016".points) AS p(value)
UNION ALL
SELECT
  '2014-2015' as season,
  p.value->'person'->>'display_name' as player_name,
  CAST(p.value->>'pts' AS INTEGER) as points
FROM base_stats, UNNEST(base_stats."2014-2015".points) AS p(value)
WHERE points >= 5
```

```sql tries_leaders
WITH base_stats AS (
  SELECT * FROM read_json_auto('../../rugby_stats.json')
)
SELECT
  '2021-2022' as season,
  t.value->'person'->>'display_name' as player_name,
  CAST(t.value->>'tr' AS INTEGER) as tries
FROM base_stats, UNNEST(base_stats."2021-2022".tries) AS t(value)
UNION ALL
SELECT
  '2019-2020' as season,
  t.value->'person'->>'display_name' as player_name,
  CAST(t.value->>'tr' AS INTEGER) as tries
FROM base_stats, UNNEST(base_stats."2019-2020".tries) AS t(value)
UNION ALL
SELECT
  '2018-2019' as season,
  t.value->'person'->>'display_name' as player_name,
  CAST(t.value->>'tr' AS INTEGER) as tries
FROM base_stats, UNNEST(base_stats."2018-2019".tries) AS t(value)
UNION ALL
SELECT
  '2017-2018' as season,
  t.value->'person'->>'display_name' as player_name,
  CAST(t.value->>'tr' AS INTEGER) as tries
FROM base_stats, UNNEST(base_stats."2017-2018".tries) AS t(value)
UNION ALL
SELECT
  '2016-2017' as season,
  t.value->'person'->>'display_name' as player_name,
  CAST(t.value->>'tr' AS INTEGER) as tries
FROM base_stats, UNNEST(base_stats."2016-2017".tries) AS t(value)
UNION ALL
SELECT
  '2015-2016' as season,
  t.value->'person'->>'display_name' as player_name,
  CAST(t.value->>'tr' AS INTEGER) as tries
FROM base_stats, UNNEST(base_stats."2015-2016".tries) AS t(value)
UNION ALL
SELECT
  '2014-2015' as season,
  t.value->'person'->>'display_name' as player_name,
  CAST(t.value->>'tr' AS INTEGER) as tries
FROM base_stats, UNNEST(base_stats."2014-2015".tries) AS t(value)
WHERE tries >= 2
```

```sql conversions_leaders
WITH base_stats AS (
  SELECT * FROM read_json_auto('../../rugby_stats.json')
)
SELECT
  '2021-2022' as season,
  c.value->'person'->>'display_name' as player_name,
  CAST(c.value->>'cv' AS INTEGER) as conversions
FROM base_stats, UNNEST(base_stats."2021-2022".conversions) AS c(value)
UNION ALL
SELECT
  '2019-2020' as season,
  c.value->'person'->>'display_name' as player_name,
  CAST(c.value->>'cv' AS INTEGER) as conversions
FROM base_stats, UNNEST(base_stats."2019-2020".conversions) AS c(value)
UNION ALL
SELECT
  '2018-2019' as season,
  c.value->'person'->>'display_name' as player_name,
  CAST(c.value->>'cv' AS INTEGER) as conversions
FROM base_stats, UNNEST(base_stats."2018-2019".conversions) AS c(value)
UNION ALL
SELECT
  '2017-2018' as season,
  c.value->'person'->>'display_name' as player_name,
  CAST(c.value->>'cv' AS INTEGER) as conversions
FROM base_stats, UNNEST(base_stats."2017-2018".conversions) AS c(value)
UNION ALL
SELECT
  '2016-2017' as season,
  c.value->'person'->>'display_name' as player_name,
  CAST(c.value->>'cv' AS INTEGER) as conversions
FROM base_stats, UNNEST(base_stats."2016-2017".conversions) AS c(value)
UNION ALL
SELECT
  '2015-2016' as season,
  c.value->'person'->>'display_name' as player_name,
  CAST(c.value->>'cv' AS INTEGER) as conversions
FROM base_stats, UNNEST(base_stats."2015-2016".conversions) AS c(value)
UNION ALL
SELECT
  '2014-2015' as season,
  c.value->'person'->>'display_name' as player_name,
  CAST(c.value->>'cv' AS INTEGER) as conversions
FROM base_stats, UNNEST(base_stats."2014-2015".conversions) AS c(value)
WHERE conversions >= 1
```

```sql penalty_kicks_leaders
WITH base_stats AS (
  SELECT * FROM read_json_auto('../../rugby_stats.json')
)
SELECT
  '2021-2022' as season,
  pk.value->'person'->>'display_name' as player_name,
  CAST(pk.value->>'pk' AS INTEGER) as penalty_kicks
FROM base_stats, UNNEST(base_stats."2021-2022"."penalty kicks") AS pk(value)
UNION ALL
SELECT
  '2019-2020' as season,
  pk.value->'person'->>'display_name' as player_name,
  CAST(pk.value->>'pk' AS INTEGER) as penalty_kicks
FROM base_stats, UNNEST(base_stats."2019-2020"."penalty kicks") AS pk(value)
UNION ALL
SELECT
  '2018-2019' as season,
  pk.value->'person'->>'display_name' as player_name,
  CAST(pk.value->>'pk' AS INTEGER) as penalty_kicks
FROM base_stats, UNNEST(base_stats."2018-2019"."penalty kicks") AS pk(value)
UNION ALL
SELECT
  '2017-2018' as season,
  pk.value->'person'->>'display_name' as player_name,
  CAST(pk.value->>'pk' AS INTEGER) as penalty_kicks
FROM base_stats, UNNEST(base_stats."2017-2018"."penalty kicks") AS pk(value)
UNION ALL
SELECT
  '2016-2017' as season,
  pk.value->'person'->>'display_name' as player_name,
  CAST(pk.value->>'pk' AS INTEGER) as penalty_kicks
FROM base_stats, UNNEST(base_stats."2016-2017"."penalty kicks") AS pk(value)
UNION ALL
SELECT
  '2015-2016' as season,
  pk.value->'person'->>'display_name' as player_name,
  CAST(pk.value->>'pk' AS INTEGER) as penalty_kicks
FROM base_stats, UNNEST(base_stats."2015-2016"."penalty kicks") AS pk(value)
UNION ALL
SELECT
  '2014-2015' as season,
  pk.value->'person'->>'display_name' as player_name,
  CAST(pk.value->>'pk' AS INTEGER) as penalty_kicks
FROM base_stats, UNNEST(base_stats."2014-2015"."penalty kicks") AS pk(value)
WHERE penalty_kicks >= 1
```

```sql games_played_data
WITH base_stats AS (
  SELECT * FROM read_json_auto('../../rugby_stats.json')
)
SELECT
  '2021-2022' as season,
  gp.value->'person'->>'display_name' as player_name,
  CAST(gp.value->>'played' AS INTEGER) as games
FROM base_stats, UNNEST(base_stats."2021-2022"."games played") AS gp(value)
UNION ALL
SELECT
  '2019-2020' as season,
  gp.value->'person'->>'display_name' as player_name,
  CAST(gp.value->>'played' AS INTEGER) as games
FROM base_stats, UNNEST(base_stats."2019-2020"."games played") AS gp(value)
UNION ALL
SELECT
  '2018-2019' as season,
  gp.value->'person'->>'display_name' as player_name,
  CAST(gp.value->>'played' AS INTEGER) as games
FROM base_stats, UNNEST(base_stats."2018-2019"."games played") AS gp(value)
UNION ALL
SELECT
  '2017-2018' as season,
  gp.value->'person'->>'display_name' as player_name,
  CAST(gp.value->>'played' AS INTEGER) as games
FROM base_stats, UNNEST(base_stats."2017-2018"."games played") AS gp(value)
UNION ALL
SELECT
  '2016-2017' as season,
  gp.value->'person'->>'display_name' as player_name,
  CAST(gp.value->>'played' AS INTEGER) as games
FROM base_stats, UNNEST(base_stats."2016-2017"."games played") AS gp(value)
UNION ALL
SELECT
  '2015-2016' as season,
  gp.value->'person'->>'display_name' as player_name,
  CAST(gp.value->>'played' AS INTEGER) as games
FROM base_stats, UNNEST(base_stats."2015-2016"."games played") AS gp(value)
UNION ALL
SELECT
  '2014-2015' as season,
  gp.value->'person'->>'display_name' as player_name,
  CAST(gp.value->>'played' AS INTEGER) as games
FROM base_stats, UNNEST(base_stats."2014-2015"."games played") AS gp(value)
WHERE games >= 1
```

## Season Filter

<Dropdown name=season_filter>
    <DropdownOption value="%" valueLabel="All Seasons"/>
    <DropdownOption value="2021-2022"/>
    <DropdownOption value="2019-2020"/>
    <DropdownOption value="2018-2019"/>
    <DropdownOption value="2017-2018"/>
    <DropdownOption value="2016-2017"/>
    <DropdownOption value="2015-2016"/>
    <DropdownOption value="2014-2015"/>
</Dropdown>

## Points Leaders by Season

```sql filtered_points
SELECT *
FROM ${points_leaders}
WHERE season LIKE '${inputs.season_filter.value}'
ORDER BY points DESC
LIMIT 15
```

<DataTable data={filtered_points} rows=15>
    <Column id=season title="Season" />
    <Column id=player_name title="Player" />
    <Column id=points title="Points" />
</DataTable>

<BarChart
    data={filtered_points}
    title="Top Points Scorers - {inputs.season_filter.label}"
    x=player_name
    y=points
    swapXY=true
/>

## Tries Leaders by Season

```sql filtered_tries
SELECT *
FROM ${tries_leaders}
WHERE season LIKE '${inputs.season_filter.value}'
ORDER BY tries DESC
LIMIT 15
```

<DataTable data={filtered_tries} rows=15>
    <Column id=season title="Season" />
    <Column id=player_name title="Player" />
    <Column id=tries title="Tries" />
</DataTable>

<BarChart
    data={filtered_tries}
    title="Top Try Scorers - {inputs.season_filter.label}"
    x=player_name
    y=tries
    swapXY=true
/>

## Conversions Leaders by Season

```sql filtered_conversions
SELECT *
FROM ${conversions_leaders}
WHERE season LIKE '${inputs.season_filter.value}'
ORDER BY conversions DESC
LIMIT 15
```

<DataTable data={filtered_conversions} rows=15>
    <Column id=season title="Season" />
    <Column id=player_name title="Player" />
    <Column id=conversions title="Conversions" />
</DataTable>

<BarChart
    data={filtered_conversions}
    title="Top Conversion Kickers - {inputs.season_filter.label}"
    x=player_name
    y=conversions
    swapXY=true
/>

## Penalty Kicks Leaders by Season

```sql filtered_penalty_kicks
SELECT *
FROM ${penalty_kicks_leaders}
WHERE season LIKE '${inputs.season_filter.value}'
ORDER BY penalty_kicks DESC
LIMIT 15
```

<DataTable data={filtered_penalty_kicks} rows=15>
    <Column id=season title="Season" />
    <Column id=player_name title="Player" />
    <Column id=penalty_kicks title="Penalty Kicks" />
</DataTable>

<BarChart
    data={filtered_penalty_kicks}
    title="Top Penalty Kickers - {inputs.season_filter.label}"
    x=player_name
    y=penalty_kicks
    swapXY=true
/>

## Games Played by Season

```sql filtered_games
SELECT *
FROM ${games_played_data}
WHERE season LIKE '${inputs.season_filter.value}'
ORDER BY games DESC
LIMIT 15
```

<DataTable data={filtered_games} rows=15>
    <Column id=season title="Season" />
    <Column id=player_name title="Player" />
    <Column id=games title="Games Played" />
</DataTable>

<BarChart
    data={filtered_games}
    title="Most Games Played - {inputs.season_filter.label}"
    x=player_name
    y=games
    swapXY=true
/>

## All-Time Leaders

### Top 10 Points Scorers

```sql all_time_points
SELECT player_name, SUM(points) as total_points, COUNT(DISTINCT season) as seasons_played
FROM ${points_leaders}
GROUP BY player_name
ORDER BY total_points DESC
LIMIT 10
```

<DataTable data={all_time_points} rows=10>
    <Column id=player_name title="Player" />
    <Column id=total_points title="Total Points" />
    <Column id=seasons_played title="Seasons" />
</DataTable>

### Top 10 Try Scorers

```sql all_time_tries
SELECT player_name, SUM(tries) as total_tries, COUNT(DISTINCT season) as seasons_played
FROM ${tries_leaders}
GROUP BY player_name
ORDER BY total_tries DESC
LIMIT 10
```

<DataTable data={all_time_tries} rows=10>
    <Column id=player_name title="Player" />
    <Column id=total_tries title="Total Tries" />
    <Column id=seasons_played title="Seasons" />
</DataTable>

### Top Kickers (All-Time)

```sql all_time_kicking
WITH conversions_totals AS (
  SELECT player_name, SUM(conversions) as total_conversions, COUNT(DISTINCT season) as seasons_played
  FROM ${conversions_leaders}
  GROUP BY player_name
),
penalty_kicks_totals AS (
  SELECT player_name, SUM(penalty_kicks) as total_penalty_kicks
  FROM ${penalty_kicks_leaders}
  GROUP BY player_name
)
SELECT
  COALESCE(c.player_name, pk.player_name) as player_name,
  COALESCE(c.total_conversions, 0) as total_conversions,
  COALESCE(pk.total_penalty_kicks, 0) as total_penalty_kicks,
  0 as total_drop_goals,
  (COALESCE(c.total_conversions, 0) * 2) + (COALESCE(pk.total_penalty_kicks, 0) * 3) as kicking_points
FROM conversions_totals c
FULL OUTER JOIN penalty_kicks_totals pk ON c.player_name = pk.player_name
ORDER BY kicking_points DESC
LIMIT 10
```

<DataTable data={all_time_kicking} rows=10>
    <Column id=player_name title="Player" />
    <Column id=total_conversions title="Conversions" />
    <Column id=total_penalty_kicks title="Penalty Kicks" />
    <Column id=total_drop_goals title="Drop Goals" />
    <Column id=kicking_points title="Kicking Points" />
</DataTable>

### Most Games Played (All-Time)

```sql all_time_games
SELECT player_name, SUM(games) as total_games, COUNT(DISTINCT season) as seasons_played
FROM ${games_played_data}
GROUP BY player_name
ORDER BY total_games DESC
LIMIT 10
```

<DataTable data={all_time_games} rows=10>
    <Column id=player_name title="Player" />
    <Column id=total_games title="Total Games" />
    <Column id=seasons_played title="Seasons" />
</DataTable>

---

_Data sourced from USA Rugby Stats system (usarugbystats.com)_

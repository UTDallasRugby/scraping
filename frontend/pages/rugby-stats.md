---
title: UTD Rugby Statistics
---

# UTD Rugby Team Statistics

Historical stats from the USA Rugby Stats system (2014-2022)

## Season Overview

```sql season_summary
SELECT * FROM rugby_stats.season_summary
```

<DataTable data={season_summary} rows=10>
    <Column id=season />
    <Column id=total_points title="Total Points" />
    <Column id=top_scorer title="Top Scorer" />
    <Column id=top_points title="Points" />
</DataTable>

## Points Leaders by Season

```sql points_leaders
SELECT * FROM rugby_stats.points_leaders
WHERE points >= 5
```

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

```sql filtered_points
SELECT
    season,
    player,
    points
FROM rugby_stats.points_leaders
WHERE season LIKE '${inputs.season_filter.value}'
    AND points >= 5
ORDER BY points DESC
LIMIT 15
```

<BarChart
    data={filtered_points}
    title="Top Points Scorers"
    x=player
    y=points
    swapXY=true
/>

## Tries Leaders by Season

```sql tries_leaders
SELECT * FROM rugby_stats.tries_leaders
WHERE tries >= 2
```

```sql filtered_tries
SELECT
    season,
    player,
    tries
FROM rugby_stats.tries_leaders
WHERE season LIKE '${inputs.season_filter.value}'
    AND tries >= 2
ORDER BY tries DESC
LIMIT 15
```

<BarChart
    data={filtered_tries}
    title="Top Try Scorers"
    x=player
    y=tries
    swapXY=true
/>

## All-Time Leaders

### Top 10 Points Scorers

```sql all_time_points
SELECT
    player,
    SUM(points) as total_points,
    COUNT(DISTINCT season) as seasons_played
FROM rugby_stats.points_leaders
GROUP BY player
ORDER BY total_points DESC
LIMIT 10
```

<DataTable data={all_time_points}>
    <Column id=player title="Player" />
    <Column id=total_points title="Total Points" />
    <Column id=seasons_played title="Seasons" />
</DataTable>

### Top 10 Try Scorers

```sql all_time_tries
SELECT
    player,
    SUM(tries) as total_tries,
    COUNT(DISTINCT season) as seasons_played
FROM rugby_stats.tries_leaders
GROUP BY player
ORDER BY total_tries DESC
LIMIT 10
```

<DataTable data={all_time_tries}>
    <Column id=player title="Player" />
    <Column id=total_tries title="Total Tries" />
    <Column id=seasons_played title="Seasons" />
</DataTable>

---

*Data sourced from USA Rugby Stats system (usarugbystats.com)*

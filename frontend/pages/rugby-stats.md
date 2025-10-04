---
title: UTD Rugby Statistics
---

# UTD Rugby Team Statistics

Historical stats from the USA Rugby Stats system (2014-2022)

```sql points_leaders
SELECT * FROM rugby_stats.points_leaders
WHERE points >= 5
```

```sql tries_leaders
SELECT * FROM rugby_stats.tries_leaders
WHERE tries >= 2
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
    <Column id=player title="Player" />
    <Column id=points title="Points" />
</DataTable>

<BarChart
    data={filtered_points}
    title="Top Points Scorers - {inputs.season_filter.label}"
    x=player
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
    <Column id=player title="Player" />
    <Column id=tries title="Tries" />
</DataTable>

<BarChart
    data={filtered_tries}
    title="Top Try Scorers - {inputs.season_filter.label}"
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
FROM ${points_leaders}
GROUP BY player
ORDER BY total_points DESC
LIMIT 10
```

<DataTable data={all_time_points} rows=10>
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
FROM ${tries_leaders}
GROUP BY player
ORDER BY total_tries DESC
LIMIT 10
```

<DataTable data={all_time_tries} rows=10>
    <Column id=player title="Player" />
    <Column id=total_tries title="Total Tries" />
    <Column id=seasons_played title="Seasons" />
</DataTable>

---

*Data sourced from USA Rugby Stats system (usarugbystats.com)*

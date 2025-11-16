---
title: Disciplinary Records
---

# Disciplinary Records

Yellow and red cards across all UTD Rugby seasons (2014-2022)

```sql yellow_cards_data
WITH base_stats AS (
  SELECT * FROM read_json_auto('../../rugby_stats.json')
)
SELECT
  '2021-2022' as season,
  yc.value->'person'->>'display_name' as player_name,
  CAST(yc.value->>'yc' AS INTEGER) as yellow_cards
FROM base_stats, UNNEST(base_stats."2021-2022"."yellow cards") AS yc(value)
UNION ALL
SELECT
  '2019-2020' as season,
  yc.value->'person'->>'display_name' as player_name,
  CAST(yc.value->>'yc' AS INTEGER) as yellow_cards
FROM base_stats, UNNEST(base_stats."2019-2020"."yellow cards") AS yc(value)
UNION ALL
SELECT
  '2018-2019' as season,
  yc.value->'person'->>'display_name' as player_name,
  CAST(yc.value->>'yc' AS INTEGER) as yellow_cards
FROM base_stats, UNNEST(base_stats."2018-2019"."yellow cards") AS yc(value)
UNION ALL
SELECT
  '2017-2018' as season,
  yc.value->'person'->>'display_name' as player_name,
  CAST(yc.value->>'yc' AS INTEGER) as yellow_cards
FROM base_stats, UNNEST(base_stats."2017-2018"."yellow cards") AS yc(value)
UNION ALL
SELECT
  '2016-2017' as season,
  yc.value->'person'->>'display_name' as player_name,
  CAST(yc.value->>'yc' AS INTEGER) as yellow_cards
FROM base_stats, UNNEST(base_stats."2016-2017"."yellow cards") AS yc(value)
UNION ALL
SELECT
  '2015-2016' as season,
  yc.value->'person'->>'display_name' as player_name,
  CAST(yc.value->>'yc' AS INTEGER) as yellow_cards
FROM base_stats, UNNEST(base_stats."2015-2016"."yellow cards") AS yc(value)
UNION ALL
SELECT
  '2014-2015' as season,
  yc.value->'person'->>'display_name' as player_name,
  CAST(yc.value->>'yc' AS INTEGER) as yellow_cards
FROM base_stats, UNNEST(base_stats."2014-2015"."yellow cards") AS yc(value)
WHERE yellow_cards >= 1
```

```sql red_cards_data
WITH base_stats AS (
  SELECT * FROM read_json_auto('../../rugby_stats.json')
)
SELECT
  '2021-2022' as season,
  rc.value->'person'->>'display_name' as player_name,
  CAST(rc.value->>'rc' AS INTEGER) as red_cards
FROM base_stats, UNNEST(base_stats."2021-2022"."red cards") AS rc(value)
UNION ALL
SELECT
  '2019-2020' as season,
  rc.value->'person'->>'display_name' as player_name,
  CAST(rc.value->>'rc' AS INTEGER) as red_cards
FROM base_stats, UNNEST(base_stats."2019-2020"."red cards") AS rc(value)
UNION ALL
SELECT
  '2018-2019' as season,
  rc.value->'person'->>'display_name' as player_name,
  CAST(rc.value->>'rc' AS INTEGER) as red_cards
FROM base_stats, UNNEST(base_stats."2018-2019"."red cards") AS rc(value)
UNION ALL
SELECT
  '2017-2018' as season,
  rc.value->'person'->>'display_name' as player_name,
  CAST(rc.value->>'rc' AS INTEGER) as red_cards
FROM base_stats, UNNEST(base_stats."2017-2018"."red cards") AS rc(value)
UNION ALL
SELECT
  '2016-2017' as season,
  rc.value->'person'->>'display_name' as player_name,
  CAST(rc.value->>'rc' AS INTEGER) as red_cards
FROM base_stats, UNNEST(base_stats."2016-2017"."red cards") AS rc(value)
UNION ALL
SELECT
  '2015-2016' as season,
  rc.value->'person'->>'display_name' as player_name,
  CAST(rc.value->>'rc' AS INTEGER) as red_cards
FROM base_stats, UNNEST(base_stats."2015-2016"."red cards") AS rc(value)
UNION ALL
SELECT
  '2014-2015' as season,
  rc.value->'person'->>'display_name' as player_name,
  CAST(rc.value->>'rc' AS INTEGER) as red_cards
FROM base_stats, UNNEST(base_stats."2014-2015"."red cards") AS rc(value)
WHERE red_cards >= 1
```

```sql disciplinary_combined
WITH yellow_cards AS (
  SELECT * FROM ${yellow_cards_data}
),
red_cards AS (
  SELECT * FROM ${red_cards_data}
)
SELECT
  COALESCE(yc.season, rc.season) as season,
  COALESCE(yc.player_name, rc.player_name) as player_name,
  COALESCE(yc.yellow_cards, 0) as yellow_cards,
  COALESCE(rc.red_cards, 0) as red_cards,
  COALESCE(yc.yellow_cards, 0) + (COALESCE(rc.red_cards, 0) * 2) as total_card_points
FROM yellow_cards yc
FULL OUTER JOIN red_cards rc ON yc.season = rc.season AND yc.player_name = rc.player_name
ORDER BY total_card_points DESC, season DESC
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

## Yellow Cards by Season

```sql filtered_yellow_cards
SELECT *
FROM ${yellow_cards_data}
WHERE season LIKE '${inputs.season_filter.value}'
ORDER BY yellow_cards DESC
LIMIT 15
```

<DataTable data={filtered_yellow_cards} rows=15>
    <Column id=season title="Season" />
    <Column id=player_name title="Player" />
    <Column id=yellow_cards title="Yellow Cards" />
</DataTable>

<BarChart
data={filtered_yellow_cards}
title="Yellow Cards - {inputs.season_filter.label}"
x=player_name
y=yellow_cards
swapXY=true
colorPalette={['#fbbf24']}
/>

## Red Cards by Season

```sql filtered_red_cards
SELECT *
FROM ${red_cards_data}
WHERE season LIKE '${inputs.season_filter.value}'
ORDER BY red_cards DESC
LIMIT 15
```

<DataTable data={filtered_red_cards} rows=15>
    <Column id=season title="Season" />
    <Column id=player_name title="Player" />
    <Column id=red_cards title="Red Cards" />
</DataTable>

<BarChart
data={filtered_red_cards}
title="Red Cards - {inputs.season_filter.label}"
x=player_name
y=red_cards
swapXY=true
colorPalette={['#dc2626']}
/>

## Combined Disciplinary Record

Card Points = Yellow Cards + (Red Cards × 2)

```sql filtered_disciplinary
SELECT *
FROM ${disciplinary_combined}
WHERE season LIKE '${inputs.season_filter.value}'
ORDER BY total_card_points DESC, yellow_cards DESC
LIMIT 15
```

<DataTable data={filtered_disciplinary} rows=15>
    <Column id=season title="Season" />
    <Column id=player_name title="Player" />
    <Column id=yellow_cards title="Yellow Cards" />
    <Column id=red_cards title="Red Cards" />
    <Column id=total_card_points title="Card Points" />
</DataTable>

<BarChart
data={filtered_disciplinary}
title="Disciplinary Record (Card Points) - {inputs.season_filter.label}"
x=player_name
y=total_card_points
swapXY=true
colorPalette={['#ef4444']}
/>

## All-Time Disciplinary Records

### Yellow Cards (All-Time)

```sql all_time_yellow
SELECT player_name, SUM(yellow_cards) as total_yellow_cards, COUNT(DISTINCT season) as seasons_played
FROM ${yellow_cards_data}
GROUP BY player_name
ORDER BY total_yellow_cards DESC
LIMIT 10
```

<DataTable data={all_time_yellow} rows=10>
    <Column id=player_name title="Player" />
    <Column id=total_yellow_cards title="Total Yellow Cards" />
    <Column id=seasons_played title="Seasons" />
</DataTable>

### Red Cards (All-Time)

```sql all_time_red
SELECT player_name, SUM(red_cards) as total_red_cards, COUNT(DISTINCT season) as seasons_played
FROM ${red_cards_data}
GROUP BY player_name
ORDER BY total_red_cards DESC
LIMIT 10
```

<DataTable data={all_time_red} rows=10>
    <Column id=player_name title="Player" />
    <Column id=total_red_cards title="Total Red Cards" />
    <Column id=seasons_played title="Seasons" />
</DataTable>

### Cleanest Players

Players with the most games played and zero disciplinary record

```sql cleanest_players
WITH base_stats AS (
  SELECT * FROM read_json_auto('../../rugby_stats.json')
),
games_played AS (
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
),
games_all_time AS (
  SELECT player_name, SUM(games) as total_games, COUNT(DISTINCT season) as seasons_played
  FROM games_played
  GROUP BY player_name
),
yellow_all_time AS (
  SELECT player_name
  FROM ${yellow_cards_data}
  GROUP BY player_name
),
red_all_time AS (
  SELECT player_name
  FROM ${red_cards_data}
  GROUP BY player_name
)
SELECT
    gp.player_name,
    gp.total_games,
    gp.seasons_played
FROM games_all_time gp
LEFT JOIN yellow_all_time yc ON gp.player_name = yc.player_name
LEFT JOIN red_all_time rc ON gp.player_name = rc.player_name
WHERE yc.player_name IS NULL AND rc.player_name IS NULL
ORDER BY gp.total_games DESC
LIMIT 10
```

<DataTable data={cleanest_players} rows=10>
    <Column id=player_name title="Player" />
    <Column id=total_games title="Games Played" />
    <Column id=seasons_played title="Seasons" />
</DataTable>

---

_Data sourced from USA Rugby Stats system (usarugbystats.com)_

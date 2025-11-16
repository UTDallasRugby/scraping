---
title: Disciplinary Records
---

# Disciplinary Records

Yellow and red cards across all UTD Rugby seasons (2014-2022)

```sql yellow_cards_data
SELECT * FROM needful_things.yellow_cards
WHERE yellow_cards >= 1
```

```sql red_cards_data
SELECT * FROM needful_things.red_cards
WHERE red_cards >= 1
```

```sql disciplinary_combined
SELECT * FROM needful_things.disciplinary_record
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
SELECT * FROM needful_things.yellow_cards_all_time
LIMIT 10
```

<DataTable data={all_time_yellow} rows=10>
    <Column id=player_name title="Player" />
    <Column id=total_yellow_cards title="Total Yellow Cards" />
    <Column id=seasons_played title="Seasons" />
</DataTable>

### Red Cards (All-Time)

```sql all_time_red
SELECT * FROM needful_things.red_cards_all_time
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
SELECT
    gp.player_name,
    gp.total_games,
    gp.seasons_played
FROM needful_things.games_played_all_time gp
LEFT JOIN needful_things.yellow_cards_all_time yc ON gp.player_name = yc.player_name
LEFT JOIN needful_things.red_cards_all_time rc ON gp.player_name = rc.player_name
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

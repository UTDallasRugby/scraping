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
SELECT
    COUNT(DISTINCT player_name) as total_players,
    COUNT(DISTINCT season) as total_seasons,
    SUM(CASE WHEN category = 'points' THEN value ELSE 0 END) as total_points,
    SUM(CASE WHEN category = 'tries' THEN value ELSE 0 END) as total_tries
FROM needful_things.player_stats_by_season
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

#!/usr/bin/env python3

# Install with pip install firecrawl-py
from firecrawl import FirecrawlApp
from pydantic import BaseModel, Field
from typing import Any, Optional, List

app = FirecrawlApp(api_key='fc-ec8754b2f42e443b8fbe0a45ef6197af')



class ExtractSchema(BaseModel):
    points: float = None
    transfers: float = None
    conversions: float = None
    penalties: float = None
    goals: float = None
    matches_started: float = None
    matches_played: float = None
    yellow_cards: float = None
    red_cards: float = None

data = app.extract([
  "https://usarugbystats.com/api/stats/club/pts/696/*",
  "https://usarugbystats.com/api/stats/club/tr/696/*",
  "https://usarugbystats.com/api/stats/club/cv/696/*",
  "https://usarugbystats.com/api/stats/club/pk/696/*",
  "https://usarugbystats.com/api/stats/club/dg/696/*",
  "https://usarugbystats.com/api/stats/club/started/696/*",
  "https://usarugbystats.com/api/stats/club/played/696/*",
  "https://usarugbystats.com/api/stats/club/yc/696/*",
  "https://usarugbystats.com/api/stats/club/rc/696/*"
], {
    'prompt': 'Extract club statistics including points, transfers, conversions, penalties, goals, matches started, matches played, yellow cards, and red cards.',
    'schema': ExtractSchema.model_json_schema(),
})

[2021-2022](https://usarugbystats.com/team/696/season/2021-2022)
[2019-2020](https://usarugbystats.com/team/696/season/2019-2020)
[2018-2019](https://usarugbystats.com/team/696/season/2018-2019)
[2017-2018](https://usarugbystats.com/team/696/season/2017-2018)
[2016-2017](https://usarugbystats.com/team/696/season/2016-2017)
[2015-2016](https://usarugbystats.com/team/696/season/2015-2016)
[2014-2015](https://usarugbystats.com/team/696/season/2014-2015)

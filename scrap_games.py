#!/usr/bin/env python3

# Install with pip install firecrawl-py
from firecrawl import FirecrawlApp
from pydantic import BaseModel, Field
from typing import Any, Optional, List

app = FirecrawlApp(api_key='')

class NestedModel3(BaseModel):
    games_played: float = None
    tries: float = None
    points: float = None

class NestedModel2(BaseModel):
    name: str
    position: str = None
    player_id: str = None
    stats: NestedModel3 = None

class NestedModel1(BaseModel):
    name: str
    season: str
    game_ids: list[str] = None
    players: list[NestedModel2] = None

class ExtractSchema(BaseModel):
    team: NestedModel1

data = app.extract([
  "https://usarugbystats.com/embed/team/696/season/2021-2022"
], {
    'prompt': 'Extract the team name, season, game IDs, and player details including name, position, player IDs, and stats such as games played, tries, and points.',
    'schema': ExtractSchema.model_json_schema(),
})

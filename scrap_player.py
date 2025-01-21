#!/usr/bin/env python3

# Install with pip install firecrawl-py
from firecrawl import FirecrawlApp
from pydantic import BaseModel, Field
from typing import Any, Optional, List

app = FirecrawlApp(api_key="")


class NestedModel1(BaseModel):
    matches_played: float = None
    points_scored: float = None
    tries: float = None
    conversions: float = None
    penalties: float = None
    drop_goals: float = None


class NestedModel2(BaseModel):
    date: str = None
    opponent: str = None
    result: str = None
    score: str = None


class NestedModel3(BaseModel):
    team_name: str = None
    years_active: str = None


class ExtractSchema(BaseModel):
    player_stats: NestedModel1 = None
    match_history: list[NestedModel2] = None
    team_history: list[NestedModel3] = None
    clubs_played_for: list[str] = None


data = app.extract(
    [
        "https://usarugbystats.com/player/215800",
        "https://usarugbystats.com/player/285116",
    ],
    {
        "prompt": "Extract all available player stats, match history, team history, clubs played for, and extract all data from all tables from the specified URLs.",
        "schema": ExtractSchema.model_json_schema(),
    },
)

#!/usr/bin/env -S uv run
# /// script
# requires-python = ">=3.12"
# dependencies = [
#     "pytest",
#     "feedparser",
#     "beautifulsoup4",
#     "pandas",
#     "lxml",
# ]
# ///

"""
Regression tests for blog stats parser.

Tests extraction from actual blog posts that historically contained stats.
"""

import pytest
from parse_blog_stats import (
    extract_match_scores,
    extract_try_scorers,
    extract_conversions,
    extract_lineups,
    clean_html,
)


class TestAbilenChristianRecap:
    """Tests for 'Recap of Abilene Christian match' (2018-01-28)."""

    @pytest.fixture
    def post_content(self):
        """Actual content from the Abilene Christian recap post."""
        return """
        UT Dallas 55, ACU 0

        The match started slow, but UTD soon found their rhythm. The first half
        ended with UTD up 32 to ACU's 0.

        Try scorers were Jackson (3 Trys), Steven L. (2 Trys), while Lewis, Eric,
        Aly, Edmund all scoring 1 Try each.

        Lewis Hopkins did convert 5 of 9 Trys.

        Starting Lineup:
        1. Yahve, 2. Jarvis, 3. Joey, 4. Aly, 5. Calvin, 6. Andrew, 7. Steven L,
        8. Caleb, 9. Talhah, 10. Lewis, 11. Josue, 12. Edmund, 13. Tristen,
        14. Octavio, 15. Jackson

        Reserves: 16. Eric, 17. Salah, 18. Shane, 19. Ethan, 20. Kevin, 21. Trenton
        """

    def test_match_score_extraction(self, post_content):
        """Should extract UTD 55 - ACU 0."""
        matches = extract_match_scores(post_content, "2018-01-28", "Test Post")

        assert len(matches) == 1
        assert matches[0]["opponent"] == "ACU"
        assert matches[0]["utd_score"] == 55
        assert matches[0]["opponent_score"] == 0
        assert matches[0]["confidence"] == "high"

    def test_try_scorers_extraction(self, post_content):
        """Should extract 6 try scorers with correct counts."""
        scorers = extract_try_scorers(post_content, "2018-01-28", "Test Post")

        # Should find Jackson (3), Steven L. (2), and 4 players with 1 try each
        assert len(scorers) == 6

        # Check specific scorers
        jackson = [s for s in scorers if s["player_name"] == "Jackson"][0]
        assert jackson["tries_scored"] == 3
        assert jackson["confidence"] == "high"

        steven = [s for s in scorers if "Steven" in s["player_name"]][0]
        assert steven["tries_scored"] == 2
        assert steven["confidence"] == "high"

        # Check list extraction (medium confidence)
        list_scorers = [s for s in scorers if s["notes"] == "Extracted from list"]
        assert len(list_scorers) == 4
        for scorer in list_scorers:
            assert scorer["tries_scored"] == 1
            assert scorer["confidence"] == "medium"

    def test_conversions_extraction(self, post_content):
        """Should extract Lewis Hopkins 5 of 9 conversions."""
        conversions = extract_conversions(post_content, "2018-01-28", "Test Post")

        assert len(conversions) == 1
        assert conversions[0]["kicker_name"] == "Lewis Hopkins"
        assert conversions[0]["conversions_made"] == 5
        assert conversions[0]["conversions_attempted"] == 9
        assert conversions[0]["confidence"] == "high"

    def test_lineup_extraction(self, post_content):
        """Should extract 21 lineup entries (15 starters + 6 reserves)."""
        lineups = extract_lineups(post_content, "2018-01-28", "Test Post")

        assert len(lineups) == 21

        # Check starters (positions 1-15)
        starters = [p for p in lineups if p["role"] == "Starter"]
        assert len(starters) == 15

        # Check specific positions
        prop = [p for p in lineups if p["position"] == 1][0]
        assert prop["player_name"] == "Yahve"

        fullback = [p for p in lineups if p["position"] == 15][0]
        assert fullback["player_name"] == "Jackson"

        # Check reserves (positions 16+)
        reserves = [p for p in lineups if p["role"] == "Reserve"]
        assert len(reserves) == 6


class TestLonestarPlayoffsRecap:
    """Tests for 'Recap of 1st day of Lonestar Playoffs' (2018-02-24)."""

    @pytest.fixture
    def post_content(self):
        """Actual content from the Lonestar Playoffs recap."""
        return """
        The first half ended with the score even at 17.

        The second half was more of the same but this time no one was able to get
        into the goal area, until late in the match UD capitalized on our mistake
        and punched one in goal to win the match 22 to UTD's 17.

        With less than 10 minutes to play the referee had both sides even at 33 each
        (the actual score at the time was UTD 33, Texas St. 31), but Lewis playing
        Flyhalf broke through the Texas St. defense to score the eventual game winner.
        UT Dallas 40, Texas St. 33.
        """

    def test_multiple_match_scores(self, post_content):
        """Should extract 3 match scores (including intermediate scores)."""
        matches = extract_match_scores(post_content, "2018-02-24", "Test Post")

        # Should find: tied at 17, UTD 33 Texas St 31, UT Dallas 40 Texas St 33
        assert len(matches) >= 2  # At minimum the final scores

        # Check for Texas St final score
        texas_st_matches = [m for m in matches if m["opponent"] == "Texas St."]
        assert len(texas_st_matches) >= 1

        # Final score should be 40-33
        final_score = [m for m in texas_st_matches if m["utd_score"] == 40]
        assert len(final_score) == 1
        assert final_score[0]["opponent_score"] == 33

    def test_halftime_score_extraction(self, post_content):
        """Should extract half-time tied score with medium confidence."""
        matches = extract_match_scores(post_content, "2018-02-24", "Test Post")

        halftime = [m for m in matches if m["notes"] == "Half-time score (tied)"]
        assert len(halftime) == 1
        assert halftime[0]["utd_score"] == 17
        assert halftime[0]["opponent_score"] == 17
        assert halftime[0]["confidence"] == "medium"


class TestUNTFriendlyRecap:
    """Tests for 'Recap of UNT friendly' (2018-01-21)."""

    @pytest.fixture
    def post_content(self):
        """Sample lineup content from UNT friendly recap."""
        return """
        First Match Lineup:
        1. Yahve, 2. Jarvis, 3. Joey, 4. Aly, 5. Calvin, 6. Andrew, 7. Steven L,
        8. Caleb, 9. Talhah, 10. Lewis, 11. Josue, 12. Edmund, 13. Tristen,
        14. Octavio, 15. Jackson

        Second Match Lineup:
        1. Shane, 2. Ethan, 3. Salah, 4. John, 5. Kevin, 6. Ben, 7. Victor,
        8. Daniel, 9. Marcus, 10. Chris, 11. Alex, 12. Mike, 13. Tom
        """

    def test_multiple_lineup_extraction(self, post_content):
        """Should extract lineups from both matches."""
        lineups = extract_lineups(post_content, "2018-01-21", "Test Post")

        # Should extract at least 15 from first lineup + 13 from second
        assert len(lineups) >= 28

        # All should have position numbers
        for lineup in lineups:
            assert lineup["position"] >= 1
            assert len(lineup["player_name"]) >= 2


class TestHTMLCleaning:
    """Tests for HTML content cleaning."""

    def test_strip_html_tags(self):
        """Should remove HTML tags and normalize whitespace."""
        html = """<div class="paragraph">
            UT Dallas <strong>55</strong>, ACU 0<br />
            &nbsp;Great match!
        </div>"""

        clean = clean_html(html)

        assert "<div" not in clean
        assert "<strong>" not in clean
        assert "<br" not in clean
        assert "UT Dallas" in clean
        assert "55" in clean

    def test_normalize_whitespace(self):
        """Should collapse multiple spaces into one."""
        html = "<p>UTD    55,   ACU   0</p>"
        clean = clean_html(html)

        assert "UTD 55, ACU 0" in clean


class TestEdgeCases:
    """Tests for edge cases and error conditions."""

    def test_no_matches_in_empty_text(self):
        """Should return empty list for text with no stats."""
        matches = extract_match_scores("", "2018-01-01", "Empty Post")
        assert matches == []

    def test_no_try_scorers_in_non_match_content(self):
        """Should not extract false positives from non-match content."""
        text = "We are going to try hard this season."
        scorers = extract_try_scorers(text, "2018-01-01", "Preview")

        # Should not match "try" in "try hard"
        assert len(scorers) == 0

    def test_lineup_requires_minimum_positions(self):
        """Should not extract lineup from short lists."""
        # Only 5 positions - should not be recognized as a lineup
        text = "1. John, 2. Mike, 3. Steve, 4. Tom, 5. Dan"
        lineups = extract_lineups(text, "2018-01-01", "Short List")

        assert len(lineups) == 0  # Requires at least 10 positions

    def test_handles_player_names_with_initials(self):
        """Should correctly extract names with initials like 'Steven L.'"""
        text = "Steven L. (2 Trys)"
        scorers = extract_try_scorers(text, "2018-01-01", "Test")

        assert len(scorers) == 1
        assert "Steven" in scorers[0]["player_name"]
        assert scorers[0]["tries_scored"] == 2


class TestDataQuality:
    """Tests for confidence scoring and data quality flags."""

    def test_high_confidence_for_clear_patterns(self):
        """Clear patterns should get high confidence."""
        matches = extract_match_scores("UT Dallas 55, ACU 0", "2018-01-01", "Test")
        assert matches[0]["confidence"] == "high"

    def test_medium_confidence_for_list_extraction(self):
        """Players extracted from lists should have medium confidence."""
        text = "Lewis, Eric, Aly all scoring 1 Try each"
        scorers = extract_try_scorers(text, "2018-01-01", "Test")

        for scorer in scorers:
            if scorer["notes"] == "Extracted from list":
                assert scorer["confidence"] == "medium"

    def test_source_title_preserved(self):
        """All extractions should preserve source title for traceability."""
        title = "Important Match Recap"
        matches = extract_match_scores("UTD 40, UTSA 20", "2018-01-01", title)

        assert matches[0]["source_title"] == title

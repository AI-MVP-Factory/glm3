# SPEC 03: AI Scoring Engine
**Priority:** HIGH
**Estimated Effort:** 4 days
**Worker:** glm (Track 1 - can pivot after web ship)

---

## OBJECTIVE
Build an automated scoring engine that evaluates MVP candidates and ranks them for founder review.

## DELIVERABLES

### 1. Scoring Service
- Location: `/Users/p/dev/mvps/services/scoring-engine/`
- Python/FastAPI endpoint
- Async processing of queued signals

### 2. Scoring Logic
- Multi-dimensional scoring (5 dimensions)
- Configurable weights
- Consistent scoring (same input = same score)

### 3. Integration
- Reads from: `/Users/p/dev/mvps/signals/queue.jsonl`
- Writes to: `/Users/p/dev/mvps/signals/scored.jsonl`
- Triggers Brain enrichment

## SCORING DIMENSIONS

| Dimension | Weight | Factors |
|-----------|--------|---------|
| **Market Score** | 25% | TAM, growth rate, monetization potential |
| **Competition Score** | 20% | How crowded, differentiation opportunity |
| **Emotional Score** | 30% | Can we make users FEEL something? (>96 threshold) |
| **Build Feasibility** | 15% | Tech complexity, time estimate, dependencies |
| **Signal Quality** | 10% | Source credibility, engagement strength |

## SCORING API

```python
# scoring-engine/scorer.py
class MVPScorer:
    def score_market(signal: Signal) -> float (0-100)
        # Query Brain for market size, growth
        # Analyze monetization potential
        # Return: 0-100 score

    def score_competition(signal: Signal) -> float (0-100)
        # Search App Store, Product Hunt
        # Count direct competitors
        # Return: Higher = less crowded (opportunity)

    def score_emotional(signal: Signal) -> float (0-100)
        # Use emotional-value skill
        # Evaluate: Can this product evoke emotion?
        # Threshold: 96% to pass

    def score_feasibility(signal: Signal) -> float (0-100)
        # Estimate build time
        # Check for API dependencies
        # Return: Higher = easier to build

    def score_signal_quality(signal: Signal) -> float (0-100)
        # Source credibility (Reddit > X > random)
        # Engagement metrics
        # Return: Higher = better signal

    def score(signal: Signal) -> ScoredCandidate
        # Aggregate all scores
        # Apply weights
        # Return: Overall 0-100 score
```

## OUTPUT FORMAT

```json
{
  "id": "candidate_20260129_001",
  "timestamp": "2026-01-29T10:05:00Z",
  "signal_id": "signal_20260129_001",
  "title": "AI-Powered Habit Tracker",
  "description": "Habit tracker that celebrates streaks, no guilt",
  "scores": {
    "market": 88,
    "competition": 75,
    "emotional": 96,
    "feasibility": 90,
    "signal_quality": 82
  },
  "overall_score": 87.5,
  "verdict": "GO",
  "analysis": {
    "market_size": "$2.4B growing 18% YoY",
    "competitors": "5 major players, all focus on guilt",
    "emotional_hook": "Celebrate wins, not shame failures",
    "build_time": "2-3 days",
    "tech_stack": "React Native, RevenueCat, PostHog"
  },
  "recommendations": [
    "Focus on celebration animations",
    "Differentiate: no streak-freezing (that's guilt)",
    "Name: 'Streak Party' or 'Win Streak'"
  ]
}
```

## ACCEPTANCE CRITERIA
- [ ] Processes all queued signals automatically
- [ ] Returns consistent scores (test-retest reliability)
- [ ] Emotional score threshold 96% enforced
- [ ] Overall score 0-100 scale
- [ ] Clear GO/PASS/RESEARCH verdict
- [ ] Includes actionable recommendations

## OUTPUT
Service code in: `/Users/p/dev/mvps/services/scoring-engine/`
Test run scoring 10+ signals
Integration with Brain for market data
Logs to monitoring

## BONUS
- Add explanation for each score (why 88?)
- Add similar MVPs from history
- Add suggested next steps

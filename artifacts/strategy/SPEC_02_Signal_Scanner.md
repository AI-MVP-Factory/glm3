# SPEC 02: 24/7 Signal Scanner
**Priority:** HIGH
**Estimated Effort:** 5 days
**Worker:** glm4 (infrastructure experience)

---

## OBJECTIVE
Build a 24/7 scanning service that continuously discovers MVP opportunities from the web.

## DELIVERABLES

### 1. Scanner Service
- Location: `/Users/p/dev/mvps/services/signal-scanner/`
- Runs as cron/supervisord service on Alienware
- Python + asyncio for concurrent scanning

### 2. Configuration
- YAML config for sources, intervals, keywords
- Location: `/Users/p/dev/mvps/services/signal-scanner/config.yaml`

### 3. Output Queue
- Writes candidate signals to: `/Users/p/dev/mvps/signals/queue.jsonl`
- Format: JSONL with timestamp, source, signal_data

## SOURCES TO SCAN

| Source | Frequency | What to Extract |
|--------|-----------|-----------------|
| **Reddit** | Hourly | r/SideProject, r/SaaS, r/Entrepreneur - top posts, pain points |
| **X/Twitter** | Hourly | @IndieHackers, @levelsio - tweets about problems, tools |
| **Product Hunt** | Daily | Top 20 launches - analyze patterns, gaps |
| **App Store Charts** | Daily | Top 50 in categories - find underserved niches |
| **Hacker News** | Hourly | Show HN - identify pain points |
| **YC HN** | Daily | "Who wants to build" - founder problems |

## ARCHITECTURE

```python
# signal-scanner/main.py
class SignalScanner:
    def scan_reddit() -> List[Signal]
    def scan_twitter() -> List[Signal]
    def scan_product_hunt() -> List[Signal]
    def scan_app_store() -> List[Signal]
    def scan_hacker_news() -> List[Signal]

    def enrich_with_brain(signal: Signal) -> EnrichedSignal
        # Query Brain for related insights, gaps, patterns

    def queue_candidate(signal: EnrichedSignal)
        # Write to queue.jsonl
```

## SIGNAL FORMAT

```json
{
  "id": "signal_20260129_001",
  "timestamp": "2026-01-29T10:00:00Z",
  "source": "reddit",
  "url": "https://reddit.com/r/SideProject/comments/...",
  "title": "I need a simple habit tracker that doesn't guilt me",
  "extracted_problem": "habit tracker, no guilt, simple",
  "engagement": {
    "upvotes": 234,
    "comments": 45
  },
  "brain_enrichment": {
    "related_signals": 3,
    "market_size": "$2.4B",
    "similar_attempts": 2
  }
}
```

## ACCEPTANCE CRITERIA
- [ ] Scans all 6 sources automatically
- [ ] Runs 24/7 without manual intervention
- [ ] Outputs 10-30 quality signals per day
- [ ] Each signal enriched with Brain context
- [ ] Logs to Prometheus for monitoring
- [ ] Graceful error handling (partial failures OK)

## OUTPUT
Service code in: `/Users/p/dev/mvps/services/signal-scanner/`
Systemd/supervisord config for auto-start
Test run producing 5+ signals
Logs to Alienware for monitoring

## BONUS
- Add web UI for viewing signal stream
- Add manual "scan now" endpoint

# Brain Intelligence Audit - 2026-01-28

## Overview

**Location**: Alienware (192.168.68.58)
**API Endpoint**: http://192.168.68.58:8080
**Database**: LanceDB at `/var/oled/brain/lancedb`

## Database Statistics

### Knowledge Graph Tables
| Table | Records | Notes |
|-------|---------|-------|
| kg_entities | 21,138 | Core entities |
| kg_relationships | 21,008 | 0.99 per entity |
| kg_processed | 1,010 | Processed records |
| reasoning_chains | 12,350 | Logic chains |
| runbooks | 6,438 | Operational guides |
| communities | 4,231 | Entity clusters |
| wisdom | 4,784 | High-value insights |
| anticipated_needs | 15,677 | Predicted queries |

### Core Storage Tables
| Table | Records | Growth |
|-------|---------|--------|
| research_neural | 316,771 | Primary |
| session_knowledge | 28,927 | Sessions |
| synthesized_insights | 12,372 | Derived |
| meta_knowledge | 9,250 | Meta |
| query_analytics | 8,012 | Queries |
| document_versions | 7,347 | Versions |
| session_archive | 6,270 | Archive |

### Summary
- **Total Records**: 485,848
- **Total Tables**: 55
- **Largest Table**: research_neural (65% of total)

## Worker Status (PC)

### Active Workers
| Worker | Last Activity | Status | Details |
|--------|---------------|--------|---------|
| Entity | 17:16 | Processing | 49.8% (157K/315K), +2 entities, 1386 dupes |
| Relationship | 14:06 | Idle | 20,547 rels @ 0.98/entity |
| Reasoning | 17:18 | Active | 404 chains, 213 runbooks |

### Sleeping Workers
| Worker | Since | Reason |
|--------|-------|--------|
| Wisdom | 14:05 | No high-value records detected |
| Community | Jan 27 | Minimal changes |
| Anticipator | 17:14 | No recent queries |
| Ingestion | Jan 27 | Connected, 309K records |

## Worker Analysis

### Entity Worker
- **Progress**: 49.8% complete
- **Processed**: 157,000 / 315,000
- **Duplicates**: 1,386 detected
- **Activity**: Currently processing

**Opportunity**: High duplicate rate suggests entity matching needs tuning.

### Relationship Worker
- **Relationships**: 20,547
- **Ratio**: 0.97 per entity (below target of 0.99)
- **Status**: Idle since 14:06

**Opportunity**: Could process more relationships to reach target ratio.

### Reasoning Worker
- **Chains**: 404 active
- **Runbooks**: 213 generated
- **Status**: Active

**Opportunity**: Low runbook yield (~53%) - could improve reasoning quality.

### Wisdom Worker
- **Records**: 4,784 wisdom entries
- **Status**: Sleeping

**Opportunity**: Only 4,784 wisdom records vs 12,372 synthesized insights - gap exists.

### Community Worker
- **Communities**: 4,231
- **Last Run**: Jan 27
- **Status**: Sleeping

**Opportunity**: New entities since Jan 27 - recluster recommended.

## Query Analytics

| Metric | Value |
|--------|-------|
| Total Queries Tracked | 8,012 |
| Anticipated Needs | 15,677 |

**Analysis Opportunity**: Query patterns not analyzed - recommend review.

## Knowledge Graph Health

| Metric | Value | Target | Status |
|--------|-------|--------|--------|
| Entity Coverage | 21,138 | - | ✅ Growing |
| Relationship Density | 0.97 | 0.99 | 🟡 Below target |
| Processing Rate | 49.8% | 90% | 🟡 Halfway |
| Duplicate Rate | 0.9% | <0.1% | 🔴 High |

## API Endpoints

### Available Endpoints
```
GET  /health              - Health check
POST /query               - Query the brain
POST /query/smart         - Smart query with reasoning
GET  /entities            - List entities
GET  /insights            - Get wisdom
POST /wisdom              - Add wisdom
GET  /metrics             - API metrics
```

### Query Test Result
```json
{
  "query": "test",
  "answer": "Unfortunately, the question \"test\" is quite vague...",
  "sources": ["research_neural"],
  "confidence": 0.95
}
```

## Quality Indicators

| Indicator | Value | Assessment |
|-----------|-------|------------|
| Record Growth | +316K (neural) | ✅ Excellent |
| Entity Dupes | 1,386 (0.9%) | 🟡 Needs tuning |
| Reasoning Yield | 53% | 🟡 Could improve |
| Wisdom Coverage | 39% | 🟡 Gap exists |

## Recommendations

1. **Immediate** - Investigate entity deduplication
2. **Short-term** - Wake community worker for reclustering
3. **Medium-term** - Improve reasoning chain quality
4. **Long-term** - Wisdom extraction automation

# API Endpoints Documentation

## Overview

This document provides a comprehensive overview of all REST APIs in the SOLO AI Factory ecosystem. The system consists of multiple microservices that communicate internally and expose external APIs for management and monitoring.

## Service Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    SOLO AI FACTORY SERVICES                      │
├─────────────────────────────────────────────────────────────────┤
│  ┌───────────────┐    ┌──────────────┐    ┌─────────────────┐  │
│  │               │    │              │    │                 │  │
│  │ Signal        │    │  Scoring     │    │   Morning Brief │  │
│  │ Scanner       │◄───►│  Engine     │◄───►│   Generator     │  │
│  │ (Historical)  │    │   (Port      │    │   (Scheduled)   │  │
│  └───────────────┘    │   8082)      │    └─────────────────┘  │
│                         │              │                         │
│  ┌─────────────────────┐ └────────────┘ ┌─────────────────────┐ │
│  │                     │                │                     │ │
│  │                     │                │                     │ │
│  │                     │                │                     │ │
│  │   Brain API         │                │   Ops Agent         │ │
│  │  (Alienware :8080)   │                │   (No API)         │ │
│  │                     │                │                     │ │
│  │                     │                │                     │ │
│  └─────────────────────┘ └──────────────┴─────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

## 1. Brain API (Alienware :8080)

**Location**: `http://192.168.68.58:8080`  
**Purpose**: Central knowledge base for AI Factory. Stores all signals, scores, insights, and operational data.

### Core Endpoints

#### 1.1 Query Endpoint

- **Method**: POST
- **Path**: `/query`
- **Authentication**: `X-API-Key` header
- **Request Format**:
  ```json
  {
    "query": "string",
    "limit": 10 (optional),
    "context": "string" (optional)
  }
  ```
- **Response Format**:
  ```json
  {
    "answer": "string",
    "sources": [
      {
        "id": "string",
        "type": "signal|score|insight",
        "content": "string",
        "confidence": 0.95,
        "metadata": {}
      }
    ],
    "confidence": 0.95,
    "processing_time_ms": 45
  }
  ```

#### 1.2 Smart Query Endpoint

- **Method**: POST
- **Path**: `/query/smart`
- **Authentication**: `X-API-Key` header
- **Request Format**:
  ```json
  {
    "query": "string",
    "filters": {
      "source": "reddit|twitter|hackernews|...",
      "min_score": 80,
      "verdict": "GO|PASS|RESEARCH"
    },
    "sort_by": "score|date|engagement",
    "limit": 20
  }
  ```
- **Response Format**: Enhanced query with filtering capabilities

#### 1.3 Health Check

- **Method**: GET
- **Path**: `/health`
- **Authentication**: None
- **Response Format**:
  ```json
  {
    "status": "healthy|degraded|down",
    "response_time_ms": 45,
    "database_status": "connected",
    "last_update": "2026-01-29T10:00:00Z",
    "total_records": 166000,
    "service_uptime_hours": 720
  }
  ```

### Specialized Endpoints

#### 1.4 Entity Extraction

- **Method**: POST
- **Path**: `/entities`
- **Authentication**: `X-API-Key` header
- **Request Format**:
  ```json
  {
    "text": "input text containing entities",
    "types": ["company", "technology", "market", "problem"]
  }
  ```
- **Response Format**:
  ```json
  {
    "entities": [
      {
        "text": "company name",
        "type": "company",
        "confidence": 0.92,
        "context": "extracted context"
      }
    ]
  }
  ```

#### 1.5 Insights Generation

- **Method**: POST
- **Path**: `/insights`
- **Authentication**: `X-API-Key` header
- **Request Format**:
  ```json
  {
    "time_range": "24h|7d|30d",
    "category": "signals|scores|ops",
    "limit": 5
  }
  ```
- **Response Format**:
  ```json
  {
    "insights": [
      {
        "text": "Generated insight summary",
        "category": "market_trends",
        "confidence": 0.88,
        "data_points": 42,
        "generated_at": "2026-01-29T10:00:00Z"
      }
    ]
  }
  ```

#### 1.6 Wisdom/Knowledge Base

- **Method**: POST
- **Path**: `/wisdom`
- **Authentication**: `X-API-Key` header
- **Request Format**:
  ```json
  {
    "domain": "mvp_scoring|market_analysis|technical_feasibility",
    "query": "specific question"
  }
  ```
- **Response Format**: Returns curated knowledge from past scoring results

## 2. Scoring Engine API (Port 8082)

**Location**: `http://localhost:8082`  
**Purpose**: Scores MVP candidates across 5 dimensions (market, competition, emotional, feasibility, signal quality)

### Core Endpoints

#### 2.1 Health Check

- **Method**: GET
- **Path**: `/health`
- **Authentication**: None
- **Response Format**:
  ```json
  {
    "status": "healthy|degraded",
    "brain_connected": true,
    "queue_size": 5,
    "uptime_seconds": 3600
  }
  ```

#### 2.2 Score Single Signal

- **Method**: POST
- **Path**: `/score`
- **Authentication**: None (CORS enabled)
- **Request Format**:
  ```json
  {
    "signal": {
      "id": "signal_20260129_0001",
      "title": "Problem description",
      "description": "Detailed problem statement",
      "source": "reddit",
      "source_url": "https://reddit.com/post/123",
      "extracted_problem": "User pain point",
      "engagement": {
        "upvotes": 150,
        "comments": 45
      },
      "author": "username",
      "timestamp": "2026-01-29T10:00:00Z"
    }
  }
  ```
- **Response Format**:
  ```json
  {
    "success": true,
    "candidate": {
      "id": "signal_20260129_0001",
      "verdict": "GO",
      "overall_score": 87.5,
      "scores": {
        "market": { "score": 92.0, "reasoning": "Large TAM, growing market" },
        "competition": { "score": 85.0, "reasoning": "Moderate competition" },
        "emotional": { "score": 96.0, "reasoning": "High emotional engagement" },
        "feasibility": { "score": 78.0, "reasoning": "2-3 week build time" },
        "signal_quality": { "score": 82.0, "reasoning": "High engagement from credible source" }
      },
      "market_size": "$2.1B",
      "build_time": "14 days",
      "confidence": 0.92,
      "scored_at": "2026-01-29T10:05:00Z"
    }
  }
  ```

#### 2.3 Score Batch Signals

- **Method**: POST
- **Path**: `/score/batch`
- **Authentication**: None
- **Request Format**:
  ```json
  {
    "signals": [
      { /* signal object */ },
      { /* signal object */ }
    ]
  }
  ```
- **Response Format**:
  ```json
  {
    "success": true,
    "candidates": [/* array of scored candidates */],
    "errors": [],
    "processed": 5,
    "failed": 0
  }
  ```

#### 2.4 Process Queue

- **Method**: POST
- **Path**: `/process-queue`
- **Authentication**: None
- **Request Format**: Empty
- **Response Format**:
  ```json
  {
    "status": "started",
    "message": "Queue processing started in background"
  }
  ```
- **Notes**: Runs in background as async task

#### 2.5 Get Scored Candidates

- **Method**: GET
- **Path**: `/candidates`
- **Authentication**: None
- **Query Parameters**:
  - `verdict`: "GO" | "PASS" | "RESEARCH" (optional)
  - `min_score`: Minimum score filter (optional)
  - `limit`: Maximum results to return (default: 50)
- **Response Format**:
  ```json
  {
    "candidates": [
      {/* scored candidate object */}
    ],
    "total": 25
  }
  ```

#### 2.6 Get Statistics

- **Method**: GET
- **Path**: `/stats`
- **Authentication**: None
- **Response Format**:
  ```json
  {
    "total": 150,
    "by_verdict": {
      "GO": 25,
      "PASS": 85,
      "RESEARCH": 40
    },
    "avg_scores": {
      "market": 78.5,
      "competition": 72.3,
      "emotional": 85.1,
      "feasibility": 76.8,
      "signal_quality": 79.4
    }
  }
  ```

#### 2.7 Clear Queue

- **Method**: DELETE
- **Path**: `/queue`
- **Authentication**: None
- **Response Format**:
  ```json
  {
    "status": "cleared" | "ok",
    "message": "Queue cleared" | "Queue was empty"
  }
  ```

## 3. Internal Service Communication

### 3.1 Scanner → Brain Integration

The scanner (archived) enriches signals by calling Brain API:

```python
# Example enrichment call
POST http://192.168.68.58:8080/query
Headers: X-API-Key: <api_key>
Body: {
    "query": "MVP opportunity: {signal.title}. {signal.extracted_problem}",
    "limit": 3
}
```

### 3.2 Scorer → Brain Integration

The scoring engine queries Brain for market data:

```python
# Market size query
POST http://192.168.68.58:8080/query
Headers: X-API-Key: <api_key>
Body: {
    "query": "Market analysis for: {category}\nDescription: {description}"
}
```

### 3.3 Morning Brief → Brain Integration

Daily brief generator fetches insights:

```python
# Get daily insights
POST http://192.168.68.58:8080/insights
Headers: X-API-Key: <api_key>
Body: {
    "limit": 1
}
```

## 4. Signal Submission (No Current API)

**Current Status**: No direct API exists for submitting signals  
**Methods**: Signals are currently added via:
1. Manual JSON files in `/Users/p/dev/mvps/signals/`
2. Historical scanner service (archived)
3. Direct queue file manipulation

**Future Enhancement**: Consider implementing:
- POST `/signals` endpoint
- Webhook endpoint for external sources
- Batch upload endpoint

## 5. Ops Agent (No API Endpoints)

**Purpose**: Internal monitoring and auto-resolution  
**Communication**: Direct process-to-process, no HTTP API  
**Health Check**: Via `/health` endpoints of other services

## 6. Authentication

### 6.1 API Key Format

- **Header**: `X-API-Key`
- **Source**: `/Users/p/.config/solo/api_key.env`
- **Format**: `SOLO_API_KEY="your-api-key-here"`

### 6.2 Security Considerations

- All services accept CORS from any origin (`*`)
- Brain API requires authentication for non-health endpoints
- API keys should be stored in environment files
- No rate limiting currently implemented

## 7. Data Flow Architecture

```
Signal Sources ──► Scanner (historical) ──► Queue ──► Scorer ──► Scored File
                     │                         │
                     └───► Brain Enrichment ◄─────┘
                                                       │
                                          Morning Brief ◄───┘
```

## 8. Error Responses

All endpoints return consistent error formats:

```json
{
  "success": false,
  "error": "Error message",
  "details": "Additional context (optional)",
  "timestamp": "2026-01-29T10:00:00Z"
}
```

## 9. Monitoring & Metrics

### 9.1 Prometheus Integration

- **Scoring Engine**: Metrics on port 9100 (when running)
  - `signal_scanner_signals_total`
  - `signal_scanner_errors_total`
  - `signal_scanner_duration_seconds`

### 9.2 Health Dashboard

Access at: `/Users/p/dev/mvps/scripts/dashboard.sh`

## 10. Quick Reference

| Service | Port | Purpose | Key Endpoints |
|---------|------|---------|--------------|
| Brain API | 8080 | Knowledge base | `/query`, `/insights`, `/health` |
| Scoring Engine | 8082 | MVP scoring | `/score`, `/candidates`, `/stats` |
| Morning Brief | Scheduled | Daily report | (CLI only) |
| Ops Agent | Process | Monitoring | (No API) |

## 11. Development Notes

- All services use FastAPI framework
- Async/await pattern throughout
- JSON Lines format for signal queues
- Comprehensive logging with structlog
- Prometheus metrics for observability

# Data Models - GLM3 Project

This document provides a comprehensive overview of all data structures, schemas, and models used across the GLM3 project and MVP services.

## Table of Contents

1. [Scoring Engine Models](#scoring-engine-models)
2. [Ops Agent Models](#ops-agent-models)
3. [API Request/Response Models](#api-requestresponse-models)
4. [Configuration Models](#configuration-models)
5. [Database Schema (LanceDB)](#database-schema-lancedb)
6. [Data Flow Transformations](#data-flow-transformations)

---

## Scoring Engine Models

### Signal

**Purpose**: Raw signal data from queue for MVP candidate scoring

```python
class Signal(BaseModel):
    """Raw signal from the queue."""
    
    id: str = Field(default_factory=lambda: f"signal_{datetime.utcnow().strftime('%Y%m%d_%H%M%S')}_{uuid4().hex[:6]}")
    timestamp: str = Field(default_factory=lambda: datetime.utcnow().isoformat() + "Z")
    source: str
    source_url: Optional[str] = None
    title: str
    description: str
    category: Optional[str] = None
    tags: List[str] = Field(default_factory=list)
    engagement: Dict[str, int] = Field(default_factory=dict)
    author: Optional[str] = None
    extracted_at: Optional[str] = None
    
    # Raw context for scoring
    raw_content: Optional[str] = None
    comments: Optional[List[str]] = None
```

**JSON Schema**:
```json
{
  "type": "object",
  "properties": {
    "id": {"type": "string"},
    "timestamp": {"type": "string", "format": "date-time"},
    "source": {"type": "string"},
    "source_url": {"type": ["string", "null"]},
    "title": {"type": "string"},
    "description": {"type": "string"},
    "category": {"type": ["string", "null"]},
    "tags": {"type": "array", "items": {"type": "string"}},
    "engagement": {"type": "object", "additionalProperties": {"type": "integer"}},
    "author": {"type": ["string", "null"]},
    "extracted_at": {"type": ["string", "null"]},
    "raw_content": {"type": ["string", "null"]},
    "comments": {"type": ["array", "null"], "items": {"type": "string"}}
  }
}
```

### ScoreBreakdown

**Purpose**: Individual dimension scores with reasoning

```python
@dataclass
class ScoreBreakdown:
    """Individual dimension scores."""
    
    market: float = 0.0
    competition: float = 0.0
    emotional: float = 0.0
    feasibility: float = 0.0
    signal_quality: float = 0.0
    
    # Explanations
    market_reasoning: str = ""
    competition_reasoning: str = ""
    emotional_reasoning: str = ""
    feasibility_reasoning: str = ""
    signal_quality_reasoning: str = ""
```

### ScoredCandidate

**Purpose**: A fully scored MVP candidate with verdict

```python
class ScoredCandidate(BaseModel):
    """A fully scored MVP candidate."""
    
    id: str = Field(default_factory=lambda: f"candidate_{datetime.utcnow().strftime('%Y%m%d_%H%M%S')}_{uuid4().hex[:6]}")
    timestamp: str = Field(default_factory=lambda: datetime.utcnow().isoformat() + "Z")
    signal_id: str
    title: str
    description: str
    
    # Scores (dimension -> score)
    scores: Dict[str, float] = Field(default_factory=dict)
    overall_score: float = 0.0
    
    # Score reasoning
    reasoning: Dict[str, str] = Field(default_factory=dict)
    
    # Verdict
    verdict: str = "RESEARCH"  # GO, PASS, RESEARCH
    
    # Analysis details
    analysis: Dict[str, Any] = Field(default_factory=dict)
    
    # Recommendations
    recommendations: List[str] = Field(default_factory=list)
    
    # Original signal data (for reference)
    source: Optional[str] = None
    source_url: Optional[str] = None
    category: Optional[str] = None
    tags: List[str] = Field(default_factory=list)
```

### Request/Response Models

```python
class ScoreRequest(BaseModel):
    """Request to score a signal."""
    signal: Signal
    config: Optional[Dict[str, Any]] = None

class ScoreResponse(BaseModel):
    """Response from scoring endpoint."""
    success: bool
    candidate: Optional[ScoredCandidate] = None
    error: Optional[str] = None

class BatchScoreRequest(BaseModel):
    """Request to score multiple signals."""
    signals: List[Signal]
    config: Optional[Dict[str, Any]] = None

class BatchScoreResponse(BaseModel):
    """Response from batch scoring endpoint."""
    success: bool
    candidates: List[ScoredCandidate] = Field(default_factory=list)
    errors: List[str] = Field(default_factory=list)
    processed: int = 0
    failed: int = 0

class HealthResponse(BaseModel):
    """Health check response."""
    status: str
    service: str = "scoring-engine"
    version: str = "1.0.0"
    brain_connected: bool = False
    queue_size: int = 0
```

---

## Ops Agent Models

### HealthStatus & HealthCheckResult

```python
class HealthStatus(Enum):
    HEALTHY = "healthy"
    DEGRADED = "degraded"
    CRITICAL = "critical"
    UNKNOWN = "unknown"

@dataclass
class HealthCheckResult:
    service: str
    status: HealthStatus
    message: str
    details: Dict = field(default_factory=dict)
    timestamp: datetime = field(default_factory=datetime.utcnow)
```

### Diagnosis & AIDiagnosis

```python
class Confidence(Enum):
    HIGH = "high"    # > 80% sure
    MEDIUM = "medium"  # 50-80% sure
    LOW = "low"      # < 50% sure

@dataclass
class Diagnosis:
    """AI diagnosis of an issue."""
    issue_name: str
    confidence: Confidence
    summary: str
    root_cause: str
    suggested_action: str
    reasoning: str
    similar_issues: List[Dict] = field(default_factory=list)
    timestamp: datetime = None
```

### ResolutionStatus & ResolutionResult

```python
class ResolutionStatus(Enum):
    SUCCESS = "success"
    FAILED = "failed"
    PARTIAL = "partial"
    SKIPPED = "skipped"

@dataclass
class ResolutionResult:
    issue_name: str
    status: ResolutionStatus
    steps_completed: List[str]
    steps_failed: List[str]
    message: str
    details: Dict[str, Any]
    timestamp: datetime = None
```

### Alert & Escalation Models

```python
class AlertLevel(Enum):
    INFO = "info"
    WARNING = "warning"
    CRITICAL = "critical"
    EMERGENCY = "emergency"

class EscalationAction(Enum):
    LOG_ONLY = "log_only"
    ALERT_FOUNDER = "alert_founder"
    IMMEDIATE_ALERT = "immediate_alert"
    CRITICAL_ALERT = "critical_alert"

@dataclass
class Alert:
    level: AlertLevel
    title: str
    message: str
    service: str
    details: Dict[str, Any]
    timestamp: datetime = None
    action: EscalationAction = EscalationAction.LOG_ONLY

@dataclass
class EscalationCriteria:
    revenue_drop_threshold: float = 20.0  # %
    service_down_threshold: int = 10  # minutes
    disk_critical_threshold: int = 95  # %
    worker_crash_threshold: int = 3  # times per hour
    memory_critical_threshold: int = 98  # %
```

### IssueResolution & LearningModule

```python
@dataclass
class IssueResolution:
    """A record of an issue and its resolution."""
    issue_name: str
    symptoms: Dict[str, Any]
    diagnosis: str
    action_taken: str
    resolution_status: str
    lesson_learned: str
    timestamp: datetime = None
    tags: List[str] = None
```

### Agent Configuration

```python
@dataclass
class OpsAgentConfig:
    """Configuration for the Ops Agent."""
    check_interval: int = 60  # seconds between health checks
    ai_diagnosis_enabled: bool = True
    auto_resolve_enabled: bool = True
    learning_enabled: bool = True
    log_path: str = field(default_factory=lambda: os.getenv(
        "OPS_AGENT_LOG_PATH",
        os.path.join(os.path.dirname(os.path.dirname(__file__)), "logs")
    ))
    brain_api_url: str = "http://192.168.68.58:8080"
    ai_api_key: Optional[str] = None
    ai_base_url: str = "http://127.0.0.1:8788/v1"

@dataclass
class AgentStatus:
    """Current status of the Ops Agent."""
    running: bool = True
    last_check: Optional[datetime] = None
    total_checks: int = 0
    issues_detected: int = 0
    auto_resolutions: int = 0
    escalations: int = 0
    start_time: datetime = field(default_factory=lambda: datetime.now(timezone.utc))
```

---

## API Request/Response Models

### Common Response Format

All APIs follow this standardized response format:

```json
{
  "success": true,
  "data": {},
  "message": "Operation completed",
  "timestamp": "2024-01-01T00:00:00Z",
  "errors": []
}
```

### Error Response Format

```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid input data",
    "details": {
      "field": "email",
      "issue": "required"
    }
  },
  "timestamp": "2024-01-01T00:00:00Z"
}
```

---

## Configuration Models

### Scoring Configuration

```python
@dataclass
class ScoringConfig:
    """Runtime configuration for scoring."""
    market_weight: float = 0.25
    competition_weight: float = 0.20
    emotional_weight: float = 0.30
    feasibility_weight: float = 0.15
    signal_quality_weight: float = 0.10
    emotional_threshold: float = 96.0
    go_threshold: float = 85.0
    research_threshold: float = 70.0
    brain_api_url: str = "http://192.168.68.58:8080"
    brain_timeout: float = 30.0
```

### System Configuration

```python
# Service endpoints configuration
SERVICES = {
    "brain_api": {
        "name": "Brain API",
        "url": "http://localhost:8080/health",
        "method": "GET",
        "timeout": 5,
        "host": "alien",
    },
    "litellm": {
        "name": "LiteLLM",
        "url": "http://192.168.68.58:4001/health",
        "method": "GET",
        "timeout": 5,
        "host": "alien",
    },
    # ... other services
}

# Thresholds
THRESHOLDS = {
    "disk_warning": 90,
    "disk_critical": 95,
    "memory_warning": 90,
    "memory_critical": 95,
}
```

---

## Database Schema (LanceDB)

### Signals Table

```sql
CREATE TABLE IF NOT EXISTS signals (
    id VARCHAR PRIMARY KEY,
    timestamp TIMESTAMP,
    source VARCHAR,
    source_url VARCHAR,
    title TEXT,
    description TEXT,
    category VARCHAR,
    tags ARRAY(STRING),
    engagement JSONB,
    author VARCHAR,
    extracted_at TIMESTAMP,
    raw_content TEXT,
    comments ARRAY(STRING)
);
```

### ScoredCandidates Table

```sql
CREATE TABLE IF NOT EXISTS scored_candidates (
    id VARCHAR PRIMARY KEY,
    signal_id VARCHAR,
    title TEXT,
    description TEXT,
    scores JSONB,
    overall_score FLOAT,
    reasoning JSONB,
    verdict VARCHAR,
    analysis JSONB,
    recommendations ARRAY(STRING),
    source VARCHAR,
    source_url VARCHAR,
    category VARCHAR,
    tags ARRAY(STRING),
    timestamp TIMESTAMP
);
```

### Ops Resolutions Table

```sql
CREATE TABLE IF NOT EXISTS ops_resolutions (
    id VARCHAR PRIMARY KEY,
    issue_name VARCHAR,
    symptoms JSONB,
    diagnosis TEXT,
    action_taken TEXT,
    resolution_status VARCHAR,
    lesson_learned TEXT,
    timestamp TIMESTAMP,
    tags ARRAY(STRING)
);
```

### Brain Schema

The Brain uses LanceDB with the following table structure:

#### research_neural Table (166K+ records)
- Fields: content, metadata, embeddings (2048-dim)
- Used for semantic search on research data

#### ops_resolutions Table
- Fields: content, metadata, embeddings
- Stores issue resolution patterns

#### embeddings Table
- Fields: vector_id, content, metadata, embedding
- General-purpose embeddings storage

---

## Data Flow Transformations

### 1. Signal Processing Pipeline

```
Raw Signal → Signal Model → ScoreRequest → ScoredCandidate → Storage
```

**Transformations**:
- Signal ID generation with timestamp + UUID
- Content extraction and cleaning
- Engagement metrics normalization
- Category tagging

### 2. Health Check Processing

```
Service Check → HealthCheckResult → Diagnosis → Resolution → Alert
```

**Transformations**:
- HTTP status code to HealthStatus enum
- Response metrics to structured details
- AI analysis to Diagnosis object
- Command execution to ResolutionResult

### 3. Learning Pipeline

```
Issue Resolution → IssueResolution → Brain Storage → Pattern Recognition
```

**Transformations**:
- Resolution details to structured format
- Symptom similarity calculation
- Pattern extraction and scoring
- Runbook suggestion generation

### 4. Data Serialization

All models support:
- JSON serialization via `.to_dict()`
- Pydantic model validation
- Custom JSON encoders for datetime
- Field type coercion

### 5. Data Validation

Validation rules:
- Required field enforcement
- Type checking and coercion
- Enum value validation
- Custom validators (e.g., email format)
- Length constraints

---

## Model Relationships

### Signal → ScoredCandidate
- One-to-many relationship
- Signal.id → ScoredCandidate.signal_id

### HealthCheckResult → Diagnosis
- One-to-one relationship
- HealthCheckResult.service → Diagnosis.issue_name

### Diagnosis → ResolutionResult
- One-to-one relationship
- Diagnosis.issue_name → ResolutionResult.issue_name

### IssueResolution → Brain
- Many-to-one relationship
- Stored in "ops_resolutions" table with embeddings

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2024-01-01 | Initial version with core models |
| 1.1.0 | 2024-01-15 | Added Ops Agent models |
| 1.2.0 | 2024-01-20 | Enhanced scoring breakdown |
| 1.3.0 | 2024-01-25 | Added learning module models |

---

## Best Practices

1. **Immutable IDs**: Use timestamp + UUID for all generated IDs
2. **Timestamps**: Always use ISO 8601 format with 'Z' for UTC
3. **Error Handling**: Include detailed error messages and codes
4. **Validation**: Validate all input data at boundaries
5. **Logging**: Include structured logging for all operations
6. **Performance**: Use lazy loading for large fields (e.g., raw_content)
7. **Security**: Sanitize all external inputs
8. **Testing**: Mock external dependencies in tests

---

## Configuration Management

All configuration is managed through:
1. Environment variables for sensitive data
2. YAML files for application configuration
3. Code defaults for fallback values
4. Runtime validation of configuration

### Configuration Hierarchy

```
1. Hardcoded defaults (lowest priority)
2. YAML configuration files
3. Environment variables (highest priority)
```

This ensures flexibility across different deployment environments while maintaining security and reliability.

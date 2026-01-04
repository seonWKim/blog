# AI Workflow Tracker - Product Requirements Document

**Version:** 1.0
**Last Updated:** 2026-01-04
**Status:** Planning

---

## Executive Summary

**AI Workflow Tracker** is an observability and audit system for AI agent workflows. It provides structured logging,
analytics, and debugging capabilities for complex multi-step AI operations like blog post generation, code refactoring,
research synthesis, and more.

**Core Value Proposition:**

- **Visibility**: See exactly what your AI agents are doing at each step
- **Reproducibility**: Replay and understand past generations
- **Improvement**: Identify patterns, failures, and optimization opportunities
- **Compliance**: Maintain audit trails for AI-generated content
- **Learning**: Build a knowledge base of what prompts and strategies work

---

## Problem Statement

### Current Pain Points

1. **Black Box Operations**: When AI generates content through multi-step workflows, it's unclear:
    - What prompts were actually used
    - What intermediate outputs were generated
    - Why certain decisions were made
    - How long each phase took

2. **No Historical Context**:
    - Can't compare quality across different generations
    - Can't identify which prompts produce better results
    - Can't track improvement over time

3. **Difficult Debugging**:
    - When output quality drops, hard to pinpoint the cause
    - Can't easily A/B test different prompting strategies
    - No metrics on token usage or costs

4. **Limited Reusability**:
    - Good prompts get lost in conversation history
    - Successful patterns aren't systematically captured
    - Can't build on previous learnings

---

## Vision & Scope

### Product Vision

Build the **observability layer for AI agent workflows** - making AI operations as transparent and debuggable as
traditional software systems.

### Scope

#### In Scope (V1)

- Session tracking for multi-step AI workflows
- Prompt and response logging with metadata
- Command execution tracking
- Artifact tracking (files created/modified)
- Quality issue tracking (for content workflows)
- Basic querying and reporting
- SQLite-based for simplicity and portability

#### In Scope (V2+)

- Web UI for browsing sessions
- Prompt optimization recommendations
- Cost tracking and analytics
- Multi-agent workflow support
- Export to common formats (JSON, CSV)
- Integration with other tools (LangSmith, Weights & Biases)
- Prompt template library
- Workflow comparison and diffing

#### Out of Scope

- Real-time monitoring (focus on post-hoc analysis)
- Production deployment infrastructure
- Multi-user access control (single-user local tool initially)
- Prompt hosting or sharing service

---

## Architecture Principles

### 1. Workflow-Agnostic Core

The core data model should work for **any** multi-step AI workflow:

- Blog post generation
- Code refactoring
- Research synthesis
- Data analysis
- Document translation
- Creative writing
- etc.

**Key abstraction**: A workflow is composed of:

- **Sessions** (one execution of a workflow)
- **Phases** (logical steps within a workflow)
- **Prompts** (inputs to AI)
- **Responses** (outputs from AI)
- **Actions** (commands executed, files modified)
- **Artifacts** (deliverables produced)
- **Issues** (quality problems detected)

### 2. Extensible Schema

Use JSON fields and plugin architecture to allow:

- Custom metadata per workflow type
- Domain-specific issue types
- Workflow-specific phases
- Custom metrics and tracking

### 3. Local-First

- SQLite for zero-config setup
- Works offline
- User owns their data
- Easy to backup/version control
- Can sync across machines via git

### 4. CLI-First, GUI-Later

- Start with simple CLI for logging and querying
- Build web UI later when patterns are proven
- API-driven so multiple frontends possible

### 5. Minimal Dependencies

- Rust + tursodb 
- Optional dependencies for advanced features
- Easy to install and run

---

## Data Model

### Core Entities

```
Workflows (Workflow Types/Templates)
  ├── workflow_id
  ├── name (e.g., "blog-post", "code-refactor")
  ├── version
  ├── schema (JSON) - defines phases, metrics, etc.
  └── config (JSON) - default settings

Sessions (Workflow Executions)
  ├── session_id
  ├── workflow_id → Workflows
  ├── started_at
  ├── completed_at
  ├── status (started, in_progress, completed, failed)
  ├── inputs (JSON) - initial parameters
  ├── outputs (JSON) - final results
  ├── metadata (JSON) - extensible
  └── cost_usd (tracked if available)

Phases (Steps within a Session)
  ├── phase_id
  ├── session_id → Sessions
  ├── phase_name (e.g., "research", "draft", "review")
  ├── started_at
  ├── completed_at
  ├── status
  └── metadata (JSON)

Prompts (AI Inputs)
  ├── prompt_id
  ├── phase_id → Phases
  ├── created_at
  ├── prompt_text
  ├── system_context (system message if applicable)
  ├── temperature
  ├── max_tokens
  └── metadata (JSON)

Responses (AI Outputs)
  ├── response_id
  ├── prompt_id → Prompts
  ├── created_at
  ├── response_text
  ├── model (e.g., "claude-sonnet-4.5")
  ├── tokens_input
  ├── tokens_output
  ├── cost_usd
  ├── latency_ms
  └── metadata (JSON)

Actions (Commands/Operations)
  ├── action_id
  ├── phase_id → Phases
  ├── executed_at
  ├── action_type (bash, read, write, edit, api_call, etc.)
  ├── action_text (command or description)
  ├── exit_code
  ├── output_preview
  └── metadata (JSON)

Artifacts (Files/Deliverables)
  ├── artifact_id
  ├── session_id → Sessions
  ├── phase_id → Phases
  ├── created_at
  ├── artifact_type (research, draft, final, intermediate)
  ├── file_path
  ├── content_hash (for dedup/change tracking)
  ├── size_bytes
  ├── metadata (JSON) - can include word_count, etc.

Issues (Quality Problems)
  ├── issue_id
  ├── session_id → Sessions
  ├── phase_id → Phases
  ├── created_at
  ├── severity (critical, major, minor)
  ├── issue_type
  ├── description
  ├── location (where in artifact)
  ├── fixed (boolean)
  ├── fix_iteration (which review pass)
  └── metadata (JSON)

Metrics (Custom Measurements)
  ├── metric_id
  ├── session_id → Sessions
  ├── phase_id → Phases (optional)
  ├── metric_name
  ├── metric_value (numeric or JSON)
  ├── recorded_at
  └── metadata (JSON)
```

### Extensibility via JSON

Each table has a `metadata` JSON field for workflow-specific data:

**Blog Post Example:**

```json
// Session metadata
{
  "mode": "from_scratch",
  "topic": "CPU Scheduling",
  "category": "infra",
  "series_name": "Physical Virtual Foundations",
  "tags": [
    "cpu",
    "scheduling",
    "performance"
  ]
}

// Artifact metadata
{
  "word_count": 1234,
  "reading_time_minutes": 5,
  "has_code_blocks": true,
  "has_diagrams": true
}

// Issue metadata
{
  "line_number": 42,
  "matched_pattern": "incredibly|remarkably|highly",
  "suggested_fix": "Remove intensifier"
}
```

---

## Core Features (V1)

### 1. Workflow Registration

```bash
# Register a workflow type
tracker workflow register \
  --name blog-post \
  --version 1.0 \
  --schema blog-post-schema.json

# List workflows
tracker workflow list
```

### 2. Session Management

```bash
# Start session (returns SESSION_ID)
tracker session start \
  --workflow blog-post \
  --input '{"topic": "CPU Scheduling", "mode": "from_scratch"}'

# Complete session
tracker session complete \
  --session 123 \
  --status published \
  --output '{"path": "_posts/2026-01-04-cpu.md", "word_count": 1234}'

# Fail session
tracker session fail \
  --session 123 \
  --error "Research quality check failed"
```

### 3. Logging Operations

```bash
# Log phase
tracker phase start --session 123 --name research
tracker phase complete --session 123 --name research

# Log prompt
tracker prompt log \
  --session 123 \
  --phase research \
  --prompt "$(cat research_prompt.txt)" \
  --model sonnet \
  --temperature 0.7

# Log response (returns RESPONSE_ID)
tracker response log \
  --prompt 456 \
  --response "$(cat research_output.txt)" \
  --tokens-in 1000 \
  --tokens-out 5000 \
  --latency 12500

# Log action
tracker action log \
  --session 123 \
  --type write \
  --command "Write file: _research/infra/05-cpu.md"

# Log artifact
tracker artifact log \
  --session 123 \
  --type research \
  --path "_research/infra/05-cpu.md" \
  --metadata '{"word_count": 3500}'

# Log issue
tracker issue log \
  --session 123 \
  --severity minor \
  --type ai_intensifier \
  --description "Found 'incredibly' on line 42"
```

### 4. Querying & Analysis

```bash
# List recent sessions
tracker session list --limit 10

# Show session details
tracker session show --session 123

# Show session timeline
tracker session timeline --session 123

# Search sessions
tracker session search --workflow blog-post --status published --after 2026-01-01

# Export session
tracker session export --session 123 --format json > session-123.json

# Analytics
tracker stats --workflow blog-post --group-by status
tracker stats --workflow blog-post --metric tokens_total --aggregate sum

# Cost tracking
tracker cost --workflow blog-post --after 2026-01-01

# Prompt library
tracker prompts --phase research --min-rating 4
```

### 5. Comparison & Diffing

```bash
# Compare two sessions
tracker compare --sessions 123,124

# Show what changed between iterations
tracker diff --session 123 --phase draft --iterations 1,2
```

---

## Integration Points

### 1. Claude Code Skills

Skills can log via simple Python calls:

```python
# In skill execution
import sys
sys.path.append('.claude/skills/blog-post')
from tracker import Tracker

tracker = Tracker()
session_id = tracker.start_session(
    workflow='blog-post',
    inputs={'topic': topic, 'mode': mode}
)

# Log each operation
tracker.log_prompt(session_id, phase='research', prompt=prompt_text)
tracker.log_artifact(session_id, type='research', path=research_path)
```

### 2. Environment Variables

```bash
# Skills can use env vars for session context
export AI_TRACKER_SESSION_ID=123
export AI_TRACKER_WORKFLOW=blog-post
export AI_TRACKER_PHASE=draft

# Then commands can auto-attach to current session
tracker prompt log --prompt "..." # Uses $AI_TRACKER_SESSION_ID
```

### 3. Wrapper Scripts

```bash
# Wrap bash commands to auto-log
tracked-bash "ls _research/"  # Logs command + output

# Wrap file operations
tracked-write "_posts/post.md" < content.txt  # Logs as artifact
```

### 4. API/SDK

```python
from ai_tracker import Tracker

tracker = Tracker()

with tracker.session(workflow='blog-post', inputs={...}) as session:
    with session.phase('research'):
        prompt_id = session.log_prompt(text=prompt, model='sonnet')
        response = call_ai(prompt)
        session.log_response(prompt_id, text=response, tokens=...)

    with session.phase('draft'):
        draft = generate_draft()
        session.log_artifact(type='draft', path=draft_path)
```

---

## Use Cases

### 1. Blog Post Generation (Current)

**Workflow**: Research → Draft → Review → Publish

**Tracking**:

- Prompts used at each phase
- Commands run (grep, file reads)
- Artifacts created (research doc, drafts)
- Issues found and fixed
- Final metrics (word count, review iterations)

**Value**:

- See which research prompts yield better blog posts
- Track improvement in quality over time
- Understand cost per blog post
- Debug when quality drops

### 2. Code Refactoring

**Workflow**: Analyze → Plan → Refactor → Test → Review

**Tracking**:

- Code analysis prompts
- Refactoring strategies considered
- Files modified
- Test results
- Review comments

**Value**:

- Compare refactoring approaches
- Measure test success rates
- Track time/cost per refactor

### 3. Research Synthesis

**Workflow**: Search → Read → Analyze → Synthesize → Write

**Tracking**:

- Search queries
- Documents read
- Analysis prompts
- Synthesis attempts
- Final report

**Value**:

- Understand which sources were most valuable
- Track research efficiency
- Reuse analysis patterns

### 4. Data Analysis

**Workflow**: Load → Clean → Analyze → Visualize → Report

**Tracking**:

- Data sources
- Cleaning operations
- Analysis prompts
- Charts generated
- Insights extracted

**Value**:

- Audit analysis decisions
- Reproduce analyses
- Compare analytical approaches

---

## Technical Implementation

### Phase 1: Core Infrastructure (Week 1-2)

1. **Schema Design & Migration System**
    - Finalize core schema
    - Build migration system
    - Add schema versioning

2. **CLI Framework**
    - Argument parsing
    - Command routing
    - Error handling

3. **Core Operations**
    - Session CRUD
    - Prompt/Response logging
    - Action logging
    - Artifact logging

4. **Basic Queries**
    - List sessions
    - Show session details
    - Search by date/status

### Phase 2: Blog Post Integration (Week 3)

1. **Workflow Schema**
    - Define blog-post workflow schema
    - Create migration

2. **SKILL.md Integration**
    - Add logging instructions
    - Create helper functions
    - Add environment variable support

3. **Testing**
    - Run full blog-post workflow
    - Verify all data captured
    - Iterate on UX

### Phase 3: Analytics & Reporting (Week 4)

1. **Cost Tracking**
    - Token → cost conversion
    - Aggregate costs by workflow/date
    - Cost per artifact

2. **Quality Metrics**
    - Issue statistics
    - Review iteration tracking
    - Quality trends

3. **Export & Visualization**
    - JSON/CSV export
    - Timeline visualization (ASCII art)
    - Simple charts

### Phase 4: Web UI (Week 5-6)

1. **Backend API**
    - REST API over SQLite
    - Session browsing
    - Search and filter

2. **Frontend**
    - Session list view
    - Session detail view
    - Timeline visualization
    - Prompt/response viewer

3. **Advanced Features**
    - Side-by-side comparison
    - Prompt library
    - Favorite prompts

---

## Success Metrics

### Adoption

- Number of workflows registered
- Number of sessions tracked
- Active users (for multi-user version)

### Value Delivered

- Time saved debugging AI workflows
- Cost reduction through prompt optimization
- Quality improvement (tracked via issues reduced)

### Engagement

- Sessions queried per week
- Export usage
- Prompt library usage

---

## Future Directions

### Advanced Analytics

- Prompt similarity clustering
- Quality prediction models
- Anomaly detection (when outputs degrade)
- A/B test framework for prompts

### Collaboration Features

- Prompt sharing
- Team workflows
- Review and approval flows
- Prompt marketplace

### Integrations

- LangChain/LlamaIndex integration
- Weights & Biases export
- LangSmith compatibility
- GitHub Actions integration

### Scale

- PostgreSQL backend option
- Cloud deployment
- Multi-tenant SaaS
- Real-time monitoring

### AI-Powered Features

- Prompt optimization suggestions
- Auto-categorization of sessions
- Quality issue auto-detection
- Workflow optimization recommendations

---

## Open Questions

1. **Prompt Storage**: Full text vs embeddings vs both?
2. **Retention**: How long to keep session data? Auto-cleanup?
3. **Privacy**: How to handle sensitive data in prompts?
4. **Sharing**: How to share workflows without exposing proprietary prompts?
5. **Versioning**: How to handle workflow schema evolution?
6. **Multi-model**: How to handle workflows using multiple AI models?
7. **Costs**: Token counting for non-OpenAI models?
8. **Scale**: When to move beyond SQLite?

---

## Next Steps

1. **Review & Refine**: Get feedback on this PRD
2. **Prioritize**: Decide which features are MVP
3. **Spike**: Build minimal schema + CLI proof of concept
4. **Integrate**: Add to blog-post skill and validate
5. **Iterate**: Based on real usage, refine and expand
6. **Document**: Write usage guide and best practices
7. **Open Source**: Consider releasing as OSS tool

---

## Appendix: Example Queries

### Find highest cost sessions

```sql
SELECT s.session_id, s.workflow_id, SUM(r.cost_usd) as total_cost
FROM sessions s
         JOIN phases p ON s.session_id = p.session_id
         JOIN prompts pr ON p.phase_id = pr.phase_id
         JOIN responses r ON pr.prompt_id = r.prompt_id
GROUP BY s.session_id
ORDER BY total_cost DESC LIMIT 10;
```

### Find best performing prompts

```sql
-- Prompts that led to sessions with fewest issues
SELECT pr.prompt_text,
       COUNT(DISTINCT s.session_id)  as usage_count,
       AVG(issue_counts.issue_count) as avg_issues
FROM prompts pr
         JOIN phases ph ON pr.phase_id = ph.phase_id
         JOIN sessions s ON ph.session_id = s.session_id
         LEFT JOIN (SELECT session_id, COUNT(*) as issue_count
                    FROM issues
                    GROUP BY session_id) issue_counts ON s.session_id = issue_counts.session_id
WHERE pr.phase_name = 'draft'
GROUP BY pr.prompt_text
HAVING usage_count >= 3
ORDER BY avg_issues ASC;
```

### Track quality improvement over time

```sql
SELECT DATE (s.started_at) as date, COUNT (DISTINCT s.session_id) as sessions, AVG (s.json_extract(outputs, '$.word_count')) as avg_words, AVG (issue_counts.issue_count) as avg_issues
FROM sessions s
    LEFT JOIN (
    SELECT session_id, COUNT (*) as issue_count
    FROM issues
    WHERE severity IN ('critical', 'major')
    GROUP BY session_id
    ) issue_counts
ON s.session_id = issue_counts.session_id
WHERE s.workflow_id = 'blog-post' AND s.status = 'published'
GROUP BY DATE (s.started_at)
ORDER BY date DESC;
```
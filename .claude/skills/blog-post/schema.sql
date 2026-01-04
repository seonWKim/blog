-- Blog Post Generation Tracking Database
-- Tracks all blog-post skill executions for audit and improvement

-- Main session tracking
CREATE TABLE IF NOT EXISTS sessions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    started_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,
    mode TEXT NOT NULL CHECK(mode IN ('from_scratch', 'from_research')),
    topic TEXT NOT NULL,
    category TEXT,
    series_name TEXT,
    research_path TEXT,
    output_path TEXT,
    status TEXT CHECK(status IN ('started', 'research_complete', 'draft_complete', 'review_complete', 'published', 'failed')),
    word_count INTEGER,
    error_message TEXT,
    metadata JSON -- Store arbitrary metadata as JSON
);

-- Track prompts sent to AI during session
CREATE TABLE IF NOT EXISTS prompts (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    session_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    phase TEXT NOT NULL CHECK(phase IN ('research', 'draft', 'style_review', 'revision')),
    prompt_text TEXT NOT NULL,
    context TEXT, -- Optional context about why this prompt was sent
    FOREIGN KEY (session_id) REFERENCES sessions(id) ON DELETE CASCADE
);

-- Track AI responses
CREATE TABLE IF NOT EXISTS responses (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    prompt_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    response_text TEXT NOT NULL,
    tokens_used INTEGER,
    model TEXT, -- e.g., 'sonnet', 'haiku'
    FOREIGN KEY (prompt_id) REFERENCES prompts(id) ON DELETE CASCADE
);

-- Track commands executed during session
CREATE TABLE IF NOT EXISTS commands (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    session_id INTEGER NOT NULL,
    executed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    command_type TEXT NOT NULL CHECK(command_type IN ('bash', 'read', 'write', 'edit', 'grep', 'glob')),
    command_text TEXT NOT NULL,
    exit_code INTEGER,
    output_preview TEXT, -- First 500 chars of output
    FOREIGN KEY (session_id) REFERENCES sessions(id) ON DELETE CASCADE
);

-- Track files created/modified
CREATE TABLE IF NOT EXISTS artifacts (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    session_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    artifact_type TEXT NOT NULL CHECK(artifact_type IN ('research', 'draft', 'final_post')),
    file_path TEXT NOT NULL,
    word_count INTEGER,
    FOREIGN KEY (session_id) REFERENCES sessions(id) ON DELETE CASCADE
);

-- Track style review issues found
CREATE TABLE IF NOT EXISTS style_issues (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    session_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    iteration INTEGER NOT NULL DEFAULT 1, -- Which review iteration (1st, 2nd)
    severity TEXT CHECK(severity IN ('critical', 'major', 'minor')),
    issue_type TEXT NOT NULL, -- e.g., 'missing_citation', 'ai_intensifier', 'wrong_voice'
    description TEXT NOT NULL,
    location TEXT, -- Where in the document
    fixed BOOLEAN DEFAULT 0,
    FOREIGN KEY (session_id) REFERENCES sessions(id) ON DELETE CASCADE
);

-- Indexes for common queries
CREATE INDEX IF NOT EXISTS idx_sessions_started_at ON sessions(started_at);
CREATE INDEX IF NOT EXISTS idx_sessions_mode ON sessions(mode);
CREATE INDEX IF NOT EXISTS idx_prompts_session ON prompts(session_id);
CREATE INDEX IF NOT EXISTS idx_commands_session ON commands(session_id);
CREATE INDEX IF NOT EXISTS idx_artifacts_session ON artifacts(session_id);
CREATE INDEX IF NOT EXISTS idx_style_issues_session ON style_issues(session_id);

-- Useful views

-- Session summary view
CREATE VIEW IF NOT EXISTS session_summary AS
SELECT
    s.id,
    s.started_at,
    s.completed_at,
    s.mode,
    s.topic,
    s.category,
    s.series_name,
    s.status,
    s.word_count,
    COUNT(DISTINCT p.id) as prompt_count,
    COUNT(DISTINCT c.id) as command_count,
    COUNT(DISTINCT a.id) as artifact_count,
    COUNT(DISTINCT si.id) as issue_count
FROM sessions s
LEFT JOIN prompts p ON s.id = p.session_id
LEFT JOIN commands c ON s.id = c.session_id
LEFT JOIN artifacts a ON s.id = a.session_id
LEFT JOIN style_issues si ON s.id = si.session_id
GROUP BY s.id;

-- Recent sessions view (last 10)
CREATE VIEW IF NOT EXISTS recent_sessions AS
SELECT * FROM session_summary
ORDER BY started_at DESC
LIMIT 10;
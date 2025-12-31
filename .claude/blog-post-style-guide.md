# Blog Post Style Guide

This document defines the tone, structure, and style conventions for blog posts in this repository. It serves as a
reference for maintaining consistency while allowing room for evolution as new posts are added.

**Last Updated:** 2025-12-31
**Base Analysis:** Posts analyzed include NUMA (2025-12-28), Queues in VM (2025-12-29)

---

## Core Philosophy

Posts are written from a **personal learning journey** perspective - documenting technical concepts as they are
discovered and understood. The goal is to make complex technical topics accessible to fellow software engineers who are
expanding their knowledge beyond application-level code.

**Key Principles:**

- Share the learning process, not just the end result
- Bridge the gap between software engineering and infrastructure/hardware/ai/programming
- Be conversational without sacrificing technical accuracy
- Provide practical, actionable takeaways

---

## Voice & Tone

### Voice Characteristics

- **First-person perspective:** Use "I", "we", "us" to create connection
- **Conversational:** Write as if explaining to a colleague over coffee
- **Humble learner:** Acknowledge gaps in knowledge ("I found myself unfamiliar...")
- **Inclusive:** "For software engineers like us..."
- **Curious:** Frame topics as questions worth exploring

### Tone Examples

**Good:**

```
As a software engineer, I often forget the importance of getting used to the hardware
systems that software runs on. As I'm diving into the hardware world, I found myself
unfamiliar with hardware-related terms...
```

**Avoid:**

```
This article comprehensively covers NUMA architecture. NUMA is an essential topic
that all engineers must understand...
```

### Question-Driven Sections

Use questions as section headers to engage readers:

- "Wait, CPU = NUMA Node?"
- "Why should software engineers care?"
- "How does this affect performance?"

---

## Post Structure

### 1. Front Matter

```yaml
---
title: "Series Name - Specific Topic"  # Or standalone topic
date: YYYY-MM-DD HH:MM:SS -ZONE        # Should not use the future date 
categories: category-name              # Usually single category
tags: [ tag1, tag2, tag3 ]              # 3-6 relevant tags
---
```

**Title Conventions:**

- Series posts: "Series Name - Specific Topic" (e.g., "Physical Virtual Foundations - NUMA")
- Standalone: Direct topic name
- Descriptive and searchable

**Categories:** Simple, broad classification (e.g., "infra", "systems", "backend")

**Tags:** Specific technical terms covered in the post

### 2. Opening Paragraph (1-3 sentences)

**Purpose:** Set personal context and motivation

**Pattern:**

1. State the broader context or challenge
2. Share personal discovery or learning journey
3. Preview what the post will cover

**Example:**

```
As a software engineer, I often forget the importance of getting used to the hardware
systems that software runs on. As I'm diving into the hardware world, I found myself
unfamiliar with hardware-related terms, so I would like to start by defining these
unfamiliar hardware terms. For today, I would like to start with NUMA architecture.
```

### 3. Main Topic Definition (## Heading)

- Start with the core concept being explained
- Provide a clear, concise definition
- Expand with context and rationale ("This was introduced to solve...")

### 4. Why It Matters Section (### Subheading)

**Critical:** Always include "Why should software engineers care?" or equivalent

- Connect theory to practice
- Provide concrete performance implications with numbers
- List practical considerations (bullet points)
- Target audience: software engineers moving into infra/systems

### 5. Deep Dive Sections (### Subheadings)

- Break down complex concepts into digestible chunks
- Use question-based subheadings when appropriate
- Progress from simple to complex

### 6. Examples & Visuals

**Code Blocks:**

```bash
# Real command outputs, not hypotheticals
$ numactl --hardware
available: 2 nodes (0-1)
...
```

**ASCII Diagrams:**

- Use for hierarchies, architectures, and relationships
- Keep them clean and readable
- Include arrows (→, ↓, ↕) for flow

**Example:**

```
Server
├── NUMA Node 0 (Socket 0)
│   ├── Core 0 (CPU 0)
│   │   ├── Thread 0
│   │   └── Thread 1
```

### 7. Final Thoughts (Optional but Recommended)

- Synthesize key learnings
- Connect concepts to real-world scenarios
- Pose thought-provoking questions or implications

---

## Content Style Guidelines

### Technical Accuracy with Accessibility

- Define technical terms on first use
- Provide concrete numbers and measurements (2-10x faster, 100ns latency)
- Use real-world examples from actual systems
- Balance theory with practice

### Hierarchy & Relationships

When explaining systems, show the hierarchy:

- Use tree structures
- Clarify relationships (Node = Socket ≠ Core)
- Provide visual and textual explanations

### Actionable Takeaways

Include practical advice in bullet form:

- "Pin threads to specific NUMA nodes for consistent performance"
- "Use NUMA-aware allocators like `tcmalloc` or `jemalloc`"

### Short Answer Pattern

For clarifying questions:

```
Question: Wait, CPU = NUMA Node?
Short answer: **No**.

[Detailed explanation follows...]
```

---

## Formatting Conventions

### Headings

- `##` for main sections (topic introduction)
- `###` for subsections
- `####` for detailed breakdowns (use sparingly)

### Emphasis

- **Bold** for short answers, key terms, and emphasis
- `Code formatting` for commands, filenames, technical terms
- *Italics* (use sparingly)

### Lists

- **Bullet points** for related items, considerations, features
- **Numbered lists** for sequential steps or processes
- Keep items parallel in structure

### Code Blocks

- Always specify language for syntax highlighting
- Include actual command outputs, not placeholders
- Add comments for clarity when needed
- Show both commands and their results

### Visual Elements

- ASCII diagrams for architecture and hierarchy
- Tree structures for showing relationships
- Tables for comparisons (when needed)

---

## Common Patterns

### Bridging Software and Hardware

Posts often explore the boundary between software abstractions and underlying hardware:

- Start with software engineer's perspective
- Reveal the hardware layer underneath
- Explain why understanding this matters for performance

### Performance Context

When discussing performance:

- Provide concrete numbers (2-10x, 100ns vs 200ns)
- Explain the practical impact
- Give optimization guidelines

### Terminology Clarification

If terms are confusing, dedicate a section to clarify:

- Use clear headings ("Wait, X = Y?")
- Provide hierarchical explanations
- Use both visual and textual explanations

---

## Checklist for New Posts

Before publishing, verify:

- [ ] Front matter is complete and properly formatted
- [ ] Opening paragraph provides personal context and motivation
- [ ] Main concept is clearly defined early
- [ ] "Why should software engineers care?" is addressed
- [ ] Technical terms are defined on first use
- [ ] Examples use real commands/outputs (not hypotheticals)
- [ ] Visuals (diagrams, code blocks) are clean and readable
- [ ] Actionable takeaways are provided
- [ ] Tone is conversational and first-person
- [ ] Structure flows logically from simple to complex
- [ ] Final thoughts tie concepts together (if applicable)

---

## Evolution Guidelines

This style guide should evolve as the blog grows. When adding new posts that introduce new patterns or improvements:

1. **Document the pattern:** Note what works well in new posts
2. **Update this guide:** Add new sections or refine existing ones
3. **Mark the update:** Update "Last Updated" date and note the post that prompted the change
4. **Preserve core philosophy:** Ensure new patterns align with the personal learning journey approach

### When to Update This Guide

- A new post introduces a successful structural pattern
- Reader feedback suggests improvements
- A series develops its own sub-conventions
- Technical depth or audience shifts noticeably
- New visual or formatting patterns emerge

### Change Log

Track significant updates here:

- **2025-12-31:** Initial style guide created based on NUMA and Queues posts
- _(Future updates will be logged here)_

---

## Notes for Claude

When helping create or edit blog posts:

1. **Prioritize reading existing posts** in the `_posts/` directory to understand current patterns
2. **Match the established voice** - conversational, first-person, learning-focused
3. **Suggest improvements** to this guide when you notice patterns that could be documented
4. **Flag inconsistencies** if a requested change would deviate significantly from this guide
5. **Ask clarifying questions** about audience or depth when scope is unclear
6. **Preserve the author's authentic voice** - don't over-formalize or make it too polished

This guide is meant to maintain consistency, not to constrain creativity. When in doubt, refer to recent posts in the
`_posts/` directory as the source of truth.

# Blog Content Style Guide

This guide defines the tone, terminology, and style conventions for blog content. Use this as a reference when creating or reviewing new posts to ensure consistency across all content.

## Voice and Tone

### Overall Voice
- **Technical but accessible**: Explain complex concepts clearly without oversimplifying
- **First-person perspective**: Use "I" for personal experiences and learning journeys
- **Direct and practical**: Focus on actionable insights and real-world applications
- **Honest about learning**: Acknowledge gaps in knowledge and learning process

### Tone Guidelines
- **Conversational yet professional**: Balance technical accuracy with readability
- **Avoid excessive casualness**: Minimize phrases like "seems interesting" or repeated emojis
- **Maintain consistency**: Don't switch between overly casual and formal within the same post
- **Be inclusive**: Use "we" and "us" when referring to software engineers as a community

### Examples
✅ Good: "As a software engineer, I often encounter hardware concepts that require deeper understanding."
❌ Avoid: "NUMA, NUMA, NUMA.. I've heard of this term so many times."

✅ Good: "This approach proves valuable for performance-critical applications."
❌ Avoid: "seems interesting. Let's do some research on databases in the future 😮😮"

## Terminology Standards

### Technical Terms
- **First use**: Define abbreviations and technical terms on first mention
  - Format: `NUMA (Non-Uniform Memory Access)`
  - Exception: Common terms like CPU, RAM, API don't need expansion
  
### Preferred Terminology
- Use `vCPU` not "virtual CPU" or "vcpu"
- Use `NUMA` not "numa" (except in code/commands)
- Use `I/O` not "IO" or "io" (except in code)
- Use `bare metal` not "baremetal" or "bare-metal"
- Use `hypervisor` consistently, not mixed with "virtualization layer"

### Capitalization
- Technical acronyms: ALL CAPS (NUMA, CPU, RAM, PCIe, NVMe)
- Product names: Follow official capitalization (Jekyll, GitHub, Kubernetes)
- Commands and tools: lowercase in running text (`numactl`, `tcmalloc`)

## Content Structure

### Front Matter (Required)
```yaml
---
title: "Your Post Title"
date: YYYY-MM-DD HH:MM:SS -0500
categories: [single category]
tags: [tag1, tag2, tag3]
---
```

### Post Structure
1. **Opening paragraph**: Introduce the topic and why it matters
2. **Context/Problem**: Explain the problem or concept being addressed
3. **Main content**: Break into clear sections with descriptive headers
4. **Practical application**: Include real-world examples or use cases
5. **Key takeaways**: Summarize important points (optional but recommended)

### Headers
- Use descriptive, action-oriented headers
- Maintain consistent hierarchy (H2 for main sections, H3 for subsections)
- Don't skip header levels (H2 → H4)
- Use sentence case, not title case

✅ Good: `## Why should software engineers care?`
❌ Avoid: `## Why Should Software Engineers Care?` (title case)

## Formatting Conventions

### Code Blocks
- Always specify language for syntax highlighting
- Use inline code for commands, variables, and short snippets
- Use code blocks for examples longer than one line

```markdown
Inline: Use `numactl --hardware` to check NUMA topology.

Block:
\`\`\`bash
$ numactl --hardware
available: 2 nodes (0-1)
\`\`\`
```

### Lists
- Use bullet points for unordered information
- Use numbered lists only for sequential steps or ranked items
- Keep list items parallel in structure
- End list items with periods only if they are complete sentences

### Emphasis
- **Bold** for key concepts and important terms
- *Italic* for emphasis within sentences (use sparingly)
- Use inline code backticks for technical terms in context
- Avoid ALL CAPS for emphasis (except in code/commands)

### Examples and Diagrams
- Use ASCII diagrams for hierarchies and structures
- Add comments/arrows for clarity (using `←` or `#`)
- Keep diagrams simple and focused
- Always introduce diagrams with context

### Tables
- Use tables for comparisons and structured data
- Keep tables simple (avoid nested content)
- Include header row
- Align content appropriately (left for text, right for numbers)

## Writing Style

### Sentence Structure
- Vary sentence length for readability
- Keep sentences focused on one main idea
- Use active voice when possible
- Break complex ideas into multiple sentences

### Paragraphs
- One main idea per paragraph
- Keep paragraphs to 3-5 sentences when possible
- Use paragraph breaks to improve scannability
- Start with topic sentence when appropriate

### Technical Explanations
- Start with high-level concept, then dive into details
- Use analogies sparingly and ensure they're accurate
- Provide concrete examples alongside abstract concepts
- Include quantitative data when relevant (latency numbers, performance metrics)

### Humor and Personality
- Light humor is acceptable but don't force it
- Avoid self-deprecating jokes about knowledge gaps
- Emoji usage: Maximum one emoji per concept, avoid repetition (not 😮😮)
- Keep focus on technical content, not entertainment

## Content Categories

### Blog Posts (`_posts/`)
- Personal learning experiences and insights
- Tutorial-style content with practical examples
- Technical deep-dives into specific topics
- Should feel like a journey or exploration

### Research Notes (`_research/`)
- Comprehensive operational guides
- Structured reference material
- Less personal, more instructional
- Can be more formal and systematic

## Common Pitfalls to Avoid

1. **Inconsistent tone**: Switching between casual and formal within a post
2. **Undefined acronyms**: Using technical terms without explanation
3. **Vague qualifiers**: "seems", "maybe", "probably" without context
4. **Excessive exclamation**: Multiple exclamation marks or emojis
5. **Mixed terminology**: Using different terms for the same concept
6. **Poor code formatting**: Missing language tags or inconsistent indentation
7. **Oversized sections**: Breaking down large sections into subsections

## Review Checklist

Before publishing, verify:
- [ ] All technical terms defined on first use
- [ ] Consistent voice throughout (first-person for personal, instructional for guides)
- [ ] Code blocks have language tags
- [ ] Headers follow logical hierarchy
- [ ] No excessive emoji or casual phrases
- [ ] Terminology matches this guide
- [ ] Front matter is complete and correct
- [ ] Content provides actionable value
- [ ] Examples are clear and relevant

## When to Reference This Guide

**AI PR reviews should reference this guide when:**
- Detecting inconsistent tone or terminology
- Identifying formatting issues
- Noting structural problems
- Finding undefined technical terms

**This guide is not needed for:**
- Minor typos or spelling corrections
- Content accuracy reviews
- Technical correctness validation
- Domain-specific knowledge questions

## Manual Style Checking

You can use linting tools locally to check blog posts for style guide compliance.

### Running markdownlint locally:
```bash
# Install markdownlint-cli
npm install -g markdownlint-cli

# Check specific file
markdownlint _posts/your-post.md

# Check all blog posts
markdownlint _posts/

# Check pages
markdownlint _pages/
```

**Note**: The `.markdownlint.json` configuration file defines the linting rules used for validation.

---

**Note**: This guide should evolve with the blog. If you notice patterns that work well or areas needing clarification, update this document to reflect those learnings.

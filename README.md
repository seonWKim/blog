# blog

Technical blog built with Jekyll and the So Simple theme.

## Features

- **GitHub Discussions Comments**: Powered by Giscus for interactive discussions on blog posts
- Responsive design with light/dark mode support
- Category and tag organization
- SEO optimized

## Setting Up GitHub Comments (Giscus)

This blog uses [Giscus](https://giscus.app) to enable GitHub Discussions-based comments on blog posts. To activate comments:

### 1. Enable GitHub Discussions

- Go to your repository settings: https://github.com/seonWKim/blog/settings
- Scroll down to the "Features" section
- Check the box next to "Discussions"

### 2. Configure Giscus

- Visit https://giscus.app
- Enter your repository: `seonWKim/blog`
- Select a discussion category (create one if needed, e.g., "Blog Comments" or use "General")
- Choose mapping: `pathname` (recommended - maps comments to page URLs)
- Copy the generated configuration values

### 3. Update _config.yml

Replace the placeholder values in `_config.yml` with your Giscus configuration:

```yaml
giscus:
  repo: "seonWKim/blog"
  repo_id: "YOUR_REPO_ID"  # Get from giscus.app
  category: "General"       # Your discussion category
  category_id: "YOUR_CATEGORY_ID"  # Get from giscus.app
  mapping: "pathname"
  reactions_enabled: "1"
  input_position: "bottom"
  theme: "preferred_color_scheme"
  lang: "en"
```

### 4. Rebuild and Deploy

```bash
bundle exec jekyll build
```

Comments will automatically appear at the bottom of all blog posts that have `comments: true` in their front matter (enabled by default for all posts).

## Local Development

```bash
# Install dependencies
bundle install

# Serve locally
bundle exec jekyll serve

# Build for production
bundle exec jekyll build
```

## Creating Posts

Create a new file in `_posts/` with the format: `YYYY-MM-DD-title.md`

```yaml
---
title: "Your Post Title"
date: 2025-12-25
categories: kubernetes
tags: [k8s, deployment]
comments: true  # Enable comments (default)
---

Your content here...
```


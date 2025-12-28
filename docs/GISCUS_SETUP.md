# Giscus Setup Guide

This guide walks you through enabling GitHub Discussions-based comments on your blog using Giscus.

## Prerequisites

- GitHub repository must be public
- Admin access to the repository

## Step-by-Step Setup

### 1. Enable GitHub Discussions

1. Go to your repository: https://github.com/seonWKim/blog
2. Click on **Settings** (gear icon)
3. Scroll down to the **Features** section
4. Check the box next to **Discussions** to enable it
5. Click **Set up Discussions** if prompted

### 2. Create a Discussion Category (Optional but Recommended)

1. Go to the **Discussions** tab in your repository
2. Click on the **Categories** section
3. Create a new category named "Blog Comments" or similar
4. Choose format: **Announcement** (only you can create new discussions, users can comment)

### 3. Install Giscus App

1. Visit https://giscus.app
2. In the "Configuration" section, enter:
   - Repository: `seonWKim/blog`
3. Scroll down and click the link to install the Giscus app on GitHub
4. Follow the prompts to authorize Giscus for your repository

### 4. Get Configuration Values

Back on https://giscus.app:

1. **Repository**: `seonWKim/blog` (already filled)
2. **Page ↔️ Discussions Mapping**: Select **pathname** (recommended)
3. **Discussion Category**: Choose the category you created (or "General")
4. **Features**: Keep default settings (reactions enabled, etc.)
5. **Theme**: Select **preferred_color_scheme** for automatic light/dark mode

Scroll down to see the generated configuration. You'll see something like:

```html
<script src="https://giscus.app/client.js"
        data-repo="seonWKim/blog"
        data-repo-id="R_xxxxxxxxxxxxx"
        data-category="Blog Comments"
        data-category-id="DIC_xxxxxxxxxxxx"
        ...>
</script>
```

Copy the `data-repo-id` and `data-category-id` values.

### 5. Update _config.yml

Edit `_config.yml` and update the giscus section:

```yaml
giscus:
  repo: "seonWKim/blog"
  repo_id: "R_xxxxxxxxxxxxx"  # Paste the value from giscus.app
  category: "Blog Comments"     # Or your chosen category name
  category_id: "DIC_xxxxxxxxxxxx"  # Paste the value from giscus.app
  mapping: "pathname"
  reactions_enabled: "1"
  input_position: "bottom"
  theme: "preferred_color_scheme"
  lang: "en"
```

### 6. Test Locally (Optional)

```bash
# Rebuild the site
bundle exec jekyll build

# Serve locally
bundle exec jekyll serve

# Visit http://localhost:4000/blog/ to test
```

### 7. Deploy

Commit and push your changes:

```bash
git add _config.yml
git commit -m "Configure Giscus for blog comments"
git push
```

GitHub Pages will automatically rebuild and deploy your site with comments enabled!

## How It Works

- When someone visits a blog post, the Giscus script loads
- If no discussion exists for that page, Giscus creates one in your repository's Discussions
- Comments are stored as discussion replies in GitHub Discussions
- Users need a GitHub account to comment
- You can moderate comments through GitHub Discussions interface

## Troubleshooting

### Comments don't appear

1. Check that `repo_id` and `category_id` are correctly set in `_config.yml`
2. Ensure GitHub Discussions are enabled in your repository
3. Verify the Giscus app is installed for your repository
4. Check browser console for any errors

### Wrong category or discussion

1. Update the `category` and `category_id` in `_config.yml`
2. You can manually move discussions between categories on GitHub

## Disabling Comments

To disable comments on a specific post, add to the post's front matter:

```yaml
---
title: "My Post"
comments: false  # Disable comments for this post
---
```

To disable comments globally, remove or comment out the `giscus` section in `_config.yml`.

## More Information

- Giscus documentation: https://giscus.app
- GitHub Discussions: https://docs.github.com/en/discussions

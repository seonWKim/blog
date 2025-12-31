.DEFAULT_GOAL := help

.PHONY: help
help:
	@echo "📚 Blog Post Management Commands"
	@echo ""
	@echo "  make review-post              - Review latest post against style guide"
	@echo "  make review-post POST=<path>  - Review specific post against style guide"
	@echo "  make review-style-guide       - Update style guide based on latest posts"
	@echo ""
	@echo "Examples:"
	@echo "  make review-post"
	@echo "  make review-post POST=_posts/2025-12-30-league-of-legends-servers.md"
	@echo ""

.PHONY: review-style-guide
review-style-guide:
	@echo "📝 Reviewing blog posts for style guide updates..."
	@echo ""
	@echo "Recent posts:"
	@ls -t _posts/*.md | head -3
	@echo ""
	@claude "Review the latest posts in _posts/ and update .claude/blog-post-style-guide.md if you notice new successful patterns or improvements that should be documented. Compare the latest posts against existing patterns in the style guide. Update the change log with your findings. Also periodically compact the doc so that ai context doesn't expand too much."

.PHONY: review-post
review-post:
	@if [ -z "$(POST)" ]; then \
		POST=$$(ls -t _posts/*.md | head -1); \
		echo "📖 Reviewing latest post: $$POST"; \
	else \
		echo "📖 Reviewing: $(POST)"; \
		POST="$(POST)"; \
	fi; \
	echo ""; \
	claude "Review $$POST against .claude/blog-post-style-guide.md. Check for: 1) Overloaded adjectives and AI-sounding language, 2) Concise opening (1-2 sentences), 3) Conversational first-person tone, 4) Question-driven sections where appropriate, 5) Technical accuracy with concrete examples. Provide specific suggestions for improvement if needed."

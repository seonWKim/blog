.PHONY: review-style-guide
review-style-guide:
	@echo "📝 Reviewing blog posts for style guide updates..."
	@echo ""
	@echo "Recent posts:"
	@ls -t _posts/*.md | head -3
	@echo ""
	@claude "Review the latest posts in _posts/ and update .claude/blog-post-style-guide.md if you notice new successful patterns or improvements that should be documented. Compare the latest posts against existing patterns in the style guide. Update the change log with your findings. Also periodically compact the doc so that ai context doesn't expand too much."

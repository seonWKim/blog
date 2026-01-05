.PHONY: sync sync-basics sync-workflow help

# Sync all: Update basics.md and workflow.md from til.md
sync: sync-basics sync-workflow
	@echo "✓ All documents synced with til.md"

# Update basics.md with learnings from til.md
sync-basics:
	@echo "Syncing til.md → basics.md..."
	@claude "Read til.md and basics.md in the current directory. Integrate new learnings from til.md into basics.md. Keep basics.md as a comprehensive knowledge foundation. Preserve existing structure and only add/update relevant sections. After updating basics.md, clear the contents of til.md (make it empty)."

# Update workflow.md with learnings from til.md
sync-workflow:
	@echo "Syncing basics.md → workflow.md..."
	@claude "Read basics.md and workflow.md in the current directory. Update the workflow checklist if til.md contains new decision criteria, tools, or process steps. Keep workflow.md concise and actionable. Reference basics.md for detailed concepts."

# Help
help:
	@echo "Valley AI Investment Workflow Commands:"
	@echo ""
	@echo "  make sync          - Sync til.md learnings to basics.md and workflow.md"
	@echo "  make sync-basics   - Update only basics.md from til.md"
	@echo "  make sync-workflow - Update only workflow.md from til.md"
	@echo ""
	@echo "Workflow:"
	@echo "  1. Add learnings to til.md throughout your research"
	@echo "  2. Run 'make sync' to integrate into documentation"
	@echo "  3. til.md gets cleared automatically after sync"
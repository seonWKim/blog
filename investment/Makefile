# Investment Analysis Makefile
#
# This Makefile automates investment analysis tasks including:
# 1. Macro report generation
# 2. Portfolio checklist analysis

.PHONY: help macro-report checklist all clean

# Variables
TODAY := $(shell date +%Y-%m-%d)
MACRO_SCRIPT := macro/MACRO_RESEARCH_SCRIPT.md
MACRO_REPORTS_DIR := macro/reports
TODAY_DIR := $(TODAY)
HISTORY_DIR := $(TODAY_DIR)/history
CHECKLIST_V2 := 2026-01-12/investment_checklist_v2.md

# Colors for output
GREEN := \033[0;32m
YELLOW := \033[0;33m
BLUE := \033[0;34m
NC := \033[0m # No Color

help:
	@echo "$(BLUE)Investment Analysis Makefile$(NC)"
	@echo ""
	@echo "$(GREEN)Available targets:$(NC)"
	@echo "  $(YELLOW)make macro-report$(NC)     - Generate macro economic report"
	@echo "  $(YELLOW)make checklist$(NC)         - Run investment portfolio checklist analysis"
	@echo "  $(YELLOW)make all$(NC)               - Run both macro report and checklist"
	@echo "  $(YELLOW)make setup$(NC)             - Create necessary directories"
	@echo "  $(YELLOW)make clean$(NC)             - Clean up temporary files"
	@echo ""
	@echo "$(GREEN)Examples:$(NC)"
	@echo "  make macro-report"
	@echo "  make checklist"
	@echo "  make all"

# Create necessary directory structure
setup:
	@echo "$(GREEN)Creating directory structure...$(NC)"
	@mkdir -p $(MACRO_REPORTS_DIR)
	@mkdir -p $(TODAY_DIR)/history
	@echo "$(GREEN)✓ Directories created$(NC)"

# Generate macro economic report
macro-report: setup
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo "$(GREEN)Generating Macro Economic Report for $(TODAY)$(NC)"
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo ""
	@echo "$(YELLOW)Instructions for Claude:$(NC)"
	@echo ""
	@echo "Please execute the macro research script and generate a comprehensive report."
	@echo ""
	@echo "Task: Execute $(MACRO_SCRIPT)"
	@echo "Output: $(MACRO_REPORTS_DIR)/REPORT_$(TODAY).md"
	@echo ""
	@echo "$(YELLOW)Full Prompt:$(NC)"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo ""
	@cat <<'EOF'
	Please execute the MACRO_RESEARCH_SCRIPT.md located in investment/macro/.

	Research the latest macroeconomic data (last 14-30 days) and generate a comprehensive
	REPORT_$(TODAY).md file in the investment/macro/reports/ directory.

	The report must be written entirely in Korean (한국어).

	Include:
	- 통화정책 및 금리 (Monetary Policy & Interest Rates)
	- 인플레이션 및 경제 성장 (Inflation & Economic Growth)
	- 통화 및 원자재 (Currency & Commodities)
	- 지정학 및 정책 리스크 (Geopolitical & Policy Risks)
	- 섹터별 거시경제 인사이트 (Sector-Specific Macro Insights for AEP, DUK, GEV, TER, FORM, DLR, GLD, SMR)
	- 시장 심리 및 포지셔닝 (Market Sentiment & Positioning)
	- 거시경제 트리거 및 경고 (Macro Triggers & Alerts)
	- 거시경제 기반 포트폴리오 권고사항 (Macro-Based Portfolio Recommendations)

	Use WebSearch and WebFetch tools to gather latest data from:
	- Federal Reserve, BLS, BEA, EIA
	- Bloomberg, Reuters, WSJ, FT
	- Trading Economics, FRED

	Cite all sources with dates.
	EOF
	@echo ""
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo ""
	@echo "$(GREEN)✓ Macro report prompt displayed. Please copy and paste to Claude.$(NC)"

# Run investment checklist analysis
checklist: setup
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo "$(GREEN)Running Investment Portfolio Checklist for $(TODAY)$(NC)"
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo ""
	@echo "$(YELLOW)Instructions for Claude:$(NC)"
	@echo ""
	@echo "Please execute the investment checklist analysis based on investment_checklist_v2.md"
	@echo ""
	@echo "Input Files:"
	@echo "  - Checklist: $(CHECKLIST_V2)"
	@echo "  - Previous Reports: 2026-01-12/history/*.md"
	@echo ""
	@echo "Output: $(TODAY_DIR)/history/REPORT_$(TODAY).md"
	@echo ""
	@echo "$(YELLOW)Full Prompt:$(NC)"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo ""
	@cat <<'EOF'
	Please execute the investment portfolio checklist analysis.

	Instructions:
	1. Read investment/2026-01-12/investment_checklist_v2.md
	2. Review previous reports in investment/2026-01-12/history/REPORT_*.md
	3. Research latest news and data for all holdings (AEP, DUK, GEV, TER, FORM, DLR, GLD, SMR)
	4. Analyze each stock's:
	   - Logic status (STRONGER/INTACT/WEAKENING/BROKEN)
	   - Valuation (Undervalued/Fair/Overvalued/EXPENSIVE)
	   - Expected Return (12-month probability-weighted)
	   - Portfolio recommendations

	Follow the comprehensive framework in investment_checklist_v2.md:
	- Section 0.0: Market-Level Assessment (S&P 500 valuation)
	- Section 0.1: Macro Regime Check (Fed, rates, ISM, VIX)
	- Section 0.2: Historical Review (compare with previous reports)
	- Section 1: Individual Stock Logic Status
	- Section 2: Logic + Valuation Check
	- Section 3-4: Action Guidelines and DCA Adjustments
	- Section 5: Position Sizing (Kelly Criterion)
	- Section 7: New Investment Ideas Discovery

	Use WebSearch extensively for:
	- Latest company news, earnings, guidance
	- Analyst ratings and price targets
	- Sector-specific news (utilities, semiconductors, data centers)
	- Macro indicators (CPI, PMI, jobs data)

	Generate a comprehensive report in Korean and save to:
	investment/$(TODAY_DIR)/history/REPORT_$(TODAY).md

	The report must include:
	- Executive summary
	- Market-level valuation assessment
	- Macro regime analysis
	- Stock-by-stock analysis table
	- Portfolio adjustment recommendations
	- DCA allocation table
	- Risk assessment
	- Sources with dates
	EOF
	@echo ""
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo ""
	@echo "$(GREEN)✓ Checklist prompt displayed. Please copy and paste to Claude.$(NC)"

# Run both analyses
all: macro-report checklist
	@echo ""
	@echo "$(GREEN)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo "$(GREEN)✓ Both tasks completed successfully$(NC)"
	@echo "$(GREEN)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo ""
	@echo "Generated files:"
	@echo "  1. $(MACRO_REPORTS_DIR)/REPORT_$(TODAY).md"
	@echo "  2. $(TODAY_DIR)/history/REPORT_$(TODAY).md"

# Quick reference
info:
	@echo "$(BLUE)Current Configuration:$(NC)"
	@echo "  Today: $(TODAY)"
	@echo "  Macro Script: $(MACRO_SCRIPT)"
	@echo "  Macro Reports: $(MACRO_REPORTS_DIR)"
	@echo "  Checklist: $(CHECKLIST_V2)"
	@echo "  Today's Dir: $(TODAY_DIR)"
	@echo "  History Dir: $(HISTORY_DIR)"

# Check if required files exist
check:
	@echo "$(YELLOW)Checking required files...$(NC)"
	@test -f $(MACRO_SCRIPT) && echo "$(GREEN)✓$(NC) $(MACRO_SCRIPT)" || echo "$(RED)✗$(NC) $(MACRO_SCRIPT) not found"
	@test -f $(CHECKLIST_V2) && echo "$(GREEN)✓$(NC) $(CHECKLIST_V2)" || echo "$(RED)✗$(NC) $(CHECKLIST_V2) not found"
	@test -d 2026-01-12/history && echo "$(GREEN)✓$(NC) History directory exists" || echo "$(YELLOW)⚠$(NC) History directory not found"

# Clean up temporary files (be careful!)
clean:
	@echo "$(YELLOW)This will remove generated temporary files.$(NC)"
	@echo "$(RED)WARNING: This will NOT delete report files.$(NC)"
	@echo ""
	@echo "Nothing to clean (reports are kept)."

# Create a quick start guide
guide:
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo "$(GREEN)Investment Analysis Quick Start Guide$(NC)"
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo ""
	@echo "$(YELLOW)1. Generate Macro Report$(NC)"
	@echo "   Command: make macro-report"
	@echo "   Purpose: Research macroeconomic conditions (Fed policy, inflation, currencies)"
	@echo "   Output:  investment/macro/reports/REPORT_YYYY-MM-DD.md"
	@echo ""
	@echo "$(YELLOW)2. Run Portfolio Checklist$(NC)"
	@echo "   Command: make checklist"
	@echo "   Purpose: Analyze each stock (logic, valuation, recommendations)"
	@echo "   Output:  investment/YYYY-MM-DD/history/REPORT_YYYY-MM-DD.md"
	@echo ""
	@echo "$(YELLOW)3. Run Both$(NC)"
	@echo "   Command: make all"
	@echo ""
	@echo "$(YELLOW)4. Check Status$(NC)"
	@echo "   Command: make check"
	@echo "   Purpose: Verify all required files exist"
	@echo ""
	@echo "$(GREEN)Workflow:$(NC)"
	@echo "  1. cd investment/"
	@echo "  2. make check           # Verify setup"
	@echo "  3. make macro-report    # Generate macro report (copy prompt to Claude)"
	@echo "  4. make checklist       # Generate portfolio report (copy prompt to Claude)"
	@echo ""
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"

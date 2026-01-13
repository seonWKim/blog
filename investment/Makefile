# Investment Analysis Makefile
#
# This Makefile automates investment analysis tasks including:
# 1. Macro report generation
# 2. Portfolio checklist analysis
# 3. Final combined report

.PHONY: help macro-report checklist final-report all clean

# Variables
TODAY := $(shell date +%Y-%m-%d)
PORTFOLIO_FILE := PORTFOLIO.csv
STOCKS := $(shell tail -n +2 $(PORTFOLIO_FILE) | cut -d',' -f1 | tr '\n' ',' | sed 's/,$$//')
MACRO_SCRIPT := macro/MACRO_RESEARCH_SCRIPT.md
MACRO_REPORTS_DIR := macro/reports
MACRO_REPORT := $(MACRO_REPORTS_DIR)/REPORT_$(TODAY).md
CHECKLIST_FILE := checklist/investment_checklist.md
CHECKLIST_HISTORY_DIR := checklist/history
CHECKLIST_REPORT := $(CHECKLIST_HISTORY_DIR)/REPORT_$(TODAY).md
FINAL_REPORT := $(CHECKLIST_HISTORY_DIR)/FINAL_REPORT_$(TODAY).md

# Colors for output
GREEN := \033[0;32m
YELLOW := \033[0;33m
BLUE := \033[0;34m
RED := \033[0;31m
NC := \033[0m # No Color

help:
	@echo "$(BLUE)Investment Analysis Makefile$(NC)"
	@echo ""
	@echo "$(GREEN)Available targets:$(NC)"
	@echo "  $(YELLOW)make macro-report$(NC)     - Generate macro economic report"
	@echo "  $(YELLOW)make checklist$(NC)         - Run investment portfolio checklist analysis"
	@echo "  $(YELLOW)make final-report$(NC)      - Generate final combined report (requires macro + checklist)"
	@echo "  $(YELLOW)make all$(NC)               - Run macro, checklist, and final report"
	@echo "  $(YELLOW)make setup$(NC)             - Create necessary directories"
	@echo "  $(YELLOW)make clean$(NC)             - Clean up temporary files"
	@echo ""
	@echo "$(GREEN)Examples:$(NC)"
	@echo "  make macro-report"
	@echo "  make checklist"
	@echo "  make final-report"
	@echo "  make all"

# Create necessary directory structure
setup:
	@echo "$(GREEN)Creating directory structure...$(NC)"
	@mkdir -p $(MACRO_REPORTS_DIR)
	@mkdir -p $(CHECKLIST_HISTORY_DIR)
	@echo "$(GREEN)✓ Directories created$(NC)"

# Generate macro economic report
macro-report: setup
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo "$(GREEN)Generating Macro Economic Report for $(TODAY)$(NC)"
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo ""
	@echo "$(YELLOW)Portfolio stocks: $(STOCKS)$(NC)"
	@echo ""
	@claude "Please execute the MACRO_RESEARCH_SCRIPT.md located in macro/. \
	\
	Research the latest macroeconomic data (last 14-30 days) and generate a comprehensive report file at macro/reports/REPORT_$(TODAY).md. \
	\
	The report must be written entirely in Korean (한국어). \
	\
	Include: \
	- 통화정책 및 금리 (Monetary Policy & Interest Rates) \
	- 인플레이션 및 경제 성장 (Inflation & Economic Growth) \
	- 통화 및 원자재 (Currency & Commodities) \
	- 지정학 및 정책 리스크 (Geopolitical & Policy Risks) \
	- 섹터별 거시경제 인사이트 (Sector-Specific Macro Insights for $(STOCKS)) \
	- 시장 심리 및 포지셔닝 (Market Sentiment & Positioning) \
	- 거시경제 트리거 및 경고 (Macro Triggers & Alerts) \
	- 거시경제 기반 포트폴리오 권고사항 (Macro-Based Portfolio Recommendations) \
	\
	Use WebSearch and WebFetch tools to gather latest data from: \
	- Federal Reserve, BLS, BEA, EIA \
	- Bloomberg, Reuters, WSJ, FT \
	- Trading Economics, FRED \
	\
	Cite all sources with dates."
	@echo ""
	@echo "$(GREEN)✓ Macro report generated at $(MACRO_REPORT)$(NC)"

# Run investment checklist analysis
checklist: setup
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo "$(GREEN)Running Investment Portfolio Checklist for $(TODAY)$(NC)"
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo ""
	@echo "$(YELLOW)Portfolio stocks: $(STOCKS)$(NC)"
	@echo ""
	@claude "Please execute the investment portfolio checklist analysis. \
	\
	Instructions: \
	1. Read checklist/investment_checklist.md \
	2. Review previous reports in checklist/history/REPORT_*.md \
	3. Research latest news and data for all holdings ($(STOCKS)) \
	4. Analyze each stock's: \
	   - Logic status (STRONGER/INTACT/WEAKENING/BROKEN) \
	   - Valuation (Undervalued/Fair/Overvalued/EXPENSIVE) \
	   - Expected Return (12-month probability-weighted) \
	   - Portfolio recommendations \
	\
	Follow the comprehensive framework in investment_checklist.md: \
	- Section 0.0: Market-Level Assessment (S&P 500 valuation) \
	- Section 0.1: Macro Regime Check (Fed, rates, ISM, VIX) \
	- Section 0.2: Historical Review (compare with previous reports) \
	- Section 1: Individual Stock Logic Status \
	- Section 2: Logic + Valuation Check \
	- Section 3-4: Action Guidelines and DCA Adjustments \
	- Section 5: Position Sizing (Kelly Criterion) \
	- Section 7: New Investment Ideas Discovery \
	\
	Use WebSearch extensively for: \
	- Latest company news, earnings, guidance \
	- Analyst ratings and price targets \
	- Sector-specific news (utilities, semiconductors, data centers) \
	- Macro indicators (CPI, PMI, jobs data) \
	\
	Generate a comprehensive report in Korean and save to: checklist/history/REPORT_$(TODAY).md \
	\
	The report must include: \
	- Executive summary \
	- Market-level valuation assessment \
	- Macro regime analysis \
	- Stock-by-stock analysis table \
	- Portfolio adjustment recommendations \
	- DCA allocation table \
	- Risk assessment \
	- Sources with dates"
	@echo ""
	@echo "$(GREEN)✓ Checklist report generated at $(CHECKLIST_REPORT)$(NC)"

# Generate final combined report (requires both macro and checklist reports)
final-report:
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo "$(GREEN)Generating Final Combined Report for $(TODAY)$(NC)"
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo ""
	@echo "$(YELLOW)Checking required files...$(NC)"
	@test -f $(MACRO_REPORT) && echo "$(GREEN)✓$(NC) Macro report found" || (echo "$(RED)✗$(NC) Macro report not found. Run 'make macro-report' first" && exit 1)
	@test -f $(CHECKLIST_REPORT) && echo "$(GREEN)✓$(NC) Checklist report found" || (echo "$(RED)✗$(NC) Checklist report not found. Run 'make checklist' first" && exit 1)
	@echo ""
	@claude "Please generate a comprehensive final investment report by synthesizing the macro and checklist reports. \
	\
	Instructions: \
	1. Read the macro economic report: $(MACRO_REPORT) \
	2. Read the portfolio checklist report: $(CHECKLIST_REPORT) \
	3. Synthesize both reports into a single executive summary \
	\
	The final report should include: \
	\
	## 1. Executive Summary (경영진 요약) \
	- Overall market conditions and macro regime \
	- Portfolio health status (number of stocks: STRONGER/INTACT/WEAKENING/BROKEN) \
	- Key actions required this week \
	- Major risks and opportunities \
	\
	## 2. Macro-Driven Insights (거시경제 인사이트) \
	- Key macro trends affecting the portfolio (Fed policy, inflation, rates) \
	- Sector-level impacts (utilities, semiconductors, data centers, gold) \
	- Currency and commodity impacts \
	- Geopolitical risks \
	\
	## 3. Portfolio Status (포트폴리오 현황) \
	- Stock-by-stock summary table with: \
	  * Logic Status \
	  * Valuation \
	  * Expected Return \
	  * DCA Allocation \
	  * Action (BUY/HOLD/PAUSE/EXIT) \
	- Current vs target allocation \
	\
	## 4. Action Plan (실행 계획) \
	- DCA adjustments for next period \
	- Specific buy/sell/hold decisions with rationale \
	- Position sizing recommendations \
	- New investment ideas to research \
	\
	## 5. Risk Assessment (리스크 평가) \
	- Portfolio-level risks \
	- Macro triggers to watch \
	- Stop-loss or exit conditions \
	\
	## 6. Sources & Data Quality \
	- List all key data sources with dates \
	- Note any data gaps or uncertainties \
	\
	Generate the report in Korean and save to: checklist/history/FINAL_REPORT_$(TODAY).md \
	\
	The report should be actionable, concise, and ready for immediate use in investment decisions."
	@echo ""
	@echo "$(GREEN)✓ Final report generated at $(FINAL_REPORT)$(NC)"

# Run all three analyses
all: macro-report checklist final-report
	@echo ""
	@echo "$(GREEN)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo "$(GREEN)✓ All three tasks completed successfully$(NC)"
	@echo "$(GREEN)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo ""
	@echo "Generated files:"
	@echo "  1. $(MACRO_REPORT)"
	@echo "  2. $(CHECKLIST_REPORT)"
	@echo "  3. $(FINAL_REPORT)"

# Quick reference
info:
	@echo "$(BLUE)Current Configuration:$(NC)"
	@echo "  Today: $(TODAY)"
	@echo "  Portfolio File: $(PORTFOLIO_FILE)"
	@echo "  Stocks: $(STOCKS)"
	@echo "  Macro Script: $(MACRO_SCRIPT)"
	@echo "  Macro Reports Dir: $(MACRO_REPORTS_DIR)"
	@echo "  Checklist File: $(CHECKLIST_FILE)"
	@echo "  Checklist History Dir: $(CHECKLIST_HISTORY_DIR)"
	@echo ""
	@echo "$(BLUE)Output Files:$(NC)"
	@echo "  Macro Report: $(MACRO_REPORT)"
	@echo "  Checklist Report: $(CHECKLIST_REPORT)"
	@echo "  Final Report: $(FINAL_REPORT)"

# Check if required files exist
check:
	@echo "$(YELLOW)Checking required files...$(NC)"
	@test -f $(PORTFOLIO_FILE) && echo "$(GREEN)✓$(NC) $(PORTFOLIO_FILE) (stocks: $(STOCKS))" || echo "$(RED)✗$(NC) $(PORTFOLIO_FILE) not found"
	@test -f $(MACRO_SCRIPT) && echo "$(GREEN)✓$(NC) $(MACRO_SCRIPT)" || echo "$(RED)✗$(NC) $(MACRO_SCRIPT) not found"
	@test -f $(CHECKLIST_FILE) && echo "$(GREEN)✓$(NC) $(CHECKLIST_FILE)" || echo "$(RED)✗$(NC) $(CHECKLIST_FILE) not found"
	@test -d $(CHECKLIST_HISTORY_DIR) && echo "$(GREEN)✓$(NC) $(CHECKLIST_HISTORY_DIR) exists" || echo "$(YELLOW)⚠$(NC) History directory not found"
	@test -d $(MACRO_REPORTS_DIR) && echo "$(GREEN)✓$(NC) $(MACRO_REPORTS_DIR) exists" || echo "$(YELLOW)⚠$(NC) Macro reports directory not found"

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
	@echo "   Output:  macro/reports/REPORT_$(TODAY).md"
	@echo ""
	@echo "$(YELLOW)2. Run Portfolio Checklist$(NC)"
	@echo "   Command: make checklist"
	@echo "   Purpose: Analyze each stock (logic, valuation, recommendations)"
	@echo "   Output:  checklist/history/REPORT_$(TODAY).md"
	@echo ""
	@echo "$(YELLOW)3. Generate Final Combined Report$(NC)"
	@echo "   Command: make final-report"
	@echo "   Purpose: Synthesize macro + checklist into actionable summary"
	@echo "   Output:  checklist/history/FINAL_REPORT_$(TODAY).md"
	@echo "   Note:    Requires both macro and checklist reports to exist"
	@echo ""
	@echo "$(YELLOW)4. Run All Three$(NC)"
	@echo "   Command: make all"
	@echo "   Purpose: Generate all reports in sequence"
	@echo ""
	@echo "$(YELLOW)5. Check Status$(NC)"
	@echo "   Command: make check"
	@echo "   Purpose: Verify all required files exist"
	@echo ""
	@echo "$(GREEN)Recommended Workflow:$(NC)"
	@echo "  1. cd investment/"
	@echo "  2. make check            # Verify setup"
	@echo "  3. make macro-report     # Generate macro report (copy prompt to Claude)"
	@echo "  4. make checklist        # Generate portfolio report (copy prompt to Claude)"
	@echo "  5. make final-report     # Generate combined report (copy prompt to Claude)"
	@echo ""
	@echo "$(GREEN)Quick Workflow:$(NC)"
	@echo "  make all                 # Run all three steps"
	@echo ""
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"

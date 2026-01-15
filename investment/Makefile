# Investment Analysis Makefile
#
# This Makefile automates investment analysis tasks including:
# 1. Macro report generation
# 2. Portfolio checklist analysis
# 3. Final combined report
# 4. Decision Quality Framework (Pre-Decision Checklist)
# 5. Continuous Learning System (Decision Log & Quarterly Review)

.PHONY: help macro-report checklist final-report all clean
.PHONY: new-decision log-decision update-returns show-log check-reviews
.PHONY: quarterly-review analyze-decisions calibration-check pattern-analysis
.PHONY: setup-learning list-decisions

# Variables
TODAY := $(shell date +%Y-%m-%d)
CURRENT_TIME := $(shell date +%H:%M)
CURRENT_QUARTER := $(shell date +%Y_Q$$(((10\#$$(date +%m)-1)/3+1)))
PORTFOLIO_FILE := PORTFOLIO.csv
STOCKS := $(shell tail -n +2 $(PORTFOLIO_FILE) | cut -d',' -f1 | tr '\n' ',' | sed 's/,$$//')
MACRO_SCRIPT := macro/MACRO_RESEARCH_SCRIPT.md
MACRO_REPORTS_DIR := macro/reports
MACRO_REPORT := $(MACRO_REPORTS_DIR)/REPORT_$(TODAY).md
CHECKLIST_FILE := checklist/investment_checklist.md
CHECKLIST_HISTORY_DIR := checklist/history
CHECKLIST_REPORT := $(CHECKLIST_HISTORY_DIR)/REPORT_$(TODAY).md
FINAL_REPORT := $(CHECKLIST_HISTORY_DIR)/FINAL_REPORT_$(TODAY).md

# Decision Quality & Learning System Variables
PRE_DECISION_TEMPLATE := checklist/PRE_DECISION_CHECKLIST.md
PRE_DECISION_DIR := decisions/pre_decision
DECISION_LOG := decisions/decision_log.jsonl
DECISION_LOG_MD := decisions/DECISION_LOG.md
LEARNING_DIR := learning
QUARTERLY_REVIEW_TEMPLATE := $(LEARNING_DIR)/QUARTERLY_REVIEW_TEMPLATE.md
QUARTERLY_REVIEW := $(LEARNING_DIR)/QUARTERLY_REVIEW_$(CURRENT_QUARTER).md
USAGE_GUIDE := USAGE_GUIDE.md

# Colors for output
GREEN := \033[0;32m
YELLOW := \033[0;33m
BLUE := \033[0;34m
RED := \033[0;31m
NC := \033[0m # No Color

help:
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo "$(BLUE)         Investment Analysis & Learning System Makefile$(NC)"
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo ""
	@echo "$(GREEN)📊 Portfolio Analysis:$(NC)"
	@echo "  $(YELLOW)make macro-report$(NC)         - Generate macro economic report"
	@echo "  $(YELLOW)make checklist$(NC)             - Run investment portfolio checklist analysis"
	@echo "  $(YELLOW)make final-report$(NC)          - Generate final combined report"
	@echo "  $(YELLOW)make all$(NC)                   - Run all three reports in sequence"
	@echo ""
	@echo "$(GREEN)🎯 Decision Quality (Pre-Decision Checklist):$(NC)"
	@echo "  $(YELLOW)make new-decision$(NC)          - Create new pre-decision checklist (interactive)"
	@echo "  $(YELLOW)make list-decisions$(NC)        - List all pre-decision checklists"
	@echo ""
	@echo "$(GREEN)📝 Decision Tracking:$(NC)"
	@echo "  $(YELLOW)make log-decision$(NC)          - Record a decision to decision log (interactive)"
	@echo "  $(YELLOW)make show-log$(NC)              - Display decision log summary"
	@echo "  $(YELLOW)make update-returns$(NC)        - Update 1mo/6mo returns for all decisions"
	@echo "  $(YELLOW)make check-reviews$(NC)         - Check which decisions need review"
	@echo ""
	@echo "$(GREEN)📈 Learning & Analysis:$(NC)"
	@echo "  $(YELLOW)make quarterly-review$(NC)      - Generate quarterly review for learning"
	@echo "  $(YELLOW)make analyze-decisions$(NC)     - Run Python analysis on decision log"
	@echo "  $(YELLOW)make calibration-check$(NC)     - Check Expected Return accuracy"
	@echo "  $(YELLOW)make pattern-analysis$(NC)      - Find patterns in decision history"
	@echo ""
	@echo "$(GREEN)🔧 Setup & Utilities:$(NC)"
	@echo "  $(YELLOW)make setup$(NC)                 - Create necessary directories"
	@echo "  $(YELLOW)make setup-learning$(NC)        - Setup learning system directories"
	@echo "  $(YELLOW)make check$(NC)                 - Check if required files exist"
	@echo "  $(YELLOW)make info$(NC)                  - Display current configuration"
	@echo "  $(YELLOW)make guide$(NC)                 - Show quick start guide"
	@echo "  $(YELLOW)make clean$(NC)                 - Clean up temporary files"
	@echo ""
	@echo "$(GREEN)💡 Quick Examples:$(NC)"
	@echo "  make all                          # Generate all portfolio reports"
	@echo "  make new-decision                 # Start pre-decision checklist"
	@echo "  make log-decision                 # Log a completed decision"
	@echo "  make quarterly-review             # Run quarterly learning review"
	@echo ""
	@echo "$(YELLOW)📚 For detailed usage: make guide or see USAGE_GUIDE.md$(NC)"
	@echo ""

# Create necessary directory structure
setup:
	@echo "$(GREEN)Creating directory structure...$(NC)"
	@mkdir -p $(MACRO_REPORTS_DIR)
	@mkdir -p $(CHECKLIST_HISTORY_DIR)
	@mkdir -p $(PRE_DECISION_DIR)
	@mkdir -p decisions
	@mkdir -p $(LEARNING_DIR)
	@echo "$(GREEN)✓ Directories created$(NC)"

# Setup learning system directories and initialize files
setup-learning: setup
	@echo "$(GREEN)Setting up Decision Quality & Learning System...$(NC)"
	@mkdir -p $(PRE_DECISION_DIR)
	@mkdir -p decisions/analysis
	@mkdir -p $(LEARNING_DIR)
	@test -f $(DECISION_LOG) || touch $(DECISION_LOG)
	@test -f $(DECISION_LOG_MD) || cp decisions/DECISION_LOG.md $(DECISION_LOG_MD) 2>/dev/null || echo "# Decision Log\n\nNo decisions recorded yet." > $(DECISION_LOG_MD)
	@echo "$(GREEN)✓ Learning system initialized$(NC)"
	@echo ""
	@echo "$(YELLOW)Created:$(NC)"
	@echo "  - $(PRE_DECISION_DIR)/ (for pre-decision checklists)"
	@echo "  - $(DECISION_LOG) (decision tracking)"
	@echo "  - $(LEARNING_DIR)/ (quarterly reviews)"
	@echo ""
	@echo "$(GREEN)Next steps:$(NC)"
	@echo "  1. Read $(USAGE_GUIDE) for detailed instructions"
	@echo "  2. Use 'make new-decision' when making important decisions"
	@echo "  3. Use 'make log-decision' after executing decisions"
	@echo "  4. Run 'make quarterly-review' at end of each quarter"

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

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Decision Quality Framework Commands
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Create a new pre-decision checklist (interactive with Claude)
new-decision:
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo "$(GREEN)Creating New Pre-Decision Checklist (Interactive)$(NC)"
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo ""
	@read -p "$(YELLOW)Enter ticker symbol (e.g., GEV): $(NC)" ticker; \
	read -p "$(YELLOW)Enter action (INCREASE/DECREASE/NEW_ENTRY/EXIT): $(NC)" action; \
	filename="PRE_DECISION_$(TODAY)_$${ticker}_$${action}.md"; \
	filepath="$(PRE_DECISION_DIR)/$${filename}"; \
	echo "$(GREEN)Starting interactive pre-decision checklist for $${ticker} ($${action})$(NC)"; \
	echo ""; \
	claude "You are helping me complete a Pre-Decision Investment Checklist for $${ticker} ($${action}). \
	\
	## Your Task \
	Guide me through the checklist by: \
	1. Asking me questions one section at a time \
	2. Researching market data automatically (VIX, stock prices, analyst ratings, insider trading, recent news) \
	3. Helping me check for cognitive biases \
	4. Playing devil's advocate (Contrarian Agent) \
	5. Generating the final filled-out checklist file \
	\
	## Process \
	\
	### PART 1: Basic Info (Research + Ask) \
	- Research current $${ticker} stock price, 7-day performance \
	- Research VIX level \
	- Research S&P 500 7-day performance \
	- Ask me: Current weight in portfolio (%)? Target weight (%)? Amount in USD? \
	- Ask me: Current psychological state? (calm/excited/anxious/rushed) \
	\
	### PART 2: Cognitive Bias Checks (Interactive) \
	For each bias, ask me the relevant questions and help me identify if I'm affected: \
	- Anchoring: Am I fixating on a recent price/news? \
	- Confirmation: Am I only seeking supporting information? \
	- FOMO: Am I feeling urgency because others are profiting? \
	- Loss Aversion: Am I avoiding realizing a loss? \
	- Overconfidence: Do I think I know better than the market? \
	- Herding: Am I following the crowd? \
	\
	### PART 3: Information Quality (Research) \
	- Search for recent company filings (8-K, 10-Q) \
	- Search for recent analyst ratings and price targets \
	- Search for insider trading activity (SEC Form 4) \
	- Search for recent news from Tier 1 sources (Reuters, Bloomberg, WSJ, FT) \
	\
	### PART 4: Investment Logic (Ask) \
	- Ask me: What is your core thesis in one sentence? \
	- Ask me: What is the structural moat/bottleneck? \
	- Ask me: How does this convert to earnings? \
	- Ask me: Logic status? (STRONGER/INTACT/WEAKENING/BROKEN) \
	\
	### PART 5: Valuation (Research + Ask) \
	- Research Forward PE, PEG ratio \
	- Ask me: Bear/Base/Bull case scenarios and probabilities \
	- Calculate probability-weighted Expected Return \
	\
	### PART 6: Pre-Mortem (Ask) \
	- Ask me: What could make this decision fail in 6 months? \
	- Ask me: What are your exit triggers? \
	- Ask me: Can you sleep well with this position size? \
	\
	### PART 7: Portfolio Impact (Calculate) \
	- Read PORTFOLIO.csv to understand current holdings \
	- Calculate post-decision concentration risks \
	\
	### PART 8: Contrarian Agent (You Do This) \
	- Present the 3 strongest arguments AGAINST this decision \
	- Ask me to rebut each one \
	\
	### PART 9: Final Score (Calculate) \
	- Score each of the 7 required criteria \
	- Determine: Execute / Conditional / Hold \
	\
	## Output \
	After completing all sections interactively, generate the filled checklist and save to: \
	$(PRE_DECISION_DIR)/$${filename} \
	\
	The file should follow the exact format of checklist/PRE_DECISION_CHECKLIST.md template but with all fields filled in based on our conversation and your research. \
	\
	## Language \
	- Conduct the conversation in Korean (한국어) \
	- The output file should also be in Korean \
	\
	Start by greeting me and asking the first questions for PART 1."; \
	echo ""; \
	echo "$(GREEN)✓ Pre-Decision Checklist session complete$(NC)"; \
	echo "$(YELLOW)Check: $(PRE_DECISION_DIR)/$${filename}$(NC)"

# List all pre-decision checklists
list-decisions:
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo "$(GREEN)Recent Pre-Decision Checklists$(NC)"
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo ""
	@if [ -d "$(PRE_DECISION_DIR)" ] && [ "$$(ls -A $(PRE_DECISION_DIR) 2>/dev/null)" ]; then \
		ls -lt $(PRE_DECISION_DIR)/*.md 2>/dev/null | head -10 | awk '{print "  " $$9 " (" $$6 " " $$7 ")"}' || echo "$(YELLOW)No decisions found$(NC)"; \
	else \
		echo "$(YELLOW)No pre-decision checklists yet. Create one with: make new-decision$(NC)"; \
	fi
	@echo ""

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Decision Log Commands
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Log a decision (interactive)
log-decision:
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo "$(GREEN)Recording Decision to Log$(NC)"
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo ""
	@echo "$(YELLOW)This will create a Python script to help you log decisions.$(NC)"
	@echo "$(YELLOW)Please provide the following information:$(NC)"
	@echo ""
	@read -p "Ticker: " ticker; \
	read -p "Action (INCREASE/DECREASE/NEW_ENTRY/EXIT): " action; \
	read -p "From weight (%): " from_weight; \
	read -p "To weight (%): " to_weight; \
	read -p "Amount (USD): " amount; \
	read -p "Logic Status (STRONGER/INTACT/WEAKENING/BROKEN): " logic_status; \
	read -p "Valuation (UNDERVALUED/FAIR/OVERVALUED/EXPENSIVE): " valuation; \
	read -p "Expected Return (%): " expected_return; \
	read -p "Core Thesis (one line): " core_thesis; \
	read -p "Pre-Decision Score (e.g., 7/7): " pre_score; \
	read -p "Psychological State (calm/excited/anxious/rushed): " psych_state; \
	read -p "VIX level: " vix; \
	echo ""; \
	echo "$(GREEN)Logging decision...$(NC)"; \
	python3 -c "import json; from datetime import datetime, timedelta; \
	d = { \
		'decision_id': '$(TODAY)-$${ticker}-$${action}', \
		'date': '$(TODAY)', \
		'time': '$(CURRENT_TIME)', \
		'ticker': '$${ticker}', \
		'action': '$${action}', \
		'from_weight': float($${from_weight}), \
		'to_weight': float($${to_weight}), \
		'change_pct': float($${to_weight}) - float($${from_weight}), \
		'amount_usd': int($${amount}), \
		'execution_method': 'DCA', \
		'logic_status': '$${logic_status}', \
		'valuation': '$${valuation}', \
		'expected_return_pct': int($${expected_return}), \
		'core_thesis': '$${core_thesis}', \
		'evidence_tier1_count': 2, \
		'pre_decision_score': '$${pre_score}', \
		'psychological_state': '$${psych_state}', \
		'vix': float($${vix}), \
		'actual_return_1mo': None, \
		'actual_return_6mo': None, \
		'was_correct': None, \
		'lessons_learned': None, \
		'review_date_1mo': (datetime.now() + timedelta(days=30)).strftime('%Y-%m-%d'), \
		'review_date_6mo': (datetime.now() + timedelta(days=180)).strftime('%Y-%m-%d') \
	}; \
	with open('$(DECISION_LOG)', 'a') as f: f.write(json.dumps(d) + '\n'); \
	print('✓ Decision logged: ' + d['decision_id'])"; \
	echo ""; \
	echo "$(GREEN)✓ Decision logged to $(DECISION_LOG)$(NC)"; \
	echo ""; \
	echo "$(YELLOW)Next steps:$(NC)"; \
	echo "  1. Review in 1 month: $$(date -v+30d +%Y-%m-%d 2>/dev/null || date -d '+30 days' +%Y-%m-%d 2>/dev/null || echo '30 days from now')"; \
	echo "  2. Final review in 6 months: $$(date -v+180d +%Y-%m-%d 2>/dev/null || date -d '+180 days' +%Y-%m-%d 2>/dev/null || echo '180 days from now')"; \
	echo "  3. Run 'make show-log' to see summary"

# Show decision log summary
show-log:
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo "$(GREEN)Decision Log Summary$(NC)"
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo ""
	@if [ -f "$(DECISION_LOG)" ] && [ -s "$(DECISION_LOG)" ]; then \
		python3 -c "import json; \
		decisions = [json.loads(line) for line in open('$(DECISION_LOG)')]; \
		print(f'Total decisions: {len(decisions)}'); \
		print(f'Completed (6mo+): {sum(1 for d in decisions if d.get(\"actual_return_6mo\") is not None)}'); \
		print(f'Pending: {sum(1 for d in decisions if d.get(\"actual_return_6mo\") is None)}'); \
		print(''); \
		print('Recent decisions:'); \
		for d in decisions[-5:]: \
			status = '⏳' if d.get('actual_return_6mo') is None else ('✅' if d.get('was_correct') else '❌'); \
			print(f\"  {status} {d['date']} {d['ticker']} {d['action']} (ER: {d['expected_return_pct']}%)\")"; \
	else \
		echo "$(YELLOW)No decisions logged yet. Use 'make log-decision' to start.$(NC)"; \
	fi
	@echo ""

# Update returns for all decisions (requires yfinance)
update-returns:
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo "$(GREEN)Updating Decision Returns$(NC)"
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo ""
	@echo "$(YELLOW)Checking for yfinance...$(NC)"
	@python3 -c "import yfinance" 2>/dev/null || (echo "$(RED)yfinance not installed. Install with: pip3 install yfinance$(NC)" && exit 1)
	@echo "$(GREEN)✓ yfinance found$(NC)"
	@echo ""
	@echo "$(YELLOW)Updating returns...$(NC)"
	@python3 -c "import json; import yfinance as yf; from datetime import datetime, timedelta; \
	decisions = [json.loads(line) for line in open('$(DECISION_LOG)')]; \
	today = datetime.now(); \
	updated = 0; \
	for d in decisions: \
		decision_date = datetime.strptime(d['date'], '%Y-%m-%d'); \
		days_passed = (today - decision_date).days; \
		if 25 <= days_passed <= 35 and d['actual_return_1mo'] is None: \
			try: \
				ticker = yf.Ticker(d['ticker']); \
				hist = ticker.history(start=d['date'], period='1mo'); \
				if len(hist) > 0: \
					ret = (hist['Close'].iloc[-1] / hist['Close'].iloc[0] - 1) * 100; \
					d['actual_return_1mo'] = round(ret, 2); \
					updated += 1; \
					print(f\"✓ Updated 1mo: {d['decision_id']} = {ret:.1f}%\"); \
			except: pass; \
		if 175 <= days_passed <= 185 and d['actual_return_6mo'] is None: \
			try: \
				ticker = yf.Ticker(d['ticker']); \
				hist = ticker.history(start=d['date'], period='6mo'); \
				if len(hist) > 0: \
					ret = (hist['Close'].iloc[-1] / hist['Close'].iloc[0] - 1) * 100; \
					d['actual_return_6mo'] = round(ret, 2); \
					if ret >= d['expected_return_pct'] * 0.8: d['outcome_6mo'] = 'SUCCESS'; \
					elif ret >= d['expected_return_pct'] * 0.5: d['outcome_6mo'] = 'PARTIAL'; \
					else: d['outcome_6mo'] = 'FAILURE'; \
					updated += 1; \
					print(f\"✓ Updated 6mo: {d['decision_id']} = {ret:.1f}% → {d['outcome_6mo']}\"); \
			except: pass; \
	with open('$(DECISION_LOG)', 'w') as f: \
		for d in decisions: f.write(json.dumps(d) + '\n'); \
	print(f'\n📊 Updated {updated} decisions')"
	@echo ""
	@echo "$(GREEN)✓ Returns updated$(NC)"

# Check which decisions need review
check-reviews:
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo "$(GREEN)Decisions Needing Review$(NC)"
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo ""
	@if [ -f "$(DECISION_LOG)" ] && [ -s "$(DECISION_LOG)" ]; then \
		python3 -c "import json; from datetime import datetime; \
		decisions = [json.loads(line) for line in open('$(DECISION_LOG)')]; \
		today = datetime.now(); \
		need_1mo = [d for d in decisions if d.get('outcome_1mo') is None and datetime.strptime(d['review_date_1mo'], '%Y-%m-%d') <= today]; \
		need_6mo = [d for d in decisions if d.get('outcome_6mo') is None and datetime.strptime(d['review_date_6mo'], '%Y-%m-%d') <= today]; \
		if need_1mo: \
			print(f'⚠️  {len(need_1mo)} decisions need 1-month review:'); \
			for d in need_1mo: print(f\"  - {d['decision_id']} (Expected: {d['expected_return_pct']}%)\"); \
		if need_6mo: \
			print(f'\n⚠️  {len(need_6mo)} decisions need 6-month FINAL review:'); \
			for d in need_6mo: print(f\"  - {d['decision_id']} (Expected: {d['expected_return_pct']}%)\"); \
			print('\n📝 Add lessons_learned to each decision!'); \
		if not need_1mo and not need_6mo: print('$(GREEN)✓ All decisions up to date!$(NC)')"; \
	else \
		echo "$(YELLOW)No decisions to review yet.$(NC)"; \
	fi
	@echo ""

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Learning & Analysis Commands
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Generate quarterly review
quarterly-review:
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo "$(GREEN)Generating Quarterly Review - $(CURRENT_QUARTER)$(NC)"
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo ""
	@if [ ! -f "$(DECISION_LOG)" ] || [ ! -s "$(DECISION_LOG)" ]; then \
		echo "$(RED)No decisions in log. Cannot generate quarterly review yet.$(NC)"; \
		echo "$(YELLOW)You need at least 5 completed decisions (6 months old) to run a meaningful review.$(NC)"; \
		exit 1; \
	fi
	@echo "$(YELLOW)Copying template...$(NC)"
	@cp $(QUARTERLY_REVIEW_TEMPLATE) $(QUARTERLY_REVIEW)
	@echo "$(GREEN)✓ Template copied to $(QUARTERLY_REVIEW)$(NC)"
	@echo ""
	@echo "$(YELLOW)Running basic analysis...$(NC)"
	@python3 -c "import json; \
	decisions = [json.loads(line) for line in open('$(DECISION_LOG)')]; \
	completed = [d for d in decisions if d.get('actual_return_6mo') is not None]; \
	print(f'Total decisions: {len(decisions)}'); \
	print(f'Completed (6mo+): {len(completed)}'); \
	if completed: \
		success = sum(1 for d in completed if d.get('outcome_6mo') == 'SUCCESS'); \
		print(f'Success rate: {success/len(completed)*100:.1f}%'); \
		stronger = [d for d in completed if d.get('logic_status') == 'STRONGER']; \
		if stronger: \
			stronger_success = sum(1 for d in stronger if d.get('was_correct')); \
			print(f'LOGIC STRONGER success: {stronger_success}/{len(stronger)}');"
	@echo ""
	@echo "$(GREEN)✓ Quarterly review template ready!$(NC)"
	@echo ""
	@echo "$(YELLOW)Next steps:$(NC)"
	@echo "  1. Open: $(QUARTERLY_REVIEW)"
	@echo "  2. Run 'make analyze-decisions' for detailed Python analysis"
	@echo "  3. Fill out all sections based on the data"
	@echo "  4. Identify patterns and create framework improvements"
	@echo "  5. Apply improvements to investment_checklist.md"
	@echo ""
	@echo "$(BLUE)Opening template...$(NC)"
	@open $(QUARTERLY_REVIEW) || echo "Please open: $(QUARTERLY_REVIEW)"

# Run Python analysis on decision log
analyze-decisions:
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo "$(GREEN)Decision Log Analysis$(NC)"
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo ""
	@python3 -c "import json; import pandas as pd; \
	decisions = [json.loads(line) for line in open('$(DECISION_LOG)')]; \
	df = pd.DataFrame(decisions); \
	print('=== Overall Stats ==='); \
	print(f\"Total decisions: {len(df)}\"); \
	completed = df[df['actual_return_6mo'].notna()]; \
	print(f\"Completed (6mo+): {len(completed)}\"); \
	if len(completed) > 0: \
		print(f\"Success rate: {(completed['outcome_6mo'] == 'SUCCESS').mean() * 100:.1f}%\"); \
		print(f\"Mean ER error: {(completed['actual_return_6mo'] - completed['expected_return_pct']).mean():.1f}%\"); \
		print(''); \
		print('=== By Logic Status ==='); \
		print(df.groupby('logic_status')['expected_return_pct'].agg(['count', 'mean'])); \
		print(''); \
		print('=== By Valuation ==='); \
		print(df.groupby('valuation')['expected_return_pct'].agg(['count', 'mean'])); \
		print(''); \
		print('=== By Psychological State ==='); \
		print(df.groupby('psychological_state')['expected_return_pct'].agg(['count', 'mean'])); \
	else: \
		print('Not enough completed decisions for analysis.');"
	@echo ""

# Check calibration of Expected Return predictions
calibration-check:
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo "$(GREEN)Expected Return Calibration Check$(NC)"
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo ""
	@python3 -c "import json; import pandas as pd; \
	decisions = [json.loads(line) for line in open('$(DECISION_LOG)')]; \
	df = pd.DataFrame(decisions); \
	completed = df[df['actual_return_6mo'].notna()]; \
	if len(completed) >= 5: \
		df['er_error'] = df['actual_return_6mo'] - df['expected_return_pct']; \
		mean_error = df['er_error'].mean(); \
		print(f'Mean ER Error: {mean_error:.1f}%'); \
		if mean_error < -5: print('⚠️  OVERCONFIDENT - You consistently predict higher returns than reality'); \
		elif mean_error > 5: print('⚠️  UNDERCONFIDENT - You consistently predict lower returns than reality'); \
		else: print('✅ WELL CALIBRATED - Your predictions are accurate on average'); \
		print(''); \
		print('By ER Range:'); \
		df['er_range'] = pd.cut(df['expected_return_pct'], bins=[-100, 0, 15, 30, 100], labels=['<0%', '0-15%', '15-30%', '>30%']); \
		print(df.groupby('er_range')['er_error'].agg(['count', 'mean'])); \
	else: \
		print('Need at least 5 completed decisions (6 months old) for calibration check.');"
	@echo ""

# Find patterns in decision history
pattern-analysis:
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo "$(GREEN)Pattern Analysis$(NC)"
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo ""
	@python3 -c "import json; import pandas as pd; \
	decisions = [json.loads(line) for line in open('$(DECISION_LOG)')]; \
	df = pd.DataFrame(decisions); \
	completed = df[df['actual_return_6mo'].notna()]; \
	if len(completed) >= 5: \
		print('=== Pattern 1: Logic + Valuation ==='); \
		df['combo'] = df['logic_status'] + ' + ' + df['valuation']; \
		combos = df.groupby('combo')['expected_return_pct'].agg(['count', 'mean']); \
		print(combos[combos['count'] >= 2].sort_values('mean', ascending=False)); \
		print(''); \
		print('=== Pattern 2: Psychological State ==='); \
		psych = completed.groupby('psychological_state')['actual_return_6mo'].agg(['count', 'mean']); \
		print(psych.sort_values('mean', ascending=False)); \
		print(''); \
		print('=== Pattern 3: Pre-Decision Score ==='); \
		score = completed.groupby('pre_decision_score')['outcome_6mo'].apply(lambda x: (x == 'SUCCESS').mean() * 100); \
		print('Success rate by score:'); \
		print(score.sort_index(ascending=False)); \
	else: \
		print('Need at least 5 completed decisions for pattern analysis.');"
	@echo ""

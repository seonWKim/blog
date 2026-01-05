# Investment Decision Workflow

> **Reference:** See [basics.md](./basics.md) for detailed concepts and principles

## Pipeline Overview

This workflow implements a systematic approach for AI-driven investment decisions. Each stage requires specific data inputs and produces actionable outputs.

---

## Stage 1: Initial Screening

**Objective:** Filter opportunities based on fundamental criteria

### Checklist:
- [ ] **Business Model Analysis**
  - How does the company generate revenue?
  - Is the model sustainable and scalable?
  - Reference: [basics.md#pre-investment-checklist](./basics.md)

- [ ] **Profitability Check**
  - Retrieve: Latest quarterly/annual earnings (via MCP/API)
  - Analyze: Revenue growth, profit margins, cash flow
  - Flag: Negative trends or deteriorating fundamentals

- [ ] **Data Requirements:**
  - Income statements (last 4 quarters)
  - Revenue growth YoY
  - Operating margins

**Decision Point:** PASS → Stage 2 | FAIL → Reject

---

## Stage 2: Risk Assessment

**Objective:** Identify and quantify investment risks

### Checklist:
- [ ] **Company-Specific Risks**
  - Debt levels and coverage ratios
  - Competitive moat strength
  - Management quality indicators

- [ ] **Market Risks**
  - Sector volatility (beta)
  - Correlation with macro variables
  - Reference: [basics.md#asset-allocation-mastery](./basics.md)

- [ ] **Data Requirements:**
  - Balance sheet data
  - Historical volatility (1Y, 5Y)
  - Sector correlation coefficients

**Decision Point:** Risk Level: LOW | MEDIUM | HIGH → Adjust position sizing

---

## Stage 3: Valuation Analysis

**Objective:** Determine if current price offers value

### Checklist:
- [ ] **Valuation Metrics**
  - Non-GAAP P/E ratio (Yahoo Finance)
  - P/E vs industry average
  - PEG ratio for growth stocks
  - Reference: [basics.md#pre-investment-checklist](./basics.md)

- [ ] **Price Action Analysis**
  - Chart pattern recognition
  - Support/resistance levels
  - Volume trends

- [ ] **Data Requirements:**
  - Current stock price
  - EPS (trailing & forward)
  - Industry median P/E
  - Historical price data (6M-1Y)

**Decision Point:** Undervalued → Stage 4 | Overvalued → Wait/Monitor

---

## Stage 4: Portfolio Integration

**Objective:** Determine position sizing and entry strategy

### Checklist:
- [ ] **Portfolio Diversification Check**
  - Calculate correlation with existing holdings
  - Verify sector exposure limits
  - Reference: [basics.md#portfolio-diversification](./basics.md)

- [ ] **Position Sizing**
  - Based on risk level (from Stage 2)
  - Based on conviction level
  - Apply Kelly Criterion or fixed percentage

- [ ] **Entry Strategy**
  - Immediate market order vs. limit order
  - Single entry vs. scaled entry (DCA)

- [ ] **Data Requirements:**
  - Current portfolio holdings
  - Correlation matrix
  - Available capital

**Decision Point:** BUY (position size: X%) | WAIT (set price alert) | PASS

---

## Stage 5: Execution & Monitoring

**Objective:** Execute trade and set up monitoring

### Checklist:
- [ ] **Pre-Trade**
  - Confirm position size
  - Set entry price/range
  - Define stop-loss level

- [ ] **Post-Trade**
  - Log trade in portfolio tracker
  - Set monitoring alerts (price, earnings dates)
  - Schedule review date

- [ ] **Monitoring Rules**
  - Review quarterly earnings
  - Track macro variable changes
  - Reassess if correlation patterns shift
  - Reference: [basics.md#long-term-investor-success-framework](./basics.md)

---

## Continuous Improvement

- Document lessons learned in `til.md`
- Run `make sync` to update this workflow and basics.md
- Refine decision criteria based on outcomes

---

## Quick Reference

**Key Principles:** (from basics.md)
- Probabilistic advantage over repeated trials
- Rule-based discipline
- Diversification through low-correlation assets
- Understanding macro drivers

**Critical Tools:**
- Yahoo Finance (non-GAAP P/E)
- MCP servers for real-time data
- Portfolio tracking system

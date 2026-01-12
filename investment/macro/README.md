# Macro Research Directory

This directory contains tools for researching macroeconomic conditions and generating investment reports.

**Language:** All reports are generated in **Korean (한국어)**.

## Files

- **MACRO_RESEARCH_SCRIPT.md**: Comprehensive script/prompt for Claude to research macro data and generate reports in Korean
- **reports/**: Directory where generated REPORT_{date}.md files are stored

## How to Use

### Quick Start

To generate a new macro report, provide Claude with this prompt:

```
Please execute the MACRO_RESEARCH_SCRIPT.md located in investment/macro/.
Research the latest macro data and generate a comprehensive REPORT_{today's date}.md
file in the investment/macro/reports/ directory. Write the entire report in Korean.
```

### What the Script Does

The script guides Claude to:

1. **Collect Macro Data** across 5 major categories:
   - Monetary Policy & Interest Rates (Fed, global central banks, yields)
   - Inflation & Economic Growth (CPI, GDP, PMI, employment)
   - Currency & Commodities (USD, gold, oil, natural gas)
   - Geopolitical & Policy Risks (conflicts, regulations, fiscal policy)
   - Market Sentiment & Positioning (equity flows, sentiment indicators)

2. **Analyze Sector-Specific Impacts**:
   - Power & Utilities (electricity demand, gas prices)
   - Semiconductors & Testing (chip demand, memory pricing)
   - Data Centers & REITs (interest rate sensitivity, cloud CapEx)
   - Precious Metals (real yields, safe haven demand)
   - Nuclear & SMRs (policy support, uranium prices)

3. **Generate Actionable Insights**:
   - Portfolio impact assessment
   - DCA adjustment recommendations
   - Scenario planning (recession, soft landing, etc.)
   - Trigger levels for thesis changes
   - Upcoming events to monitor

4. **Create Comprehensive Report**:
   - Structured markdown file with tables and analysis
   - All sources cited with dates
   - Specific recommendations for each holding
   - Next update schedule

## Report Structure

Each REPORT_{date}.md includes (in Korean):

1. 요약 (Executive Summary)
2. 통화정책 및 금리 (Monetary Policy & Interest Rates)
3. 인플레이션 및 경제 성장 (Inflation & Economic Growth)
4. 통화 및 원자재 (Currency & Commodities)
5. 지정학 및 정책 리스크 (Geopolitical & Policy Risks)
6. 섹터별 거시경제 인사이트 (Sector-Specific Macro Insights)
7. 시장 심리 및 포지셔닝 (Market Sentiment & Positioning)
8. 거시경제 트리거 및 경고 (Macro Triggers & Alerts)
9. 거시경제 기반 포트폴리오 권고사항 (Macro-Based Portfolio Recommendations)
10. 요약 및 다음 단계 (Summary & Next Steps)
11. 출처 및 링크 (Sources & Links)

## Recommended Frequency

- **Regular Updates**: Every 14 days
- **Ad-hoc Updates**: After major macro events:
  - FOMC meetings
  - Significant CPI/jobs reports
  - Major geopolitical events
  - Central bank policy shifts

## Integration with Investment Workflow

The macro reports feed into:
- Portfolio rebalancing decisions
- DCA amount adjustments
- Risk management and hedging
- New investment opportunity identification
- Thesis validation for existing holdings

## Data Sources

The script instructs Claude to use:
- **Official:** Fed, BLS, BEA, EIA, CME, FRED
- **Financial News:** Bloomberg, Reuters, FT, WSJ
- **Sector-Specific:** Utility Dive, Data Center Dynamics, SEMI
- **Market Data:** Trading Economics, Investing.com

## Notes

- Reports should be objective and data-driven
- Always cite sources with dates
- Flag data conflicts or uncertainty
- Connect every macro insight to portfolio impact
- Update scenario probabilities based on new data

---

**Last Updated:** 2026-01-12
**Version:** 1.0

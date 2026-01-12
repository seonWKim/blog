# Macro Research & Report Generation Script

**Purpose:** This script guides Claude to research the latest macroeconomic information and generate a comprehensive REPORT_{date}.md file for investment decision-making.

**Output Language:** All reports must be generated in **Korean (한국어)**

---

## Instructions for Claude

When executing this script, follow these steps systematically:

**IMPORTANT: Generate the entire report in Korean language. All section headings, analysis, tables, and recommendations must be in Korean.**

### Step 1: Initial Setup

1. Determine today's date and create the report filename as `REPORT_{YYYY-MM-DD}.md`
2. Set the research period: Last 14 days for primary analysis, last 30 days for supplementary context
3. Create a new markdown file in `investment/macro/reports/` directory

### Step 2: Macro Data Collection

Research and gather the following macroeconomic indicators and events:

#### A. Monetary Policy & Interest Rates
- [ ] **Federal Reserve:**
  - Latest FOMC meeting decisions and minutes
  - Fed Chair speeches and policy signals
  - Market expectations for next rate decision (CME FedWatch Tool data)
  - Current Fed Funds Rate and trajectory

- [ ] **Other Central Banks:**
  - ECB policy decisions and outlook
  - Bank of Japan updates
  - People's Bank of China actions

- [ ] **Interest Rate Environment:**
  - 10-year Treasury yield trends and changes
  - Yield curve (2Y-10Y spread) - inversion status
  - Real yields (TIPS)
  - Corporate bond spreads (IG and HY)

#### B. Inflation & Economic Growth
- [ ] **Inflation Metrics:**
  - Latest CPI (headline and core)
  - Latest PCI (headline and core)
  - Producer Price Index (PPI)
  - Inflation expectations (5Y, 10Y breakevens)

- [ ] **GDP & Growth:**
  - Latest GDP growth (actual and nowcast)
  - GDI (Gross Domestic Income) trends
  - Manufacturing PMI (ISM, S&P Global)
  - Services PMI
  - Regional Fed surveys (NY Fed, Philly Fed, etc.)

- [ ] **Labor Market:**
  - Latest Non-Farm Payrolls
  - Unemployment rate
  - Wage growth (Average Hourly Earnings)
  - Initial jobless claims trend
  - JOLTS (Job Openings and Labor Turnover)

#### C. Currency & Commodities
- [ ] **US Dollar:**
  - DXY (Dollar Index) trend and levels
  - Major pairs: EUR/USD, USD/JPY, USD/CNY
  - Reasons for strength/weakness

- [ ] **Commodities:**
  - Gold price and trend
  - Oil (WTI, Brent) and energy prices
  - Copper (economic bellwether)
  - Agricultural commodities if notable moves

#### D. Geopolitical & Policy Risks
- [ ] **Geopolitical Events:**
  - US-China relations and trade tensions
  - Middle East conflicts and impacts
  - Russia-Ukraine developments
  - Taiwan tensions

- [ ] **Fiscal Policy:**
  - Government spending bills and infrastructure
  - Debt ceiling issues
  - Tax policy changes

- [ ] **Regulatory Changes:**
  - AI regulation updates
  - Energy policy changes
  - Financial sector regulations

#### E. Market Sentiment & Positioning
- [ ] **Equity Markets:**
  - S&P 500, Nasdaq trends
  - Sector rotation patterns
  - VIX (volatility) levels

- [ ] **Credit Markets:**
  - Credit spreads widening/tightening
  - High yield default rates

- [ ] **Positioning Data:**
  - CFTC Commitment of Traders (if relevant)
  - Fund flows (equity, bond, money market)
  - Investor sentiment surveys (AAII, etc.)

### Step 3: Sector-Specific Macro Impacts

For each sector in the current portfolio, analyze macro impacts:

#### Power & Utilities (AEP, DUK, GEV)
- [ ] Electricity demand trends (EIA data)
- [ ] Natural gas prices and storage levels
- [ ] Renewable energy policy updates
- [ ] Data center power demand news
- [ ] Grid reliability and weather events

#### Semiconductors & Testing (TER, FORM)
- [ ] Global chip demand indicators (SEMI, SIA data)
- [ ] Memory pricing (DRAM, HBM)
- [ ] CapEx spending by major chipmakers (TSMC, Samsung, Intel)
- [ ] AI chip demand updates
- [ ] Supply chain bottlenecks or resolutions

#### Data Centers & REITs (DLR)
- [ ] REIT interest rate sensitivity
- [ ] Data center leasing trends
- [ ] Cloud CapEx by hyperscalers (AMZN, MSFT, GOOGL)
- [ ] AI infrastructure investments

#### Precious Metals (GLD)
- [ ] Real interest rates (major driver)
- [ ] Central bank gold buying
- [ ] Safe haven demand triggers
- [ ] USD weakness/strength
- [ ] Jewelry and industrial demand

#### Nuclear & SMRs (SMR)
- [ ] Nuclear policy developments (US, global)
- [ ] Uranium prices
- [ ] DOE funding and support programs
- [ ] Nuclear reactor approvals

### Step 4: Research Sources

Use these tools and sources to gather data:

**Primary Tools:**
- WebSearch: For latest news and announcements
- WebFetch: For specific data from:
  - Federal Reserve (federalreserve.gov)
  - Bureau of Labor Statistics (bls.gov)
  - Bureau of Economic Analysis (bea.gov)
  - Energy Information Administration (eia.gov)
  - CME Group (cmegroup.com)
  - Trading Economics (tradingeconomics.com)
  - FRED (Federal Reserve Economic Data)

**News Sources:**
- Bloomberg, Reuters, Financial Times, Wall Street Journal
- CNBC, MarketWatch, Seeking Alpha
- Utility Dive, Data Center Dynamics (sector-specific)

### Step 5: Report Structure

Generate the report using this template (in Korean):

```markdown
# 거시경제 보고서
**보고서 작성일:** {YYYY-MM-DD}
**조사 기간:** {start_date} ~ {end_date}
**다음 업데이트:** {recommended_date}

---

## 요약

**주요 거시경제 변화:**
- [가장 중요한 거시경제 변화 3-5개 요약]

**포트폴리오 영향:**
- [이러한 거시경제 변화가 현재 보유 종목에 미치는 영향]

**리스크 수준:** [낮음 / 중간 / 높음 / 심각]
- 근거: [1-2문장]

---

## 1. 통화정책 및 금리

### A. 연방준비제도 정책
- **현재 연준 기준금리:** [금리]
- **최근 결정사항:** [요약]
- **시장 전망:** [다음 회의 확률]
- **주요 발언:** [연준 관계자 주요 발언]

### B. 글로벌 중앙은행
- [ECB, BoJ, PBoC 업데이트]

### C. 수익률 곡선 및 채권 시장
- **10년물 국채:** [수익률 및 추세]
- **2년-10년 스프레드:** [수치 및 해석]
- **실질 수익률:** [금, 성장주에 미치는 영향]

**포트폴리오 영향:**
- [현재 금리 환경에서 수혜/피해를 받는 종목]

---

## 2. 인플레이션 및 경제 성장

### A. 인플레이션 지표
| 지표 | 최신 | 이전 | 전년대비 | 추세 |
|------|------|------|---------|------|
| CPI (헤드라인) | | | | |
| CPI (근원) | | | | |
| PCE (근원) | | | | |
| PPI | | | | |

### B. 성장 지표
| 지표 | 최신 | 이전 | 컨센서스 | 신호 |
|------|------|------|---------|------|
| GDP 성장률 | | | | |
| 제조업 PMI | | | | |
| 서비스업 PMI | | | | |
| 실업률 | | | | |

**포트폴리오 영향:**
- [성장/인플레이션이 보유 종목에 미치는 영향 분석]

---

## 3. 통화 및 원자재

### A. 미국 달러
- **DXY 수준:** [수치]
- **추세:** [강세/약세]
- **동인:** [움직이는 이유]

### B. 주요 원자재
| 원자재 | 가격 | 변동 (14일) | 변동 (30일) | 영향 |
|--------|------|------------|------------|------|
| 금 | | | | GLD |
| 유가 (WTI) | | | | GEV, 전력주 |
| 천연가스 | | | | AEP, DUK |
| 구리 | | | | 경제 지표 |

**포트폴리오 영향:**
- **GLD:** [직접 영향 분석]
- **전력 섹터:** [AEP, DUK, GEV에 대한 연료비 영향]

---

## 4. 지정학 및 정책 리스크

### A. 현재 핫스팟
- [날짜 및 영향과 함께 주요 지정학적 이벤트 나열]

### B. 정책 발전사항
- [재정 부양, 인프라, 세제 변화]
- [AI 규제, 에너지 정책]

### C. 리스크 평가
| 리스크 | 확률 | 실현 시 영향 | 포트폴리오 헤지 |
|--------|------|-------------|---------------|
| [리스크 1] | [낮음/중간/높음] | [설명] | [수혜 종목] |
| [리스크 2] | [낮음/중간/높음] | [설명] | [수혜 종목] |

---

## 5. 섹터별 거시경제 인사이트

### 전력 및 유틸리티 (AEP, DUK, GEV)
**거시경제 동인:**
- 전력 수요 증가: [데이터]
- 천연가스 가격: [영향]
- 기상 패턴: [수요에 영향을 미치는 극단적 기후]
- 규제 환경: [업데이트]

**투자 논리 점검:**
- ✅ **강화됨:** [개선된 동인이 있는 경우]
- ⚠️ **약화됨:** [악화된 동인이 있는 경우]
- 🔄 **변화 없음:** [안정적 요인]

### 반도체 테스트 (TER, FORM)
**거시경제 동인:**
- 글로벌 칩 수요: [SEMI 데이터, fab 가동률]
- 메모리 가격: [HBM, DRAM 추세]
- AI CapEx: [하이퍼스케일러 지출]

**투자 논리 점검:**
- [위와 동일한 형식]

### 데이터센터 (DLR)
**거시경제 동인:**
- REIT에 대한 금리 영향: [분석]
- 클라우드/AI CapEx: [추세]
- 캡레이트: [압축/확장]

**투자 논리 점검:**
- [위와 동일한 형식]

### 귀금속 (GLD)
**거시경제 동인:**
- 실질 수익률: [주요 요인]
- 달러 강세: [역상관관계]
- 지정학 프리미엄: [안전자산 수요]
- 중앙은행 매입: [톤수]

**투자 논리 점검:**
- [위와 동일한 형식]

### 원자력 (SMR)
**거시경제 동인:**
- 에너지 정책: [원자력 지원]
- 우라늄 가격: [섹터 건전성 지표]
- 자금 조달 환경: [DOE, 민간 자본]

**투자 논리 점검:**
- [위와 동일한 형식]

---

## 6. 시장 심리 및 포지셔닝

### A. 주식 시장 추세
- **S&P 500:** [수준, % 변화, 추세]
- **나스닥:** [수준, % 변화, AI/기술주 심리]
- **VIX:** [수준, 해석]
- **섹터 로테이션:** [주도/후행 섹터]

### B. 펀드 플로우
- 주식 펀드: [유입/유출]
- 채권 펀드: [유입/유출]
- 머니마켓 펀드: [수준 - 대기 자금 지표]

### C. 심리 지표
- AAII 강세/약세 스프레드: [수치]
- 풋/콜 비율: [해석]

---

## 7. 거시경제 트리거 및 경고

**향후 14일 관찰 대상:**

| 날짜 | 이벤트 | 중요도 | 포트폴리오 영향 |
|------|--------|--------|----------------|
| [날짜] | FOMC 회의 | 높음 | 전체 보유종목 |
| [날짜] | CPI 발표 | 높음 | GLD, 금리 민감 종목 |
| [날짜] | 고용 보고서 | 중간 | 성장 지표 |
| [날짜] | [섹터 이벤트] | 중간 | [특정 종목] |

**시나리오 계획:**

### 시나리오 1: 경착륙 (경기침체)
- **확률:** [%]
- **확인 지표:** [이를 확인할 수 있는 지표]
- **포트폴리오 대응:**
  - 수혜: [GLD, 유틸리티 (방어주)]
  - 피해: [SMR, 경기순환주]
  - 조치: [GLD 증액, SMR 감액]

### 시나리오 2: 연착륙
- **확률:** [%]
- **확인 지표:** [이를 확인할 수 있는 지표]
- **포트폴리오 대응:** [분석]

### 시나리오 3: 노 랜딩 (경제 회복력 유지)
- **확률:** [%]
- **확인 지표:** [이를 확인할 수 있는 지표]
- **포트폴리오 대응:** [분석]

### 시나리오 4: 인플레이션 재가속
- **확률:** [%]
- **확인 지표:** [이를 확인할 수 있는 지표]
- **포트폴리오 대응:** [분석]

---

## 8. 거시경제 기반 포트폴리오 권고사항

### A. 거시경제 기반 즉각 조치
- [ ] **익스포저 증가:** [어떤 종목, 이유]
- [ ] **익스포저 감소:** [어떤 종목, 이유]
- [ ] **헤지 추가:** [거시경제 리스크가 높은 경우]
- [ ] **변경 없음:** [거시경제가 현재 논리를 지지하는 경우]

### B. 거시경제 기반 DCA 조정
| 종목 | 현재 DCA | 거시경제 조정 DCA | 이유 |
|------|---------|-----------------|------|
| [티커] | $X | $Y | [거시경제 순풍/역풍] |

### C. 거시경제 변화로 인한 새로운 기회
- [거시경제 조사에서 발견된 새로운 투자 아이디어]

---

## 9. 요약 및 다음 단계

### 핵심 요점
1. [가장 중요한 거시경제 인사이트]
2. [두 번째로 중요한 것]
3. [세 번째로 중요한 것]

### 거시경제와 포트폴리오 정렬
- **유리한 포지션:** [현재 거시경제와 정렬된 종목]
- **도전 받는 종목:** [거시경제 역풍을 받는 종목]
- **헤지된 부분:** [주요 리스크로부터 포트폴리오가 보호되는 방식]

### 실행 항목
1. [즉각 조치가 있는 경우]
2. [모니터링 작업]
3. [다음 보고서를 위한 조사]

### 다음 보고서 초점
- [다음 거시경제 업데이트에서 특히 주의할 사항]
- [상황을 바꿀 수 있는 예정된 이벤트]

---

## 10. 출처 및 링크

### 데이터 출처
- [접근 날짜와 함께 모든 데이터 출처 나열]

### 주요 기사 및 보고서
- [제목](URL) - 날짜 - 요약
- [제목](URL) - 날짜 - 요약

### 사용된 도구
- FRED: [특정 차트 링크]
- CME FedWatch: [링크]
- Trading Economics: [링크]

---

**보고서 생성일:** {timestamp}
**다음 업데이트 예정일:** {14일 후 날짜}
**신뢰도 수준:** [높음/중간/낮음] - 데이터 가용성 및 명확성 기반
```

### Step 6: Analysis Guidelines

When analyzing macro data (write ALL analysis in Korean):

1. **객관적으로 작성:** 데이터를 있는 그대로 보고하고, 불확실성이 있는 경우 명시
2. **변화에 집중:** 이전 보고서와 달라진 점을 강조
3. **포트폴리오와 연결:** 거시경제 인사이트를 항상 특정 보유 종목과 연결
4. **가능한 한 수치화:** 숫자, 백분율, 구체적 수준 사용
5. **출처 인용:** 모든 주장은 날짜와 함께 출처 제시
6. **충돌 표시:** 서로 다른 지표가 상충되는 신호를 줄 때 명시
7. **확률 업데이트:** 기본 비율과 최근 데이터를 사용하여 시나리오 확률 추정
8. **촉매제 식별:** 거시경제 상황을 바꿀 수 있는 구체적 이벤트는 무엇인가?

### Step 7: Quality Checks

Before finalizing the report:

- [ ] All major macro categories covered (monetary, fiscal, growth, inflation, geopolitical)
- [ ] Every holding in portfolio has macro impact analysis
- [ ] At least 10 credible sources cited with dates
- [ ] Data tables are complete and formatted correctly
- [ ] Scenario analysis includes probabilities and triggers
- [ ] Specific action items are clear and actionable
- [ ] Next update date is set
- [ ] File saved as `REPORT_{YYYY-MM-DD}.md` in `investment/macro/reports/`

---

## Execution Checklist

**⚠️ CRITICAL: Write the entire report in Korean (한국어)**

When you run this script:

1. [ ] Set today's date and filename (REPORT_{YYYY-MM-DD}.md)
2. [ ] Use WebSearch to gather latest macro news (last 14 days)
3. [ ] Use WebFetch to pull specific data from Fed, BLS, BEA, EIA websites
4. [ ] Compile all data into the report template **IN KOREAN**
5. [ ] Analyze impact on each portfolio holding **IN KOREAN**
6. [ ] Generate scenario probabilities **IN KOREAN**
7. [ ] Create actionable recommendations **IN KOREAN**
8. [ ] Cite all sources with dates (source titles can be in English, but descriptions in Korean)
9. [ ] Save report to `investment/macro/reports/REPORT_{date}.md`
10. [ ] Verify entire report is in Korean before saving

---

## Notes for AI Agents

- **Language:** Write the ENTIRE report in Korean (한국어). All headings, analysis, tables, and recommendations must be in Korean.
- **Time Sensitivity:** Macro data becomes stale quickly. Always use the most recent data available.
- **Source Quality:** Prefer official sources (Fed, BLS, BEA) over news articles when possible.
- **Disambiguation:** When data is conflicting (e.g., strong jobs but weak PMI), note the conflict explicitly (in Korean).
- **Portfolio Context:** This is not a general macro report—every insight should connect to investment decisions for the specific holdings (AEP, DUK, GEV, TER, FORM, DLR, GLD, SMR).
- **Uncertainty:** It's better to say "불확실함" or "데이터가 혼재되어 있음" than to force a conclusion.
- **Triggers:** Identify specific levels or events that would change the investment thesis (e.g., "만약 10년물 수익률이 5%를 돌파한다면...").

---

## Version History

- **v1.0** (2026-01-12): Initial script created
- Future updates: Track changes to research methodology or template

---

**Last Updated:** 2026-01-12
**Maintained By:** Investment Analysis System
**Review Frequency:** Monthly (update script if macro environment shifts significantly)

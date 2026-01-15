# Decision Quality & Continuous Learning System - Usage Guide
**목적:** 체계적 의사결정 및 지속적 학습을 통한 투자 성과 개선

---

## Quick Reference: Make Commands

```bash
# 포트폴리오 분석
make macro-report      # 거시경제 리포트 생성
make checklist         # 포트폴리오 체크리스트 실행
make final-report      # 최종 통합 리포트 생성
make all               # 위 3개 순차 실행

# 의사결정 품질
make new-decision      # 새 Pre-Decision 체크리스트 (대화형)
make list-decisions    # Pre-Decision 체크리스트 목록

# 결정 추적
make log-decision      # 결정 기록 (대화형)
make show-log          # 결정 로그 요약
make update-returns    # 수익률 자동 업데이트
make check-reviews     # 리뷰 필요한 결정 확인

# 학습 및 분석
make quarterly-review  # 분기별 리뷰 생성
make analyze-decisions # 결정 로그 분석
make calibration-check # Expected Return 정확도 체크
make pattern-analysis  # 패턴 분석

# 설정 및 유틸리티
make setup             # 디렉토리 구조 생성
make setup-learning    # 학습 시스템 초기화
make check             # 필수 파일 확인
make info              # 현재 설정 표시
make guide             # 빠른 시작 가이드
make help              # 전체 도움말
```

---

## System Overview

이 시스템은 세 가지 핵심 컴포넌트로 구성됩니다:

1. **Pre-Decision Checklist** - 중요한 결정 전 편향 방지 및 품질 검증
2. **Decision Log** - 모든 결정 추적 및 결과 기록
3. **Quarterly Review** - 분기별 패턴 분석 및 프레임워크 개선

```
┌─────────────────────────────────────────────────────────────┐
│                    Investment Workflow                       │
└─────────────────────────────────────────────────────────────┘
                             │
                             ▼
              ┌──────────────────────────┐
              │   중요 결정 필요?        │
              │  (비중 ±5%p 이상)       │
              └──────────┬───────────────┘
                         │ YES
                         ▼
              ┌──────────────────────────┐
              │  Pre-Decision Checklist   │◄─── Item #6
              │  (PRE_DECISION_CHECKLIST  │
              │   .md 작성)               │
              └──────────┬───────────────┘
                         │
                         ▼
              ┌──────────────────────────┐
              │   7/7 통과?              │
              └──────────┬───────────────┘
                    YES  │  NO → 보류/수정
                         ▼
              ┌──────────────────────────┐
              │   결정 실행              │
              └──────────┬───────────────┘
                         │
                         ▼
              ┌──────────────────────────┐
              │   Decision Log 기록      │◄─── Item #10
              │  (decision_log.jsonl에   │
              │   항목 추가)              │
              └──────────┬───────────────┘
                         │
                 ┌───────┴────────┐
                 │                │
            1개월 후          6개월 후
                 │                │
                 ▼                ▼
        ┌────────────┐  ┌────────────────┐
        │ 중간 점검   │  │  최종 결과 기록 │
        │ 실제 수익률 │  │  판정 및 교훈   │
        └────────────┘  └────────┬───────┘
                                 │
                            분기말 │
                                 ▼
                     ┌───────────────────┐
                     │ Quarterly Review   │◄─── Item #10
                     │ 패턴 분석          │
                     │ 프레임워크 개선     │
                     └───────┬───────────┘
                             │
                             ▼
                     ┌───────────────────┐
                     │ 개선사항 적용      │
                     │ 다음 분기 시작     │
                     └───────────────────┘
```

---

## Part 1: Pre-Decision Checklist 사용법

### When to Use

다음 조건 중 **하나라도** 충족 시 필수:
- ✅ 단일 종목 비중 ±5%p 이상 조정
- ✅ $10,000 이상 또는 포트폴리오 5% 이상 투입/매도
- ✅ 신규 종목 진입
- ✅ 논리 상태 2단계 이상 변화 (INTACT → WEAKENING 등)
- ✅ 감정적 동요 느낌 (FOMO, 패닉, 조급함)

### Step-by-Step Process

#### Step 1: 체크리스트 복사
```bash
cd /Users/gimseon-u/Desktop/Projects/blog/investment

# 새로운 결정용 파일 생성
cp checklist/PRE_DECISION_CHECKLIST.md \
   decisions/pre_decision/PRE_DECISION_2026-01-14_GEV_INCREASE.md
```

#### Step 2: 체크리스트 작성

파일을 열고 모든 섹션 완료:

**PART 1: 기본 정보**
```markdown
**결정 ID:** 2026-01-14-GEV-INCREASE
**날짜:** 2026-01-14
**시간:** 10:30

**결정 내용:**
종목: GEV
현재 비중: 8%
목표 비중: 10%
변화: +2%p
금액: $5,000
실행 방법: DCA 조정

**현재 심리 상태:**
- [x] 평온함 (정상)
- [ ] 흥분/기대감
- [ ] 불안/공포
- [ ] 조급함

**시장 환경:**
- VIX: 15.06
- 최근 7일 포트폴리오: +2.5%
- 최근 7일 S&P 500: +1.8%
- 해당 종목 최근 7일: +3.2%
```

**PART 2: 인지 편향 체크**

각 편향을 순차적으로 체크:

```markdown
### 2.1 앵커링 편향
- [x] ✅ 아니오 - 장기 데이터 기반 판단

### 2.2 확증 편향
- [ ] ⚠️ 예 - 다음을 수행하시오:

**Steel Man 반론:**
1. "80GW 백로그는 허수가 많을 수 있다. MOU는 구속력 없음"
2. "높은 Forward PE (48x)는 이미 모든 호재를 반영"
3. "전력 수요 증가가 늦어지면 2030년 납품이 지연될 수 있음"

**반론에 대한 답변:**
1. Q4 earnings에서 백로그 중 확정 계약 비율 공개 예정. 지금까지 트랙 레코드 양호
2. 맞음. 그래서 목표 비중을 10%로 제한. 더 높이지 않음
3. 가능성 있음. 그래서 Exit Trigger로 "2GW 이상 계약 취소" 설정

**판정:** Yes - 반박 충분히 강력
```

**중요**: 각 편향을 정직하게 체크. 스스로 속이지 말 것!

**PART 3: 정보 품질 검증**
```markdown
**Tier 1 출처 목록:**
1. GEV Q3 Earnings Call Transcript - 2025-11-05
2. Bloomberg article on 80GW backlog - 2026-01-10
3. SEC Form 8-K capacity expansion filing - 2026-01-08

**판정:** Tier 1 출처 2개 이상? [Yes]
```

**PART 4-9**: 계속 작성...

#### Step 3: 최종 판정
```markdown
## PART 9: 최종 판정

**필수 항목:**
- [x] 인지 편향 체크 통과
- [x] Tier 1 출처 2개 이상
- [x] 논리 상태 판정 타당
- [x] Expected Return 기준 충족 (+18% > 15%)
- [x] Exit Plan 수립 완료
- [x] 포트폴리오 한도 내 (최대 종목 16% < 20%)
- [x] 수면 테스트 통과

**총점:** 7/7 항목 통과

**판정:** ✅ 실행 승인

**실행 날짜:** 2026-01-14
**실행 방법:** DCA $60/day → $80/day로 증액
**모니터링:** 백로그 변화, Q4 earnings (2026-01-28)
**재검토 일자:** 2026-02-14 (1개월 후)
```

#### Step 4: 파일 저장
```bash
# 완료된 체크리스트 저장
# decisions/pre_decision/ 디렉토리에 보관
```

---

## Part 2: Decision Log 사용법

### When to Record

**모든** 중요 결정 후 즉시 기록:
- Pre-Decision Checklist를 통과한 모든 결정
- 비중 ±3%p 이상 조정
- 신규 진입/청산

### Recording Process

#### Method 1: Manual JSONL Entry

`decision_log.jsonl` 파일에 한 줄 추가:

```jsonl
{"decision_id":"2026-01-14-GEV-INCREASE","date":"2026-01-14","time":"10:30","ticker":"GEV","action":"INCREASE","from_weight":8.0,"to_weight":10.0,"change_pct":2.0,"amount_usd":5000,"execution_method":"DCA","logic_status":"STRONGER","valuation":"EXPENSIVE","expected_return_pct":18,"expected_return_bear":-20,"expected_return_base":15,"expected_return_bull":45,"prob_bear":20,"prob_base":50,"prob_bull":30,"core_thesis":"80GW backlog sustained, 2030 capacity selling out by end of 2026","evidence_tier1_count":3,"pre_decision_score":"7/7","psychological_state":"calm","vix":15.06,"portfolio_ytd":2.5,"stock_7d":3.2,"exit_trigger_logic":"Backlog cancellation >10GW or >2 consecutive quarters of decline","exit_trigger_price":-15,"exit_trigger_time":"6 months no progress on 2029-2030 orders","actual_return_1mo":null,"actual_return_3mo":null,"actual_return_6mo":null,"actual_return_12mo":null,"outcome_1mo":null,"outcome_6mo":null,"was_correct":null,"lessons_learned":null,"review_date_1mo":"2026-02-14","review_date_6mo":"2026-07-14"}
```

**Tips:**
- 한 줄에 하나의 JSON 객체
- 줄바꿈 없음 (위는 설명을 위해 보기 좋게 표시)
- `null` 값은 나중에 업데이트

#### Method 2: Python Script

```python
import json
from datetime import datetime, timedelta

def add_decision(
    ticker, action, from_weight, to_weight, amount,
    logic_status, valuation, expected_return,
    core_thesis, pre_decision_score, psychological_state
):
    decision = {
        "decision_id": f"{datetime.now().strftime('%Y-%m-%d')}-{ticker}-{action}",
        "date": datetime.now().strftime('%Y-%m-%d'),
        "time": datetime.now().strftime('%H:%M'),
        "ticker": ticker,
        "action": action,
        "from_weight": from_weight,
        "to_weight": to_weight,
        "change_pct": to_weight - from_weight,
        "amount_usd": amount,
        "execution_method": "DCA",  # or "LUMP_SUM", "SELL"
        "logic_status": logic_status,
        "valuation": valuation,
        "expected_return_pct": expected_return,
        # ... (fill other fields)
        "core_thesis": core_thesis,
        "pre_decision_score": pre_decision_score,
        "psychological_state": psychological_state,
        # Tracking fields
        "actual_return_1mo": None,
        "actual_return_6mo": None,
        "was_correct": None,
        "lessons_learned": None,
        "review_date_1mo": (datetime.now() + timedelta(days=30)).strftime('%Y-%m-%d'),
        "review_date_6mo": (datetime.now() + timedelta(days=180)).strftime('%Y-%m-%d'),
    }

    # Append to JSONL
    with open('decisions/decision_log.jsonl', 'a') as f:
        f.write(json.dumps(decision) + '\n')

    print(f"✅ Decision logged: {decision['decision_id']}")
    return decision

# Usage:
add_decision(
    ticker="GEV",
    action="INCREASE",
    from_weight=8.0,
    to_weight=10.0,
    amount=5000,
    logic_status="STRONGER",
    valuation="EXPENSIVE",
    expected_return=18,
    core_thesis="80GW backlog sustained, 2030 capacity selling out",
    pre_decision_score="7/7",
    psychological_state="calm"
)
```

#### Method 3: Markdown Table Update

`DECISION_LOG.md` 파일의 "활성 결정" 테이블에 행 추가:

```markdown
| 2026-01-14-GEV-INC | 2026-01-14 | GEV | 8%→10% | STRONGER | +18% | 7/7 | ⏳ | ⏳ | 🔄 |
```

### Tracking Updates

#### 1개월 후 (2026-02-14):

```python
import json
import yfinance as yf

def update_1mo_return(decision_id):
    # Read all decisions
    decisions = []
    with open('decisions/decision_log.jsonl', 'r') as f:
        for line in f:
            d = json.loads(line)
            decisions.append(d)

    # Find and update
    for d in decisions:
        if d['decision_id'] == decision_id:
            ticker = yf.Ticker(d['ticker'])
            hist = ticker.history(start=d['date'], period='1mo')
            actual_return = (hist['Close'].iloc[-1] / hist['Close'].iloc[0] - 1) * 100
            d['actual_return_1mo'] = round(actual_return, 2)

            # Outcome judgment
            if actual_return >= d['expected_return_pct'] * 0.8:
                d['outcome_1mo'] = 'BETTER'
            elif actual_return >= d['expected_return_pct'] * 0.5:
                d['outcome_1mo'] = 'AS_EXPECTED'
            else:
                d['outcome_1mo'] = 'WORSE'

    # Rewrite file
    with open('decisions/decision_log.jsonl', 'w') as f:
        for d in decisions:
            f.write(json.dumps(d) + '\n')

update_1mo_return("2026-01-14-GEV-INCREASE")
```

#### 6개월 후 (2026-07-14):

Similar process, but update:
- `actual_return_6mo`
- `outcome_6mo` (SUCCESS/PARTIAL/FAILURE)
- `was_correct` (true/false)
- `lessons_learned` (text description)

---

## Part 3: Quarterly Review 사용법

### When to Execute

분기 종료 후 2주 이내:
- Q1: 2026-04-15
- Q2: 2026-07-15
- Q3: 2026-10-15
- Q4: 2027-01-15

### Review Process

#### Step 1: 데이터 준비

```python
import json
import pandas as pd
import matplotlib.pyplot as plt

# Load decision log
decisions = []
with open('decisions/decision_log.jsonl', 'r') as f:
    for line in f:
        decisions.append(json.loads(line))

df = pd.DataFrame(decisions)

# Filter for completed decisions (6 months passed)
df['date'] = pd.to_datetime(df['date'])
today = pd.Timestamp.now()
df_completed = df[df['date'] <= today - pd.Timedelta(days=180)]

print(f"Total decisions: {len(df)}")
print(f"Completed (6mo+): {len(df_completed)}")
```

#### Step 2: 템플릿 복사 및 분석

```bash
# Copy template
cp learning/QUARTERLY_REVIEW_TEMPLATE.md \
   learning/QUARTERLY_REVIEW_2026_Q1.md
```

템플릿을 열고 각 섹션 작성:

**Part 1: 결정 품질 분석**

```python
# 1.1 전체 성과
success_rate = (df_completed['outcome_6mo'] == 'SUCCESS').mean() * 100
partial_rate = (df_completed['outcome_6mo'] == 'PARTIAL').mean() * 100
failure_rate = (df_completed['outcome_6mo'] == 'FAILURE').mean() * 100

print(f"SUCCESS: {success_rate:.1f}%")
print(f"PARTIAL: {partial_rate:.1f}%")
print(f"FAILURE: {failure_rate:.1f}%")

# 1.2 Expected Return 정확도
df_completed['er_error'] = df_completed['actual_return_6mo'] - df_completed['expected_return_pct']
mean_error = df_completed['er_error'].mean()

print(f"Mean ER error: {mean_error:.1f}%")
print("Overconfident" if mean_error < 0 else "Underconfident")

# Calibration chart
plt.figure(figsize=(10, 6))
plt.scatter(df_completed['expected_return_pct'],
            df_completed['actual_return_6mo'],
            alpha=0.6)
plt.plot([0, 50], [0, 50], 'r--', label='Perfect Calibration')
plt.xlabel('Expected Return (%)')
plt.ylabel('Actual Return 6mo (%)')
plt.title('Calibration Check')
plt.legend()
plt.savefig('learning/calibration_2026_Q1.png')
```

**Part 2: 논리 상태 분석**

```python
# LOGIC STRONGER 성공률
stronger = df_completed[df_completed['logic_status'] == 'STRONGER']
stronger_success = (stronger['was_correct'] == True).mean() * 100

print(f"LOGIC STRONGER success rate: {stronger_success:.1f}%")

# 논리 상태별 평균 수익률
by_logic = df_completed.groupby('logic_status')['actual_return_6mo'].agg(['mean', 'median', 'count'])
print(by_logic)
```

**Part 3-8**: 계속 분석...

#### Step 3: 패턴 발견 및 개선사항 도출

**예시 발견:**
```markdown
## 핵심 발견

1. **LOGIC STRONGER + EXPENSIVE 조합이 예상보다 좋지 않음**
   - 6건 중 2건만 SUCCESS (33%)
   - 평균 수익률 8% (Expected 18% 대비 -10%p 차이)
   - 원인: 밸류에이션 신호를 무시함

2. **VIX <12 환경에서 신규 진입이 위험**
   - 4건 모두 FAILURE
   - 시장 과열 시그널 무시

3. **excited 심리 상태에서의 결정이 취약**
   - 성공률 40% vs calm 80%
   - FOMO 편향 발생
```

**개선사항 제안:**
```markdown
## 프레임워크 수정 제안

### 수정 1: LOGIC STRONGER + EXPENSIVE 규칙 강화

**현재 규칙:**
"LOGIC STRONGER + Expected Return <15%: 비중 증액 금지"

**수정 제안:**
"LOGIC STRONGER + EXPENSIVE (PE > 섹터평균 × 1.5):
 - Expected Return >25% 필요 (기존 15%에서 상향)
 - 최대 비중 5% 제한 (기존 10%)
 - 6개월 이내 재평가 필수"

**근거:**
- Q1 데이터: 이 조합의 실제 수익률이 Expected보다 평균 10%p 낮음
- 밸류에이션 리스크를 과소평가하는 경향

**예상 효과:**
- 향후 유사 실수 방지
- Risk-adjusted return 개선
```

#### Step 4: 프레임워크 업데이트

```bash
# INVESTMENT_CHECKLIST.md 수정
# 변경사항 명시
# 버전 업데이트 (v1.0 → v1.1)
```

#### Step 5: 리뷰 완료 및 다음 분기 계획

```markdown
## 다음 분기 계획 (2026 Q2)

### 집중 개선 영역:
1. **밸류에이션 discipline** - EXPENSIVE 종목 매수 신중화
2. **심리 관리** - excited 상태 시 24시간 대기 엄격 적용
3. **시장 타이밍** - VIX <12 시 신규 진입 제한

### A/B 테스트:
**실험: EXPENSIVE 종목 비중 한도**
- 가설: 한도를 5%로 낮추면 risk-adjusted return 개선
- 방법: Q2 동안 EXPENSIVE 종목 최대 5% 준수
- 측정: Q2말 vs Q1 비교
```

---

## Part 4: 실전 예시 (Complete Workflow)

### Example: DLR 축소 결정 (2026-01-13)

#### 상황:
- DLR 현재 비중: 15%
- BofA 다운그레이드: $210 → $170
- 논리 상태: WEAKENING
- 제안: 15% → 10% 축소

#### Step 1: Pre-Decision Checklist

```bash
cp checklist/PRE_DECISION_CHECKLIST.md \
   decisions/pre_decision/PRE_DECISION_2026-01-13_DLR_DECREASE.md
```

체크리스트 작성:

```markdown
**결정 ID:** 2026-01-13-DLR-DECREASE
**날짜:** 2026-01-13
**시간:** 14:00

**현재 심리 상태:**
- [ ] 평온함
- [ ] 흥분/기대감
- [x] 불안/공포  ⚠️ 주의!
- [ ] 조급함

→ 불안 상태이므로 인지 편향 체크 강화 필요

### 2.4 손실 회피 편향
- [ ] ⚠️ 예 - 다음을 수행하시오:

**Sunk Cost 확인:**
현재 손익: -8%, 금액: -$3,200

**제로베이스 질문:**
"내가 DLR를 보유하지 않았다면, 지금 이 가격에 살 것인가?"
→ [x] No → 매도 타당

**최악 시나리오:**
지금 손절하지 않고 추가 하락 시:
-20% 추가 하락 → 총 손실 -28% = -$11,200

→ Exit 타당함

...

**최종 판정:** 6/7 통과 (심리 상태 불안정)
**조건부 승인:** 24시간 대기 후 재확인
```

#### Step 2: 24시간 대기 (Required)

```markdown
**대기 기간:** 2026-01-14 14:00까지

**재평가 (24시간 후):**
- 심리 상태: Calm으로 회복
- 논리 재확인: WEAKENING 판정 여전히 유효
- 추가 뉴스: Deutsche Bank도 목표가 하향

**최종 판정:** ✅ 실행 승인 (7/7)
```

#### Step 3: Decision Log 기록

```jsonl
{"decision_id":"2026-01-13-DLR-DECREASE","date":"2026-01-13","time":"14:00","ticker":"DLR","action":"DECREASE","from_weight":15.0,"to_weight":10.0,"change_pct":-5.0,"amount_usd":-8000,"execution_method":"SELL","logic_status":"WEAKENING","valuation":"FAIR","expected_return_pct":5,"expected_return_bear":-20,"expected_return_base":5,"expected_return_bull":20,"prob_bear":30,"prob_base":50,"prob_bull":20,"core_thesis":"BofA downgrade, growth constraints confirmed","evidence_tier1_count":2,"pre_decision_score":"7/7","psychological_state":"anxious_then_calm","vix":15.06,"portfolio_ytd":2.5,"stock_7d":-5.2,"exit_trigger_logic":"Further analyst downgrades or earnings miss","exit_trigger_price":-15,"exit_trigger_time":"3 months no stabilization","actual_return_1mo":null,"actual_return_3mo":null,"actual_return_6mo":null,"actual_return_12mo":null,"outcome_1mo":null,"outcome_6mo":null,"was_correct":null,"lessons_learned":null,"review_date_1mo":"2026-02-13","review_date_6mo":"2026-07-13"}
```

#### Step 4: 1개월 후 (2026-02-13)

```python
# Actual: DLR -2% (from decision date)
# Expected: +5%
# Judgment: WORSE (but correct direction - would have been -7% if held 15%)

update_1mo_return("2026-01-13-DLR-DECREASE")
```

#### Step 5: 6개월 후 (2026-07-13)

```python
# Actual: DLR +3% (from decision date)
# Expected: +5%
# Judgment: PARTIAL

# Update lessons learned:
d['lessons_learned'] = """
WEAKENING 판정이 정확했음. 축소가 옳은 결정.
다만 PAUSE가 아닌 완전 청산도 고려할 수 있었음.
심리 상태(anxious)를 24시간 대기로 극복한 것은 효과적.
"""
```

#### Step 6: Quarterly Review에 포함 (2026-07-15)

```markdown
## 가장 성공적인 결정 Top 3

### 2위: 2026-01-13-DLR-DECREASE (-5%p)

**무엇을 했는가:**
DLR 15% → 10% 축소, WEAKENING 판정에 따라

**왜 성공했는가:**
- 논리 약화 신호를 조기 포착 (BofA 다운그레이드)
- 심리 상태(불안)를 인지하고 24시간 대기로 극복
- 손실 회피 편향을 체크리스트로 극복

**재현 가능한 패턴:**
- WEAKENING 판정 시 즉시 일부 축소 (전량 청산 아님)
- 불안 상태 시 24시간 대기 규칙 효과적
- 제로베이스 질문 유용: "지금 살 것인가?"

**프레임워크 반영:**
→ WEAKENING 판정 기준을 더 명확히 정의 필요
→ 심리 상태 불안 시 자동 24시간 대기 규칙 강화
```

---

## Part 5: Automation Scripts

### Script 1: Daily Return Update

`scripts/daily_update.py`:
```python
#!/usr/bin/env python3
"""
Run daily: Update returns for all pending decisions
Usage: python scripts/daily_update.py
"""
import json
import yfinance as yf
from datetime import datetime, timedelta

def main():
    # Load decisions
    decisions = []
    with open('decisions/decision_log.jsonl', 'r') as f:
        for line in f:
            decisions.append(json.loads(line))

    today = datetime.now()
    updated_count = 0

    for d in decisions:
        decision_date = datetime.strptime(d['date'], '%Y-%m-%d')
        days_passed = (today - decision_date).days

        # Update 1mo return
        if 25 <= days_passed <= 35 and d['actual_return_1mo'] is None:
            try:
                ticker = yf.Ticker(d['ticker'])
                hist = ticker.history(start=d['date'], period='1mo')
                if len(hist) > 0:
                    ret = (hist['Close'].iloc[-1] / hist['Close'].iloc[0] - 1) * 100
                    d['actual_return_1mo'] = round(ret, 2)
                    updated_count += 1
                    print(f"✅ Updated 1mo return for {d['decision_id']}: {ret:.1f}%")
            except Exception as e:
                print(f"❌ Error updating {d['decision_id']}: {e}")

        # Update 6mo return
        if 175 <= days_passed <= 185 and d['actual_return_6mo'] is None:
            try:
                ticker = yf.Ticker(d['ticker'])
                hist = ticker.history(start=d['date'], period='6mo')
                if len(hist) > 0:
                    ret = (hist['Close'].iloc[-1] / hist['Close'].iloc[0] - 1) * 100
                    d['actual_return_6mo'] = round(ret, 2)

                    # Judgment
                    if ret >= d['expected_return_pct'] * 0.8:
                        d['outcome_6mo'] = 'SUCCESS'
                    elif ret >= d['expected_return_pct'] * 0.5:
                        d['outcome_6mo'] = 'PARTIAL'
                    else:
                        d['outcome_6mo'] = 'FAILURE'

                    updated_count += 1
                    print(f"✅ Updated 6mo return for {d['decision_id']}: {ret:.1f}% → {d['outcome_6mo']}")
            except Exception as e:
                print(f"❌ Error updating {d['decision_id']}: {e}")

    # Save updated log
    with open('decisions/decision_log.jsonl', 'w') as f:
        for d in decisions:
            f.write(json.dumps(d) + '\n')

    print(f"\n📊 Updated {updated_count} decisions")

if __name__ == '__main__':
    main()
```

Setup cron job:
```bash
# Run daily at 6 AM
crontab -e

# Add line:
0 6 * * * cd /Users/gimseon-u/Desktop/Projects/blog/investment && python3 scripts/daily_update.py
```

### Script 2: Monthly Reminder

`scripts/monthly_reminder.py`:
```python
#!/usr/bin/env python3
"""
Run monthly: Check for decisions needing review
Usage: python scripts/monthly_reminder.py
"""
import json
from datetime import datetime

def main():
    decisions = []
    with open('decisions/decision_log.jsonl', 'r') as f:
        for line in f:
            decisions.append(json.loads(line))

    today = datetime.now()
    need_review_1mo = []
    need_review_6mo = []

    for d in decisions:
        # 1 month reviews
        if d['outcome_1mo'] is None:
            review_date = datetime.strptime(d['review_date_1mo'], '%Y-%m-%d')
            if today >= review_date:
                need_review_1mo.append(d)

        # 6 month reviews
        if d['outcome_6mo'] is None:
            review_date = datetime.strptime(d['review_date_6mo'], '%Y-%m-%d')
            if today >= review_date:
                need_review_6mo.append(d)

    if need_review_1mo:
        print(f"\n⏰ {len(need_review_1mo)} decisions need 1-month review:")
        for d in need_review_1mo:
            print(f"  - {d['decision_id']}: {d['ticker']} {d['action']}")
            print(f"    Expected: {d['expected_return_pct']}%, Actual: {d.get('actual_return_1mo', 'N/A')}%\n")

    if need_review_6mo:
        print(f"\n⚠️  {len(need_review_6mo)} decisions need 6-month FINAL review:")
        for d in need_review_6mo:
            print(f"  - {d['decision_id']}: {d['ticker']} {d['action']}")
            print(f"    Expected: {d['expected_return_pct']}%, Actual: {d.get('actual_return_6mo', 'N/A')}%")
            print(f"    📝 Add lessons_learned to decision log\n")

if __name__ == '__main__':
    main()
```

---

## Part 6: Best Practices

### ✅ DO:

1. **Be Honest** - 모든 결정을 정직하게 기록 (실패도!)
2. **Be Immediate** - 결정 당일에 기록 (기억 왜곡 방지)
3. **Be Thorough** - Pre-Decision Checklist 스킵하지 말 것
4. **Be Consistent** - 모든 중요 결정에 동일한 프로세스 적용
5. **Be Systematic** - 정기적으로 업데이트 및 리뷰

### ❌ DON'T:

1. **Don't Rationalize** - 사후 합리화 금지
2. **Don't Cherry-Pick** - 성공만 기록하고 실패 숨기기 금지
3. **Don't Skip** - "이번만"은 없음
4. **Don't Batch** - 여러 결정을 한꺼번에 나중에 기록 금지
5. **Don't Ignore** - 분기 리뷰에서 발견한 개선사항 무시 금지

---

## Part 7: Troubleshooting

### Q: 체크리스트가 너무 길어서 부담됩니다.
**A:** 간소화 버전 사용:
- 필수 항목만: 인지 편향, 정보 품질, Exit Plan
- 5분 안에 완료 가능
- 중요: 스킵하지는 말 것!

### Q: Decision Log를 수동으로 기록하기 번거롭습니다.
**A:** Python 스크립트 사용:
```python
# Quick add function
from add_decision import quick_add

quick_add("GEV", "INCREASE", 8, 10, "STRONGER", "EXPENSIVE", 18)
```

### Q: 결과 추적을 잊어버립니다.
**A:** 자동화 + 리마인더:
- Cron job으로 daily_update.py 자동 실행
- Calendar에 1mo/6mo 리뷰 일정 등록
- 스마트폰 알림 설정

### Q: Quarterly Review가 너무 복잡합니다.
**A:** 핵심만 추출:
1. LOGIC STRONGER 성공률 (가장 중요!)
2. Expected Return 정확도
3. Top 3 성공/실패 사례
4. 1개 개선사항 도출

→ 1시간이면 충분

---

## Part 8: Success Metrics

시스템이 효과적으로 작동하는지 측정:

### 3개월 후:
- [ ] Decision Log에 최소 10개 결정 기록됨
- [ ] Pre-Decision Checklist를 최소 5회 사용함
- [ ] 인지 편향으로 인한 충동적 결정이 줄어듦

### 6개월 후:
- [ ] 첫 번째 Quarterly Review 완료
- [ ] LOGIC STRONGER 예측 정확도 측정 가능
- [ ] 1개 이상의 프레임워크 개선 적용

### 12개월 후:
- [ ] Expected Return 예측이 calibrated됨 (평균 오차 <5%)
- [ ] 심리 상태 'calm'에서의 결정이 80% 이상
- [ ] 포트폴리오 수익률이 S&P 500 대비 개선

---

**Remember:**
> "Perfect decisions are impossible.
> But systematic improvement through learning is guaranteed."

이 시스템은 완벽한 투자를 만들지 못합니다.
하지만 **지속적으로 더 나은** 투자자로 만들어줍니다.

시작하세요. 오늘부터.

---

## Appendix: Make Commands 상세 레퍼런스

### 📊 Portfolio Analysis Commands

#### `make macro-report`

**목적:** 거시경제 환경 분석 리포트 생성

**작동 방식:**
1. `setup` 타겟 실행 (디렉토리 생성)
2. PORTFOLIO.csv에서 보유 종목 목록 추출
3. Claude CLI를 호출하여 WebSearch로 최신 거시경제 데이터 수집:
   - Federal Reserve, BLS, BEA, EIA
   - Bloomberg, Reuters, WSJ, FT
   - Trading Economics, FRED
4. 한국어로 된 거시경제 리포트 생성

**출력:**
```
macro/reports/REPORT_YYYY-MM-DD.md
```

**포함 내용:**
- 통화정책 및 금리
- 인플레이션 및 경제 성장
- 통화 및 원자재
- 지정학 및 정책 리스크
- 섹터별 거시경제 인사이트
- 시장 심리 및 포지셔닝
- 거시경제 기반 포트폴리오 권고사항

**사용 예:**
```bash
make macro-report
# → macro/reports/REPORT_2026-01-15.md 생성
```

---

#### `make checklist`

**목적:** 개별 종목 투자 체크리스트 분석

**작동 방식:**
1. `setup` 타겟 실행
2. PORTFOLIO.csv에서 종목 목록 읽기
3. `checklist/investment_checklist.md` 프레임워크 참조
4. 이전 리포트들(`checklist/history/REPORT_*.md`) 비교
5. Claude CLI로 각 종목의 최신 뉴스, 실적, 애널리스트 의견 수집
6. 각 종목에 대해 분석:
   - Logic Status (STRONGER/INTACT/WEAKENING/BROKEN)
   - Valuation (UNDERVALUED/FAIR/OVERVALUED/EXPENSIVE)
   - Expected Return (12개월 확률가중)
   - DCA 조정 권고

**출력:**
```
checklist/history/REPORT_YYYY-MM-DD.md
```

**사용 예:**
```bash
make checklist
# → checklist/history/REPORT_2026-01-15.md 생성
```

---

#### `make final-report`

**목적:** 거시경제 + 체크리스트 통합 리포트 생성

**작동 방식:**
1. 오늘 날짜의 macro report 존재 확인
2. 오늘 날짜의 checklist report 존재 확인
3. 두 리포트를 읽어 통합 분석
4. Executive Summary, Action Plan, Risk Assessment 포함 최종 리포트 생성

**전제조건:**
- `macro/reports/REPORT_YYYY-MM-DD.md` 존재
- `checklist/history/REPORT_YYYY-MM-DD.md` 존재
- 없으면 에러 메시지와 함께 종료

**출력:**
```
checklist/history/FINAL_REPORT_YYYY-MM-DD.md
```

**사용 예:**
```bash
# 개별 실행 (먼저 macro-report와 checklist 실행 필요)
make macro-report
make checklist
make final-report

# 또는 전체 워크플로우
make all
```

---

#### `make all`

**목적:** 전체 포트폴리오 분석 워크플로우 실행

**작동 방식:**
```
macro-report → checklist → final-report
```
순차적으로 실행

**출력:**
1. `macro/reports/REPORT_YYYY-MM-DD.md`
2. `checklist/history/REPORT_YYYY-MM-DD.md`
3. `checklist/history/FINAL_REPORT_YYYY-MM-DD.md`

**사용 예:**
```bash
make all
# 3개 리포트 모두 생성
```

---

### 🎯 Decision Quality Commands

#### `make new-decision`

**목적:** 대화형 Pre-Decision 체크리스트 생성

**작동 방식:**
1. 사용자에게 티커와 액션 입력 요청:
   - Ticker (예: GEV)
   - Action (INCREASE/DECREASE/NEW_ENTRY/EXIT)
2. Claude CLI를 대화형 모드로 실행
3. 9개 PART를 순차적으로 진행:
   - PART 1: 기본 정보 (시장 데이터 자동 조사)
   - PART 2: 인지 편향 체크 (대화형)
   - PART 3: 정보 품질 검증 (자동 조사)
   - PART 4: 투자 논리 검증 (대화형)
   - PART 5: 밸류에이션 검증 (자동 조사 + 대화형)
   - PART 6: Pre-Mortem (대화형)
   - PART 7: 포트폴리오 영향 (자동 계산)
   - PART 8: Contrarian Agent (AI가 반대 논거 제시)
   - PART 9: 최종 점수 (자동 계산)

**출력:**
```
decisions/pre_decision/PRE_DECISION_YYYY-MM-DD_TICKER_ACTION.md
```

**사용 예:**
```bash
make new-decision
# 입력: GEV, INCREASE
# → decisions/pre_decision/PRE_DECISION_2026-01-15_GEV_INCREASE.md 생성
```

---

#### `make list-decisions`

**목적:** Pre-Decision 체크리스트 목록 표시

**작동 방식:**
1. `decisions/pre_decision/` 디렉토리 확인
2. `.md` 파일들을 최신순으로 정렬
3. 상위 10개 표시

**출력:** 터미널에 목록 표시

**사용 예:**
```bash
make list-decisions
# 출력:
#   decisions/pre_decision/PRE_DECISION_2026-01-15_JPM_NEW_ENTRY.md (Jan 15)
#   decisions/pre_decision/PRE_DECISION_2026-01-14_GEV_INCREASE.md (Jan 14)
```

---

### 📝 Decision Tracking Commands

#### `make log-decision`

**목적:** 실행한 결정을 Decision Log에 기록

**작동 방식:**
1. 대화형으로 다음 정보 입력:
   - Ticker, Action
   - From/To weight (%)
   - Amount (USD)
   - Logic Status, Valuation
   - Expected Return (%)
   - Core Thesis (한 줄)
   - Pre-Decision Score
   - Psychological State
   - VIX level
2. Python으로 JSONL 엔트리 생성
3. `decisions/decision_log.jsonl`에 추가
4. 1개월/6개월 후 리뷰 날짜 자동 계산

**출력:**
```
decisions/decision_log.jsonl (한 줄 추가)
```

**필드 목록:**
- `decision_id`: YYYY-MM-DD-TICKER-ACTION
- `date`, `time`: 결정 날짜/시간
- `ticker`, `action`: 종목/액션
- `from_weight`, `to_weight`, `change_pct`: 비중 변화
- `amount_usd`: 금액
- `logic_status`, `valuation`: 상태
- `expected_return_pct`: 예상 수익률
- `core_thesis`: 핵심 논리
- `pre_decision_score`: 체크리스트 점수
- `psychological_state`: 심리 상태
- `vix`: VIX 레벨
- `actual_return_1mo`, `actual_return_6mo`: 실제 수익률 (나중에 업데이트)
- `outcome_1mo`, `outcome_6mo`: 결과 판정
- `was_correct`: 정답 여부
- `lessons_learned`: 교훈
- `review_date_1mo`, `review_date_6mo`: 리뷰 예정일

**사용 예:**
```bash
make log-decision
# 대화형 입력 후 → decision_log.jsonl에 기록
```

---

#### `make show-log`

**목적:** Decision Log 요약 표시

**작동 방식:**
1. `decision_log.jsonl` 파일 읽기
2. 총 결정 수, 완료된 결정 수, 대기 중인 결정 수 계산
3. 최근 5개 결정 표시

**출력:** 터미널에 요약 표시

**사용 예:**
```bash
make show-log
# 출력:
# Total decisions: 15
# Completed (6mo+): 8
# Pending: 7
#
# Recent decisions:
#   ⏳ 2026-01-15 JPM NEW_ENTRY (ER: 11%)
#   ✅ 2025-07-10 GEV INCREASE (ER: 18%)
```

---

#### `make update-returns`

**목적:** yfinance를 사용해 실제 수익률 자동 업데이트

**작동 방식:**
1. `yfinance` 패키지 설치 확인
2. Decision Log의 모든 결정 순회
3. 결정일로부터 25-45일 경과: 1개월 수익률 업데이트
4. 결정일로부터 170-200일 경과: 6개월 수익률 업데이트
5. 판정 기준:
   - SUCCESS: 실제 >= 예상 × 0.8
   - PARTIAL: 실제 >= 예상 × 0.5
   - FAILURE: 그 외

**전제조건:**
```bash
pip3 install yfinance
```

**출력:** decision_log.jsonl 업데이트

**사용 예:**
```bash
make update-returns
# 출력:
# ✓ Updated 1mo: 2025-12-15-GEV-INCREASE = 8.2% → AS_EXPECTED
# ✓ Updated 6mo: 2025-07-10-DLR-DECREASE = 12.5% → SUCCESS
# 📊 Updated 3 decisions
```

---

#### `make check-reviews`

**목적:** 리뷰가 필요한 결정 확인

**작동 방식:**
1. Decision Log에서 각 결정의 `review_date_1mo`, `review_date_6mo` 확인
2. 리뷰 날짜가 지났지만 `outcome_1mo` 또는 `outcome_6mo`가 없는 결정 필터링
3. 리뷰 필요 목록 표시

**출력:** 터미널에 리뷰 필요 결정 표시

**사용 예:**
```bash
make check-reviews
# 출력:
# ⚠️  3 decisions need 1-month review:
#   - 2025-12-15-GEV-INCREASE (Expected: 18%)
#   → Run: make update-returns
#
# ⚠️  1 decisions need 6-month FINAL review:
#   - 2025-07-10-DLR-DECREASE (Expected: 5%)
#   📝 Actions needed:
#   1. Run: make update-returns
#   2. Add lessons_learned to each decision manually
```

---

### 📈 Learning & Analysis Commands

#### `make quarterly-review`

**목적:** 분기별 학습 리뷰 생성

**작동 방식:**
1. Decision Log에 결정이 있는지 확인
2. `QUARTERLY_REVIEW_TEMPLATE.md`를 `QUARTERLY_REVIEW_YYYY_QN.md`로 복사
3. 기본 분석 실행 (총 결정 수, 완료된 결정, 성공률)
4. 템플릿 파일 열기 (macOS에서 `open` 명령)

**전제조건:**
- 최소 5개의 완료된 결정 (6개월 경과) 권장

**출력:**
```
learning/QUARTERLY_REVIEW_YYYY_QN.md
```

**사용 예:**
```bash
make quarterly-review
# → learning/QUARTERLY_REVIEW_2026_Q1.md 생성 및 열기
```

---

#### `make analyze-decisions`

**목적:** Decision Log에 대한 통계 분석

**작동 방식:**
1. `pandas` 패키지 설치 확인
2. decision_log.jsonl을 DataFrame으로 로드
3. 분석 실행:
   - Overall Stats: 총 결정 수, 완료된 결정 수, 성공률, ER 오차
   - By Logic Status: 논리 상태별 Expected Return 평균
   - By Valuation: 밸류에이션별 Expected Return 평균
   - By Psychological State: 심리 상태별 Expected Return 평균

**전제조건:**
```bash
pip3 install pandas
```

**출력:** 터미널에 분석 결과 표시

**사용 예:**
```bash
make analyze-decisions
# 출력:
# === Overall Stats ===
# Total decisions: 15
# Completed (6mo+): 8
# Success rate: 62.5%
# Mean ER error: -3.2%
#
# === By Logic Status ===
#               count   mean
# STRONGER        5    22.4
# INTACT          8    12.3
# WEAKENING       2     5.5
```

---

#### `make calibration-check`

**목적:** Expected Return 예측 정확도 분석

**작동 방식:**
1. 완료된 결정 (6개월 경과)만 필터링
2. 예상 수익률 vs 실제 수익률 비교
3. ER Error (실제 - 예상) 계산
4. 판정:
   - Error < -5%: **OVERCONFIDENT** (과신)
   - Error > +5%: **UNDERCONFIDENT** (과소평가)
   - |Error| <= 5%: **WELL CALIBRATED** (잘 보정됨)
5. ER 범위별 (<0%, 0-15%, 15-30%, >30%) 오차 분석

**전제조건:**
- 최소 5개의 완료된 결정

**출력:** 터미널에 분석 결과 표시

**사용 예:**
```bash
make calibration-check
# 출력:
# Mean ER Error: -4.2%
# ✅ WELL CALIBRATED - Your predictions are accurate on average
#
# By ER Range:
#          count  mean
# <0%         1  -8.0
# 0-15%       4  -2.5
# 15-30%      2  -6.0
# >30%        1  -5.0
```

---

#### `make pattern-analysis`

**목적:** 결정 이력에서 패턴 발견

**작동 방식:**
1. 완료된 결정 (6개월 경과)만 필터링
2. 3가지 패턴 분석:
   - **Pattern 1: Logic + Valuation Combo**: 어떤 조합이 가장 좋은 성과?
   - **Pattern 2: Psychological State**: 어떤 심리 상태에서 결정이 좋았나?
   - **Pattern 3: Pre-Decision Score**: 점수별 성공률은?

**전제조건:**
- 최소 5개의 완료된 결정

**출력:** 터미널에 분석 결과 표시

**사용 예:**
```bash
make pattern-analysis
# 출력:
# === Pattern 1: Logic + Valuation Combo ===
#                         count   mean
# STRONGER + FAIR           3    18.5
# INTACT + UNDERVALUED      2    15.2
#
# === Pattern 2: Psychological State vs Actual Return ===
#                count   mean
# calm              6   12.5
# anxious           2    3.2
#
# === Pattern 3: Pre-Decision Score vs Success ===
# Success rate by score:
# 7/7    75.0
# 6/7    50.0
```

---

### 🔧 Setup & Utility Commands

#### `make setup`

**목적:** 필수 디렉토리 구조 생성

**작동 방식:**
```bash
mkdir -p macro/reports
mkdir -p checklist/history
mkdir -p decisions/pre_decision
mkdir -p decisions
mkdir -p learning
```

**사용 예:**
```bash
make setup
# ✓ Directories created
```

---

#### `make setup-learning`

**목적:** 학습 시스템 초기화

**작동 방식:**
1. `setup` 실행
2. `decisions/analysis/` 디렉토리 생성
3. `decision_log.jsonl` 파일 없으면 생성
4. `DECISION_LOG.md` 파일 없으면 생성

**사용 예:**
```bash
make setup-learning
# ✓ Learning system initialized
#
# Created:
#   - decisions/pre_decision/ (for pre-decision checklists)
#   - decisions/decision_log.jsonl (decision tracking)
#   - learning/ (quarterly reviews)
```

---

#### `make check`

**목적:** 필수 파일 존재 확인

**작동 방식:**
- PORTFOLIO.csv
- macro/MACRO_RESEARCH_SCRIPT.md
- checklist/investment_checklist.md
- checklist/history/ 디렉토리
- macro/reports/ 디렉토리

**사용 예:**
```bash
make check
# ✓ PORTFOLIO.csv (stocks: AEP,DUK,GEV,TER,FORM,DLR,GLD,SMR)
# ✓ macro/MACRO_RESEARCH_SCRIPT.md
# ✓ checklist/investment_checklist.md
# ✓ checklist/history exists
# ✓ macro/reports exists
```

---

#### `make info`

**목적:** 현재 설정 정보 표시

**작동 방식:**
변수 값들을 표시:
- Today, Portfolio File, Stocks
- Macro Script, Reports Dir
- Checklist File, History Dir
- Output Files 경로

**사용 예:**
```bash
make info
# Current Configuration:
#   Today: 2026-01-15
#   Portfolio File: PORTFOLIO.csv
#   Stocks: AEP,DUK,GEV,TER,FORM,DLR,GLD,SMR
#   ...
```

---

#### `make guide`

**목적:** 빠른 시작 가이드 표시

**작동 방식:**
기본 워크플로우 설명을 터미널에 출력

**사용 예:**
```bash
make guide
# Investment Analysis Quick Start Guide
# ...
```

---

#### `make help`

**목적:** 전체 명령어 도움말 표시

**작동 방식:**
모든 명령어를 카테고리별로 표시

**사용 예:**
```bash
make help
# 또는 그냥
make
```

---

#### `make clean`

**목적:** 임시 파일 정리

**현재 동작:**
리포트 파일은 보존하고, 임시 파일만 정리
(현재는 정리할 파일이 없음)

---

## Dependencies Summary

| 명령어 | 필요 패키지 |
|--------|------------|
| `update-returns` | `yfinance` |
| `analyze-decisions` | `pandas` |
| `calibration-check` | `pandas` |
| `pattern-analysis` | `pandas` |

**설치:**
```bash
pip3 install yfinance pandas
```

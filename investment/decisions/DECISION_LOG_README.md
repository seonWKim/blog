# Decision Log System
**목적:** 모든 투자 결정을 체계적으로 기록하고 추적하여 지속적 학습 가능

---

## 시스템 구조

```
/investment/decisions/
├── DECISION_LOG_README.md          (이 파일)
├── decision_log.jsonl               (기계 판독용 로그)
├── DECISION_LOG.md                  (사람 판독용 요약)
├── pre_decision/                    (사전 체크리스트 보관)
│   ├── PRE_DECISION_2026-01-14_GEV_INCREASE.md
│   ├── PRE_DECISION_2026-01-13_DLR_DECREASE.md
│   └── ...
└── analysis/                        (분석 결과)
    ├── accuracy_report_2026_Q1.md
    ├── pattern_analysis.md
    └── ...
```

---

## 사용 방법

### Step 1: 중요 결정 전 - Pre-Decision Checklist 실행
```bash
# PRE_DECISION_CHECKLIST.md 복사 후 작성
cp checklist/PRE_DECISION_CHECKLIST.md decisions/pre_decision/PRE_DECISION_[DATE]_[TICKER]_[ACTION].md

# 체크리스트 완료 후 최종 승인 시 Step 2로
```

### Step 2: 결정 실행 시 - Decision Log 기록
```bash
# decision_log.jsonl에 항목 추가 (기계 판독용)
# DECISION_LOG.md에 항목 추가 (사람 판독용)
```

### Step 3: 추적 기간 - 모니터링
```bash
# 정기적으로 Exit Trigger 확인
# 1개월 후 중간 점검
# 6개월 후 최종 결과 기록
```

### Step 4: 분기별 - 학습 및 개선
```bash
# Quarterly Review 실행
# 패턴 분석 및 프레임워크 개선
```

---

## JSONL 포맷 (decision_log.jsonl)

각 결정은 한 줄의 JSON 객체로 기록:

```jsonl
{"decision_id":"2026-01-14-GEV-INCREASE","date":"2026-01-14","time":"10:30","ticker":"GEV","action":"INCREASE","from_weight":8.0,"to_weight":10.0,"change_pct":2.0,"amount_usd":5000,"execution_method":"DCA","logic_status":"STRONGER","valuation":"EXPENSIVE","expected_return_pct":18,"expected_return_bear":-20,"expected_return_base":15,"expected_return_bull":45,"prob_bear":20,"prob_base":50,"prob_bull":30,"core_thesis":"80GW backlog sustained, 2030 capacity selling out","evidence_tier1_count":3,"pre_decision_score":"7/7","psychological_state":"calm","vix":15.06,"portfolio_ytd":2.5,"stock_7d":3.2,"exit_trigger_logic":"Backlog cancellation >10GW","exit_trigger_price":-15,"exit_trigger_time":"6 months no progress","actual_return_1mo":null,"actual_return_3mo":null,"actual_return_6mo":null,"actual_return_12mo":null,"outcome_1mo":null,"outcome_6mo":null,"was_correct":null,"lessons_learned":null,"review_date_1mo":"2026-02-14","review_date_6mo":"2026-07-14"}
```

### 필드 설명:

**기본 정보:**
- `decision_id`: 고유 ID (YYYY-MM-DD-TICKER-ACTION)
- `date`: 결정 날짜 (YYYY-MM-DD)
- `time`: 결정 시각 (HH:MM)
- `ticker`: 종목 심볼
- `action`: 행동 (INCREASE/DECREASE/NEW_ENTRY/EXIT/HOLD)

**포지션 정보:**
- `from_weight`: 이전 비중 (%)
- `to_weight`: 목표 비중 (%)
- `change_pct`: 변화량 (%p)
- `amount_usd`: 투입/회수 금액 ($)
- `execution_method`: 실행 방법 (DCA/LUMP_SUM/SELL)

**논리/밸류에이션:**
- `logic_status`: 논리 상태 (STRONGER/INTACT/WEAKENING/BROKEN)
- `valuation`: 밸류에이션 (UNDERVALUED/FAIR/OVERVALUED/EXPENSIVE)
- `expected_return_pct`: 확률가중 기대수익률 (%)
- `expected_return_bear`: Bear case 수익률 (%)
- `expected_return_base`: Base case 수익률 (%)
- `expected_return_bull`: Bull case 수익률 (%)
- `prob_bear`: Bear case 확률 (%)
- `prob_base`: Base case 확률 (%)
- `prob_bull`: Bull case 확률 (%)

**의사결정 품질:**
- `core_thesis`: 핵심 논리 (한 문장)
- `evidence_tier1_count`: Tier 1 출처 개수
- `pre_decision_score`: 사전 체크리스트 점수 (예: "7/7")
- `psychological_state`: 심리 상태 (calm/excited/anxious/rushed)

**시장 환경:**
- `vix`: VIX 수준
- `portfolio_ytd`: 포트폴리오 YTD 수익률 (%)
- `stock_7d`: 해당 종목 7일 수익률 (%)

**Exit Triggers:**
- `exit_trigger_logic`: 논리 붕괴 조건
- `exit_trigger_price`: 가격 손절 조건 (%)
- `exit_trigger_time`: 시간 제한 조건

**추적 결과 (나중에 업데이트):**
- `actual_return_1mo`: 1개월 후 실제 수익률 (%)
- `actual_return_3mo`: 3개월 후 실제 수익률 (%)
- `actual_return_6mo`: 6개월 후 실제 수익률 (%)
- `actual_return_12mo`: 12개월 후 실제 수익률 (%)
- `outcome_1mo`: 1개월 판정 (BETTER/AS_EXPECTED/WORSE)
- `outcome_6mo`: 6개월 판정 (SUCCESS/PARTIAL/FAILURE)
- `was_correct`: 최종 판정 (true/false/pending)
- `lessons_learned`: 교훈 (텍스트)

**재검토 일정:**
- `review_date_1mo`: 1개월 후 점검 날짜
- `review_date_6mo`: 6개월 후 점검 날짜

---

## Markdown 포맷 (DECISION_LOG.md)

사람이 읽기 쉬운 테이블 형식:

| Decision ID | Date | Ticker | Action | 논리 | ER | Pre-Check | 1mo | 6mo | 최종 |
|------------|------|--------|--------|------|-----|-----------|-----|-----|------|
| 2026-01-14-GEV-INC | 2026-01-14 | GEV | 8%→10% | STRONGER | +18% | 7/7 | ✅ +5% | ⏳ | ⏳ |
| 2026-01-13-DLR-DEC | 2026-01-13 | DLR | 15%→10% | WEAKENING | +5% | 7/7 | ⏳ | ⏳ | ⏳ |

**범례:**
- ER = Expected Return
- Pre-Check = Pre-Decision Score
- ✅ = 예상보다 좋음
- ✔️ = 예상대로
- ❌ = 예상보다 나쁨
- ⏳ = 아직 평가 안 됨

---

## 분석 쿼리 (Python 예제)

### 기본 로딩:
```python
import json
import pandas as pd
from datetime import datetime

# JSONL 로드
decisions = []
with open('decision_log.jsonl', 'r') as f:
    for line in f:
        decisions.append(json.loads(line))

df = pd.DataFrame(decisions)
```

### 분석 예제:

#### 1. 정확도 분석
```python
# LOGIC STRONGER 예측의 정확도
stronger = df[df['logic_status'] == 'STRONGER']
stronger_correct = stronger[stronger['was_correct'] == True]
accuracy = len(stronger_correct) / len(stronger) * 100
print(f"LOGIC STRONGER accuracy: {accuracy:.1f}%")

# Expected Return vs Actual Return
df['er_error'] = df['actual_return_6mo'] - df['expected_return_pct']
print(f"Mean ER error: {df['er_error'].mean():.1f}%")
print(f"Median ER error: {df['er_error'].median():.1f}%")
```

#### 2. 심리 상태별 성과
```python
# 심리 상태별 평균 수익률
by_psych = df.groupby('psychological_state')['actual_return_6mo'].mean()
print("\n심리 상태별 평균 수익률:")
print(by_psych.sort_values(ascending=False))
```

#### 3. Pre-Decision Score별 성과
```python
# 체크리스트 점수가 높을수록 좋은가?
df['score'] = df['pre_decision_score'].str.split('/').str[0].astype(int)
corr = df[['score', 'actual_return_6mo']].corr()
print(f"\nPre-Decision Score vs Return 상관관계: {corr.iloc[0,1]:.3f}")
```

#### 4. 시장 환경별 성과
```python
# VIX 수준별 성과
df['vix_level'] = pd.cut(df['vix'], bins=[0, 15, 25, 100], labels=['Low', 'Normal', 'High'])
by_vix = df.groupby('vix_level')['actual_return_6mo'].mean()
print("\nVIX 수준별 평균 수익률:")
print(by_vix)
```

#### 5. 논리 상태별 성공률
```python
# 각 논리 상태의 성공률
success_by_logic = df.groupby('logic_status')['was_correct'].apply(
    lambda x: (x == True).sum() / len(x) * 100
)
print("\n논리 상태별 성공률:")
print(success_by_logic.sort_values(ascending=False))
```

#### 6. 밸류에이션별 성과
```python
# EXPENSIVE 종목도 살 만한가?
by_valuation = df.groupby('valuation')['actual_return_6mo'].agg(['mean', 'median', 'count'])
print("\n밸류에이션별 수익률:")
print(by_valuation)
```

#### 7. Overconfidence 체크
```python
# Expected Return이 높을수록 실제로도 높은가?
import matplotlib.pyplot as plt

plt.scatter(df['expected_return_pct'], df['actual_return_6mo'])
plt.plot([0, 50], [0, 50], 'r--')  # 완벽한 예측선
plt.xlabel('Expected Return (%)')
plt.ylabel('Actual Return 6mo (%)')
plt.title('Calibration Check')
plt.show()

# Overconfidence 측정
overconfident = df[df['expected_return_pct'] > df['actual_return_6mo']]
print(f"\nOverconfident 비율: {len(overconfident)/len(df)*100:.1f}%")
```

#### 8. Exit Trigger 효과
```python
# Exit Trigger를 잘 설정했는가?
triggered = df[df['outcome_6mo'] == 'FAILURE']
print("\n실패한 결정들의 Exit Trigger 발동 여부:")
print(triggered[['ticker', 'exit_trigger_logic', 'lessons_learned']])
```

---

## 자동화 스크립트

### 1. 매일 추적 (daily_update.py)
```python
#!/usr/bin/env python3
"""
매일 실행: Decision Log의 pending 항목들 가격 업데이트
"""
import json
import yfinance as yf
from datetime import datetime, timedelta

def update_returns():
    decisions = []
    with open('decision_log.jsonl', 'r') as f:
        for line in f:
            decisions.append(json.loads(line))

    today = datetime.now()
    updated = []

    for d in decisions:
        decision_date = datetime.strptime(d['date'], '%Y-%m-%d')
        days_passed = (today - decision_date).days

        # 1개월 (30일) 후 업데이트
        if days_passed >= 30 and d['actual_return_1mo'] is None:
            ticker = yf.Ticker(d['ticker'])
            hist = ticker.history(start=d['date'], end=today)
            if len(hist) > 0:
                return_1mo = (hist['Close'].iloc[-1] / hist['Close'].iloc[0] - 1) * 100
                d['actual_return_1mo'] = round(return_1mo, 2)

        # 6개월 (180일) 후 업데이트
        if days_passed >= 180 and d['actual_return_6mo'] is None:
            ticker = yf.Ticker(d['ticker'])
            hist = ticker.history(start=d['date'], end=today)
            if len(hist) > 0:
                return_6mo = (hist['Close'].iloc[-1] / hist['Close'].iloc[0] - 1) * 100
                d['actual_return_6mo'] = round(return_6mo, 2)

                # 판정
                if return_6mo >= d['expected_return_pct'] * 0.8:
                    d['outcome_6mo'] = 'SUCCESS'
                elif return_6mo >= d['expected_return_pct'] * 0.5:
                    d['outcome_6mo'] = 'PARTIAL'
                else:
                    d['outcome_6mo'] = 'FAILURE'

        updated.append(d)

    # 업데이트된 로그 저장
    with open('decision_log.jsonl', 'w') as f:
        for d in updated:
            f.write(json.dumps(d) + '\n')

    print(f"Updated {len(updated)} decisions")

if __name__ == '__main__':
    update_returns()
```

### 2. 월간 리마인더 (monthly_reminder.py)
```python
#!/usr/bin/env python3
"""
매월 1일 실행: 1개월 된 결정들 재검토 리마인더
"""
import json
from datetime import datetime, timedelta

def check_reviews():
    decisions = []
    with open('decision_log.jsonl', 'r') as f:
        for line in f:
            decisions.append(json.loads(line))

    today = datetime.now()
    need_review = []

    for d in decisions:
        review_date = datetime.strptime(d['review_date_1mo'], '%Y-%m-%d')
        if today >= review_date and d['outcome_1mo'] is None:
            need_review.append(d)

    if need_review:
        print(f"\n⚠️  {len(need_review)} 결정들이 1개월 재검토 필요:")
        for d in need_review:
            print(f"  - {d['decision_id']}: {d['ticker']} {d['action']}")
            print(f"    Expected: {d['expected_return_pct']}%, Actual: {d['actual_return_1mo']}%")
            print()

if __name__ == '__main__':
    check_reviews()
```

---

## 모범 사례 (Best Practices)

### ✅ DO:
1. **모든 중요 결정을 기록** - 비중 ±5%p 이상 변경은 필수
2. **즉시 기록** - 결정 당일에 기록 (기억은 빠르게 왜곡됨)
3. **정직하게 기록** - 실패도 솔직히 기록 (학습이 목적)
4. **정기적으로 업데이트** - 1개월/6개월 시점 체크
5. **분기별 분석** - 패턴 찾기 및 프레임워크 개선

### ❌ DON'T:
1. **사후 합리화 금지** - 결과를 알고 나서 기록 수정 금지
2. **체리피킹 금지** - 성공만 기록하고 실패 숨기기 금지
3. **너무 복잡하게** - 기록이 부담되면 안 함 (간단하게 유지)
4. **결과만 추적** - 과정(논리, 심리)도 중요
5. **일회성 기록** - 지속적 추적이 핵심

---

## 빠른 시작 (Quick Start)

1. **첫 결정 기록하기:**
```bash
# decision_log.jsonl 파일 생성
touch decision_log.jsonl

# 첫 항목 추가 (템플릿 사용)
# 아래 템플릿을 복사하고 값을 채워서 한 줄로 추가
```

2. **템플릿:**
```json
{"decision_id":"YYYY-MM-DD-TICKER-ACTION","date":"YYYY-MM-DD","time":"HH:MM","ticker":"TICKER","action":"ACTION","from_weight":0.0,"to_weight":0.0,"change_pct":0.0,"amount_usd":0,"execution_method":"METHOD","logic_status":"STATUS","valuation":"VALUATION","expected_return_pct":0,"expected_return_bear":0,"expected_return_base":0,"expected_return_bull":0,"prob_bear":0,"prob_base":0,"prob_bull":0,"core_thesis":"THESIS","evidence_tier1_count":0,"pre_decision_score":"X/7","psychological_state":"STATE","vix":0.0,"portfolio_ytd":0.0,"stock_7d":0.0,"exit_trigger_logic":"CONDITION","exit_trigger_price":0,"exit_trigger_time":"TIME","actual_return_1mo":null,"actual_return_3mo":null,"actual_return_6mo":null,"actual_return_12mo":null,"outcome_1mo":null,"outcome_6mo":null,"was_correct":null,"lessons_learned":null,"review_date_1mo":"YYYY-MM-DD","review_date_6mo":"YYYY-MM-DD"}
```

3. **Python 로드 테스트:**
```python
import json
with open('decision_log.jsonl', 'r') as f:
    for line in f:
        d = json.loads(line)
        print(f"Decision: {d['decision_id']}")
        print(f"Ticker: {d['ticker']}, Action: {d['action']}")
        print(f"Expected Return: {d['expected_return_pct']}%")
```

---

**Remember:**
> "The goal is not perfection. The goal is progress through systematic learning."

이 시스템은 당신을 더 나은 투자자로 만드는 것이 목적입니다.

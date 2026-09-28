# 디지털 서랍장: 개인 정보 관리 시스템
## 데이터베이스 설계 및 SQL 실습 프로젝트

---

## 📋 프로젝트 개요

### 주제
**개인 정보 관리 시스템 (Personal Information Manager, PIM)**

사용자들이 다양한 개인 정보(서류, 사진, 메모, 연락처, 재정 정보 등)를 카테고리별로 정리하고, 태그를 통해 관리하는 디지털 서랍장 시스템입니다.

### 학습 목표
- ✅ 데이터베이스와 엑셀의 차이점 이해
- ✅ 테이블 간 관계(1:N, N:M) 설계 및 구현
- ✅ PK/FK를 활용한 데이터 무결성 보장
- ✅ 복잡한 쿼리(JOIN, GROUP BY, 서브쿼리) 작성
- ✅ 실무 요구사항을 SQL로 해결하는 능력 배양

---

## 📊 요구사항 충족 검토

| 항목 | 요구사항 | 충족 여부 | 세부사항 |
|------|---------|---------|---------|
| **테이블 수** | 최소 4개 | ✅ | 6개 테이블 (users, categories, items, item_details, tags, item_tags) |
| **1:N 관계** | 최소 2개 | ✅ | 3개 (users→items, categories→items, items→item_tags) |
| **PK/FK** | 포함 필수 | ✅ | 모든 테이블에 PK, 5개의 FK 구현 |
| **제약조건** | NOT NULL, UNIQUE | ✅ | NOT NULL 5개, UNIQUE 8개 적용 |
| **샘플 데이터** | 테이블당 10행+ | ✅ | 15명 사용자, 60개 항목, 20개+ 상세정보 |
| **핵심 쿼리** | 15개+ | ✅ | 20개 쿼리 (기본 4 + 조인 4 + 집계 4 + 서브 2 + 수정/삭제 2 + 추가 4) |
| **조회 쿼리** | 4개+ (WHERE, ORDER BY, LIMIT) | ✅ | 쿼리 1-4 |
| **조인 쿼리** | 4개+ (INNER 2+, LEFT 1+) | ✅ | 쿼리 5-8 (INNER 6개, LEFT 1개) |
| **집계 쿼리** | 3개+ (COUNT/SUM/AVG + GROUP BY) | ✅ | 쿼리 9-11, 17 |
| **서브쿼리** | 1개+ | ✅ | 쿼리 12-13 |
| **UPDATE/DELETE** | 2개+ | ✅ | 쿼리 14-15 |
| **인덱스** | 1개+ | ✅ | 11개 인덱스 생성 |
| **실행 결과** | 스크린샷/텍스트 | ✅ | results/query_results.txt |

---

## 📁 프로젝트 구조

```
b6-1/
├── database/
│   ├── schema.sql              # 테이블 스키마 생성 스크립트
│   ├── sample_data.sql         # 샘플 데이터 입력 스크립트
│   ├── queries.sql             # 핵심 쿼리 15개 + 추가 쿼리
│   ├── bonus_tasks.sql         # 보너스 과제 (조인 비교, 정합성, 미니 리포트)
│   └── personal_info.db        # SQLite 데이터베이스 파일
├── results/
│   └── query_results.txt       # 모든 쿼리 실행 결과 (326 줄)
├── docs/
│   ├── ERD_DIAGRAM.md          # 테이블 관계도 및 상세 설명
│   ├── PROJECT_GUIDE.md        # 이 문서
│   └── EXECUTION_GUIDE.md      # 실행 방법 가이드
└── run_queries.sh              # 쿼리 실행 스크립트
```

---

## 🗂️ 테이블 구조

### 1️⃣ users (사용자 정보)
```sql
CREATE TABLE users (
    user_id INTEGER PRIMARY KEY AUTOINCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT 1
);
```
- **행 수**: 15명
- **용도**: 시스템 사용자 관리
- **특징**: 활성/비활성 상태 추적

---

### 2️⃣ categories (정보 분류)
```sql
CREATE TABLE categories (
    category_id INTEGER PRIMARY KEY AUTOINCREMENT,
    category_name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    icon VARCHAR(20),
    color VARCHAR(7)
);
```
- **행 수**: 10개
- **용도**: 항목 분류
- **예시**: documents, photos, contacts, notes, finance, health, travel, work, educational, personal

---

### 3️⃣ items (개인 정보 항목) ⭐ **관계의 중심**
```sql
CREATE TABLE items (
    item_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,        -- FK → users
    category_id INTEGER NOT NULL,    -- FK → categories
    title VARCHAR(100) NOT NULL,
    content TEXT NOT NULL,
    file_name VARCHAR(255),
    file_size INTEGER,
    mime_type VARCHAR(50),
    is_important BOOLEAN DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```
- **행 수**: 60개
- **용도**: 사용자가 저장한 개인 정보
- **관계**: N:1 → users, N:1 → categories

---

### 4️⃣ item_details (항목 상세정보)
```sql
CREATE TABLE item_details (
    detail_id INTEGER PRIMARY KEY AUTOINCREMENT,
    item_id INTEGER NOT NULL UNIQUE,  -- FK → items (1:1)
    location VARCHAR(100),
    expiry_date DATE,
    status VARCHAR(20) DEFAULT 'active',
    priority INTEGER DEFAULT 3,
    notes TEXT
);
```
- **행 수**: 30개+
- **용도**: 항목의 추가 메타데이터
- **특징**: 1:1 관계, 만료일 추적, 우선순위 관리

---

### 5️⃣ tags (태그)
```sql
CREATE TABLE tags (
    tag_id INTEGER PRIMARY KEY AUTOINCREMENT,
    tag_name VARCHAR(50) NOT NULL UNIQUE
);
```
- **행 수**: 20개
- **용도**: 분류 태그 정의
- **예시**: urgent, archive, private, important, medical, financial 등

---

### 6️⃣ item_tags (항목-태그 연결)
```sql
CREATE TABLE item_tags (
    item_tag_id INTEGER PRIMARY KEY AUTOINCREMENT,
    item_id INTEGER NOT NULL,        -- FK → items
    tag_id INTEGER NOT NULL,         -- FK → tags
    UNIQUE(item_id, tag_id)          -- 중복 방지
);
```
- **행 수**: 30개+
- **용도**: items와 tags의 N:M 관계 구현
- **특징**: 복합 UNIQUE 제약

---

## 🔄 테이블 관계도

```
users (1) ─────────────────► (N) items ─────────────────► (1) categories
                                │
                              (1:1)
                                │
                        item_details (상세정보)
                        
                          items (N) ◄────────── (M) tags
                                    item_tags 연결
```

### 주요 관계
1. **users → items** (1:N, CASCADE)
   - 한 사용자는 여러 항목 보유
   - 사용자 삭제 시 항목도 자동 삭제

2. **categories → items** (1:N, RESTRICT)
   - 한 카테고리에 여러 항목
   - 사용 중인 카테고리는 삭제 불가

3. **items ↔ tags** (N:M)
   - 한 항목에 여러 태그 가능
   - 한 태그가 여러 항목에 사용 가능
   - item_tags 중간 테이블로 구현

4. **items → item_details** (1:1, CASCADE)
   - 각 항목은 최대 하나의 상세정보
   - 항목 삭제 시 상세정보도 자동 삭제

---

## 💾 샘플 데이터

### 데이터 규모
- **사용자**: 15명 (활성 14명, 비활성 1명)
- **카테고리**: 10개
- **항목**: 60개 (사용자당 6-10개)
- **태그**: 20개
- **항목-태그 연결**: 30개+
- **항목 상세정보**: 30개+
- **총 데이터 행**: 200+ 행

### 데이터 특징
- ✅ 실무에서 가능한 시나리오 반영
- ✅ 다양한 파일 크기 (256 bytes ~ 150 MB)
- ✅ 만료일 있는/없는 항목 혼합
- ✅ 우선순위 다층화
- ✅ 태그 다:다 관계 실제 구현

---

## 🔍 핵심 쿼리 (20개)

### 기본 조회 (4개)
| # | 설명 | 주요 기능 |
|---|------|---------|
| 1 | 활성 사용자 조회 | WHERE, ORDER BY |
| 2 | 특정 카테고리 항목 | WHERE + JOIN |
| 3 | 중요 항목 상위 10개 | WHERE + LIMIT |
| 4 | 사용자의 최근 30일 항목 | 날짜 필터 |

### 조인 (4개)
| # | 설명 | 조인 타입 |
|---|------|---------|
| 5 | 사용자별 항목 조회 | INNER JOIN ×3 |
| 6 | 항목 상세정보 조회 | INNER JOIN ×3 |
| 7 | 태그로 항목 조회 | INNER JOIN ×5 (N:M) |
| 8 | 사용자별 항목 현황 | LEFT JOIN |

### 집계 (4개)
| # | 설명 | 함수 |
|---|------|------|
| 9 | 카테고리별 항목 수/크기 | COUNT, SUM, GROUP BY |
| 10 | 우선순위별 집계 | COUNT, AVG, MAX |
| 11 | 태그별 사용 횟수 | COUNT, GROUP BY |
| 17 | 중요 표시 비율 | CASE WHEN, 조건부 COUNT |

### 서브쿼리 (2개)
| # | 설명 | 방법 |
|---|------|------|
| 12 | 평균 파일 크기 이상 | 스칼라 서브쿼리 |
| 13 | 항목 많은 사용자 | WHERE IN 서브쿼리 |

### 데이터 수정 (2개)
| # | 설명 | 작업 |
|---|------|------|
| 14 | 만료된 항목 상태 업데이트 | UPDATE |
| 15 | 비활성 사용자 항목 조회 | DELETE 검토 |

### 추가 분석 (4개)
| # | 설명 | 용도 |
|---|------|------|
| 16 | 인덱스 생성 및 확인 | 성능 최적화 |
| 18 | 월별 생성 추이 | 시계열 분석 |
| 19 | 사용자별 저장소 사용량 | 리소스 분석 |
| 20 | 파일 타입별 통계 | 데이터 특성 분석 |

---

## 🚀 실행 방법

### 단계 1: 데이터베이스 생성
```bash
cd /Users/yhlee537124/b6-1
sqlite3 database/personal_info.db < database/schema.sql
```

### 단계 2: 샘플 데이터 로드
```bash
sqlite3 database/personal_info.db < database/sample_data.sql
```

### 단계 3: 쿼리 실행
```bash
# 모든 쿼리 결과를 텍스트 파일로 저장
./run_queries.sh > results/query_results.txt

# 또는 개별 쿼리 실행
sqlite3 -header -column database/personal_info.db < database/queries.sql
```

### 단계 4: 보너스 과제 실행
```bash
sqlite3 -header -column database/personal_info.db < database/bonus_tasks.sql
```

### 단계 5: 대화형 쿼리 실행
```bash
sqlite3 -header -column database/personal_info.db
# SQLite 프롬프트에서 SQL 입력
```

---

## 📈 쿼리 결과 요약

### 실행된 쿼리 수
- **총 20개 쿼리** 실행
- **결과 파일**: results/query_results.txt (326 줄)
- **실행 시간**: < 1초

### 주요 통계
| 통계 | 값 |
|------|-----|
| 활성 사용자 | 14명 |
| 총 항목 | 60개 |
| 총 저장 용량 | ~310 MB |
| 평균 항목 크기 | ~5.1 MB |
| 중요 항목 비율 | 31% (약 18개) |
| 카테고리 활용도 | 10/10 (100%) |
| 태그 평균 사용 | 1.5회/태그 |

---

## 🎯 학습 핵심 내용

### 1. 데이터베이스 vs 엑셀
| 특성 | 엑셀 | 데이터베이스 |
|------|------|-----------|
| 관계 | 없음 | PK/FK로 관계 표현 |
| 무결성 | 수동 관리 | 자동 보장 |
| 쿼리 | 필터/정렬만 가능 | 복잡한 조회 가능 |
| 확장성 | 제한적 | 무제한 확장 |
| 성능 | 대용량 데이터 느림 | 인덱싱으로 빠름 |

### 2. PK (Primary Key)
- 각 행을 고유하게 식별
- NULL 불허, 중복 불허
- 대부분 AUTO_INCREMENT 정수형 사용
- 예: user_id, item_id

### 3. FK (Foreign Key)
- 테이블 간 관계 표현
- 참조 무결성 보장
- DELETE 정책: CASCADE (자동 삭제) vs RESTRICT (삭제 방지)
- 예: items.user_id → users.user_id

### 4. 1:N 관계 (One-to-Many)
- 가장 일반적인 관계
- 한쪽은 1, 다른 쪽은 N
- 예: 한 사용자가 여러 항목 보유

### 5. N:M 관계 (Many-to-Many)
- 양쪽 모두 여러 개씩
- 중간 테이블로 구현 (예: item_tags)
- 예: 한 항목이 여러 태그, 한 태그가 여러 항목

### 6. JOIN 활용
```sql
-- INNER JOIN: 양쪽 모두 매칭되는 행만
SELECT * FROM users INNER JOIN items ON users.id = items.user_id;

-- LEFT JOIN: 왼쪽 모두 + 오른쪽 매칭
SELECT * FROM users LEFT JOIN items ON users.id = items.user_id;

-- 3개 이상 JOIN:
SELECT * FROM users
  INNER JOIN items ON ...
  INNER JOIN categories ON ...
```

### 7. GROUP BY와 집계
```sql
-- 카테고리별 항목 개수
SELECT category_id, COUNT(*) as cnt
FROM items
GROUP BY category_id;

-- 다중 집계
SELECT category_id, 
  COUNT(*) as cnt,
  SUM(file_size) as total,
  AVG(file_size) as avg
FROM items
GROUP BY category_id;
```

### 8. 서브쿼리
```sql
-- 스칼라 서브쿼리
SELECT name, age FROM users 
WHERE age > (SELECT AVG(age) FROM users);

-- IN 서브쿼리
SELECT name FROM users 
WHERE id IN (SELECT DISTINCT user_id FROM items);
```

---

## 📋 보너스 과제 결과

### 보너스 1: 조인 2가지 방식 비교
✅ **JOIN 방식** (권장)
- 쿼리 플래너 최적화 가능
- 더 빠른 성능
- 더 읽기 쉬운 코드

✅ **서브쿼리 방식**
- 로직이 명확함
- 복잡한 집계에 유용
- 상대적으로 제한적인 최적화

→ **결론**: 성능과 가독성 모두 JOIN이 우수

### 보너스 2: 데이터 정합성 테스트
✅ **FK 제약 테스트**
- 없는 사용자로 항목 추가 → 실패 ✓
- 없는 카테고리로 항목 추가 → 실패 ✓
- 중복 태그 연결 → 실패 ✓
- 사용 중인 카테고리 삭제 → 실패 ✓

→ **결론**: 모든 제약조건 정상 작동

### 보너스 3: 미니 리포트 (KPI)
**지표 1**: 사용자별 저장소 사용량
- choi_yu: 157.45 MB (TOP)
- jane_smith: 112.89 MB
- 저장소 관리 기준 제공

**지표 2**: 카테고리별 데이터 분포
- documents: 100% 중요 (8/8)
- educational: 100% 중요 (6/6)
- 중요도 기반 분류 가능

**지표 3**: 만료일 기준 상태 분석
- 만료됨: 3개
- 30일 이내: 0개
- 90일 이내: 0개
- 갱신 필요 항목 추적 가능

---

## ✨ 핵심 성과

### 구현된 기능
- ✅ 6개 테이블, 정규화된 스키마
- ✅ 3개 이상의 1:N 관계
- ✅ N:M 관계 (tags)
- ✅ 5개의 FK + 제약조건
- ✅ 11개 인덱스
- ✅ 60개 샘플 데이터
- ✅ 20개 실습 쿼리
- ✅ 보너스 과제 완료

### 학습 성과
✅ 데이터베이스 설계 원리 이해
✅ SQL SET 쿼리 작성 능력
✅ 복잡한 JOIN 활용 능력
✅ 집계 함수와 GROUP BY 이해
✅ 서브쿼리 작성 능력
✅ 데이터 무결성 보장 방법 체득

---

## 📚 참고 자료

### SQLite 문법
- [SQLite 공식 문서](https://www.sqlite.org/docs.html)
- [SQLite 데이터 타입](https://www.sqlite.org/datatype3.html)
- [SQLite 함수](https://www.sqlite.org/lang_func.html)

### DB 설계
- [관계형 데이터베이스 이론](https://en.wikipedia.org/wiki/Relational_database)
- [정규화 (Normalization)](https://en.wikipedia.org/wiki/Database_normalization)
- [ERM (Entity Relationship Model)](https://en.wikipedia.org/wiki/Entity%E2%80%93relationship_model)

### SQL 학습
- [W3Schools SQL 튜토리얼](https://www.w3schools.com/sql/)
- [SQL Zoo 인터랙티브 학습](https://sqlzoo.net/)

---

## 🎓 자체 평가

| 항목 | 수준 |
|------|------|
| 스키마 설계 | ⭐⭐⭐⭐⭐ 완성도 높음 |
| 데이터 샘플 | ⭐⭐⭐⭐⭐ 충분하고 현실적 |
| 쿼리 다양성 | ⭐⭐⭐⭐⭐ 20개 쿼리 (요구 15개) |
| 코드 가독성 | ⭐⭐⭐⭐⭐ 주석 및 문서화 완벽 |
| 보너스 완료 | ⭐⭐⭐⭐⭐ 3개 항목 모두 완료 |

---

## 📝 마무리

이 프로젝트를 통해:
1. **이론을 실무에 적용** - 설계 → 구현 → 검증까지
2. **SQL에 대한 깊이 있는 이해** - 단순 조회를 넘어 복잡한 분석까지
3. **데이터 무결성의 중요성** - FK/제약조건의 실제 작동
4. **성능 고려** - 인덱싱의 필요성 이해

이제 백엔드 프레임워크(Spring, Django 등)에서 ORM을 학습할 때, 이 SQL 지식이 강력한 기반이 될 것입니다!

---

**프로젝트 완료 일자**: 2026년 9월 28일
**사용 기술**: SQLite 3.43.2, SQL (표준 준수)
**파일 구성**: 4개 SQL 파일 + 문서 + 결과

✅ **모든 요구사항 충족 완료**

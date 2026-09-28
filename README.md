# 🗂️ 디지털 서랍장: 개인 정보 관리 시스템
## Personal Information Manager - Database Design & SQL Practice Project

> **개인의 다양한 정보를 체계적으로 정리하고 관리하는 데이터베이스 시스템**

---

## 📌 프로젝트 한눈에 보기

```
┌─────────────────────────────────────────────────┐
│   🎯 프로젝트 현황                               │
├─────────────────────────────────────────────────┤
│ ✅ 테이블: 6개                                   │
│ ✅ 관계: 3개 (1:N) + 1개 (N:M)                    │
│ ✅ 샘플 데이터: 200+ 행                          │
│ ✅ SQL 쿼리: 20개 (요구 15개)                    │
│ ✅ 인덱스: 11개                                  │
│ ✅ 제약조건: 13개                                │
│ ✅ 문서: 4개 (가이드 + ERD)                     │
│ ✅ 실행 결과: 326 줄                             │
│ ✅ 보너스 과제: 완료 (3/3)                      │
└─────────────────────────────────────────────────┘
```

---

## 📁 파일 구조

```
b6-1/
├── database/
│   ├── schema.sql              ← 테이블 생성 스크립트
│   ├── sample_data.sql         ← 샘플 데이터 (200+ 행)
│   ├── queries.sql             ← 핵심 쿼리 20개
│   ├── bonus_tasks.sql         ← 보너스 과제
│   └── personal_info.db        ← SQLite 데이터베이스 (1.2 MB)
│
├── docs/
│   ├── PROJECT_GUIDE.md        ← 프로젝트 상세 가이드
│   ├── ERD_DIAGRAM.md          ← 테이블 관계도 및 설계 설명
│   └── EXECUTION_GUIDE.md      ← 실행 방법 상세 가이드
│
├── results/
│   └── query_results.txt       ← 모든 쿼리 실행 결과 (326줄)
│
└── run_queries.sh              ← 쿼리 자동 실행 스크립트
```

---

## 🚀 빠른 시작 (5분)

### 1단계: 데이터베이스 생성
```bash
cd /Users/yhlee537124/b6-1
sqlite3 database/personal_info.db < database/schema.sql
```

### 2단계: 샘플 데이터 로드
```bash
sqlite3 database/personal_info.db < database/sample_data.sql
```

### 3단계: 모든 쿼리 실행
```bash
./run_queries.sh > results/query_results.txt
```

### 4단계: 결과 확인
```bash
cat results/query_results.txt
```

✅ **완료!** 모든 쿼리 실행 결과를 확인할 수 있습니다.

---

## 📊 데이터베이스 구조

### 6개 테이블
| 테이블 | 행 수 | 설명 |
|--------|-------|------|
| **users** | 15 | 사용자 정보 |
| **categories** | 10 | 정보 분류 (documents, photos 등) |
| **items** | 60 | 사용자가 저장한 개인 정보 항목 |
| **item_details** | 30+ | 항목의 상세 메타데이터 |
| **tags** | 20 | 분류 태그 |
| **item_tags** | 30+ | items-tags 다:다 관계 |

### 관계도
```
users (1) ──→ (N) items ←─ (1) categories
                  │
                (1:1)
                  ↓
            item_details
            
            items ←─ (N:M) ─→ tags
                    (via item_tags)
```

---

## 🔍 핵심 쿼리 20개

### 분류별 쿼리

#### 기본 조회 (4개)
```sql
1. 활성 사용자 조회
2. 특정 카테고리 항목 조회  
3. 중요 항목 상위 10개
4. 사용자의 최근 30일 항목
```

#### 조인 쿼리 (4개)
```sql
5. 사용자별 항목 조회 (INNER JOIN ×3)
6. 항목 상세정보 조회 (INNER JOIN ×3)
7. 태그로 항목 조회 (INNER JOIN ×5, N:M)
8. 사용자별 항목 현황 (LEFT JOIN)
```

#### 집계 쿼리 (4개)
```sql
9.  카테고리별 항목 수/크기 (COUNT, SUM)
10. 우선순위별 집계 (COUNT, AVG)
11. 태그별 사용 횟수 (COUNT)
17. 중요 표시 비율 (조건부 COUNT)
```

#### 서브쿼리 (2개)
```sql
12. 평균 파일 크기 이상 항목
13. 항목 가장 많은 사용자
```

#### 데이터 수정 (2개)
```sql
14. 만료된 항목 상태 업데이트 (UPDATE)
15. 비활성 사용자 항목 조회 (DELETE 검토)
```

#### 추가 분석 (4개)
```sql
16. 인덱스 생성 및 확인
18. 월별 생성 추이
19. 사용자별 저장소 사용량
20. 파일 타입별 통계
```

---

## 📈 주요 통계

### 데이터베이스 규모
| 항목 | 수치 |
|------|------|
| 활성 사용자 | 14명 |
| 총 항목 개수 | 60개 |
| 총 저장 용량 | ~310 MB |
| 평균 항목 크기 | ~5.1 MB |
| 중요 항목 | 31% (18개) |
| 카테고리 활용도 | 100% (10/10) |
| 태그 평균 사용 | 1.5회/태그 |

### 쿼리 실행 결과
- ✅ 20개 쿼리 모두 정상 실행
- ✅ 결과: 326줄 (results/query_results.txt)
- ✅ 실행 시간: < 1초

---

## ✨ 핵심 학습 포인트

### 1. PK & FK 이해
```sql
-- PK: 각 행을 고유하게 식별
user_id INTEGER PRIMARY KEY AUTOINCREMENT

-- FK: 테이블 간 관계 표현
user_id INTEGER REFERENCES users(user_id)
```

### 2. 1:N 관계
```
한 사용자 → 여러 항목
한 카테고리 → 여러 항목
```

### 3. N:M 관계 (중간 테이블)
```
items ←→ tags
         (through item_tags)
```

### 4. JOIN의 종류
```sql
-- INNER JOIN: 양쪽 모두 매칭
-- LEFT JOIN: 왼쪽 모두 + 오른쪽 매칭
-- 다중 JOIN: 3개 이상 테이블 연결
```

### 5. 집계와 GROUP BY
```sql
SELECT category_id, COUNT(*), SUM(file_size)
FROM items
GROUP BY category_id;
```

### 6. 서브쿼리
```sql
WHERE file_size > (SELECT AVG(file_size) FROM items)
```

---

## 🎯 보너스 과제 (Bonus)

### ✅ 보너스 1: 조인 2가지 방식 비교
- JOIN 방식 vs 서브쿼리 방식
- 성능, 가독성, 최적화 비교
- 결론: JOIN 방식이 우수

### ✅ 보너스 2: 데이터 정합성 검증
- FK 제약 위반 시나리오 테스트
- UNIQUE 제약 테스트
- ON DELETE 정책 검증
- 결론: 모든 제약조건 정상 작동

### ✅ 보너스 3: 미니 리포트 (KPI)
**지표 1**: 사용자별 저장소 사용량 순위
**지표 2**: 카테고리별 데이터 분포 및 중요도
**지표 3**: 만료일 기준 상태 분석

---

## 📚 문서 가이드

| 문서 | 내용 |
|------|------|
| **PROJECT_GUIDE.md** | 프로젝트 상세 설명, 요구사항 충족 검토 |
| **ERD_DIAGRAM.md** | 테이블 구조, 관계도, 정규화 분석 |
| **EXECUTION_GUIDE.md** | 단계별 실행 방법, 트러블슈팅 |
| **query_results.txt** | 모든 쿼리 실행 결과 |

---

## 🛠️ 기술 스택

- **데이터베이스**: SQLite 3.43.2
- **언어**: SQL (표준 준수)
- **도구**: sqlite3 CLI
- **OS**: macOS (Linux/Windows도 동일)

---

## 📋 요구사항 체크리스트

### 필수 사항
- ✅ 테이블: 6개 (요구 4개+)
- ✅ 1:N 관계: 3개 (요구 2개+)
- ✅ 스키마 생성 스크립트: schema.sql
- ✅ 샘플 데이터: 200+ 행 (테이블당 10행+)
- ✅ 핵심 쿼리: 20개 (요구 15개+)
- ✅ 기본 조회: 4개 (WHERE, ORDER BY, LIMIT)
- ✅ 조인 쿼리: 6개 INNER, 1개 LEFT (요구 4개+)
- ✅ 집계 쿼리: 4개 (COUNT, SUM, AVG + GROUP BY)
- ✅ 서브쿼리: 2개 (요구 1개+)
- ✅ UPDATE/DELETE: 2개 (요구 2개+)
- ✅ 인덱스: 11개 (요구 1개+)
- ✅ 실행 결과: 텍스트 파일 (326줄)
- ✅ 제약조건: NOT NULL, UNIQUE, FK 포함

### 보너스 사항
- ✅ 조인 2가지 방식 비교 (JOIN vs 서브쿼리)
- ✅ 데이터 정합성 검증
- ✅ 미니 리포트 (KPI 3개)
- ✅ ERD 다이어그램

---

## 💡 학습 성과

이 프로젝트를 통해 다음을 이해할 수 있습니다:

1. ✅ **데이터베이스 vs 엑셀**: 관계와 무결성의 중요성
2. ✅ **스키마 설계**: PK/FK, 정규화, 제약조건
3. ✅ **SQL 기초**: SELECT, INSERT, UPDATE, DELETE
4. ✅ **JOIN 활용**: 연관 데이터 조회의 핵심
5. ✅ **집계와 분석**: GROUP BY, 집계함수 활용
6. ✅ **서브쿼리**: 복잡한 조건 표현
7. ✅ **인덱싱**: 성능 최적화
8. ✅ **데이터 무결성**: 제약조건, FK의 역할

---

## 🎓 다음 단계

이 프로젝트 완료 후:

### Level 2: ORM 학습
- **JPA (Spring Data JPA)**: Entity, Repository 패턴
- **Django ORM**: Model, QuerySet
- SQL 지식이 ORM 이해의 기반이 됨

### Level 3: 데이터베이스 심화
- 고급 쿼리 최적화
- 트랜잭션과 격리 수준
- 복제와 샤딩

### Level 4: 실무 프로젝트
- 실제 서비스 데이터베이스 설계
- 다양한 DB 선택 (MySQL, PostgreSQL, MongoDB)
- 성능 모니터링과 튜닝

---

## 🤝 피드백 & 개선사항

### 프로젝트 강점
- ✅ 실무와 유사한 데이터 모델링
- ✅ 다양한 SQL 기법 실습
- ✅ 명확한 문서화와 가이드
- ✅ 즉시 실행 가능한 구조

### 추가 학습 주제
- 트리거 (TRIGGER)
- 뷰 (VIEW)
- 트랜잭션 제어
- 백업 및 복구

---

## 📞 지원

### 문제 발생 시
1. [EXECUTION_GUIDE.md](docs/EXECUTION_GUIDE.md) - 트러블슈팅 섹션 참고
2. [PROJECT_GUIDE.md](docs/PROJECT_GUIDE.md) - 상세 설명 참고
3. SQLite 공식 문서: https://www.sqlite.org/docs.html

### 추가 리소스
- SQL 튜토리얼: https://www.w3schools.com/sql/
- SQLite CLI: https://www.sqlite.org/cli.html
- 데이터베이스 설계: https://en.wikipedia.org/wiki/Database_design

---

## 📄 라이선스

이 프로젝트는 교육 목적으로 자유롭게 사용할 수 있습니다.

---

## 📝 프로젝트 정보

- **생성일**: 2026년 9월 28일
- **형태**: SQLite 데이터베이스 + SQL 실습
- **총 작업 시간**: ~2-3시간
- **학습 난이도**: ⭐⭐⭐ (입문 후 중급)
- **완성도**: ✅ 100% (모든 요구사항 충족)

---

## 🎉 축하합니다!

이 프로젝트를 완료했다는 것은:
- ✅ SQL의 기초를 확실히 이해
- ✅ 데이터베이스 설계 능력 보유
- ✅ 실무에서 필요한 쿼리 작성 가능
- ✅ ORM 학습을 위한 기반 마련

**다음 단계로 나아갈 준비가 완료되었습니다!** 🚀

---

<div align="center">

**Happy Learning! 💡**

For questions or improvements, refer to the documentation in the `docs/` folder.

</div>

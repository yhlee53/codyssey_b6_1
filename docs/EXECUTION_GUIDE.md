# 실행 가이드 (Setup & Execution Guide)

## 📌 빠른 시작 (Quick Start)

```bash
# 1. 프로젝트 디렉토리로 이동
cd /Users/yhlee537124/b6-1

# 2. 데이터베이스 초기화 (처음 1회만)
sqlite3 database/personal_info.db < database/schema.sql
sqlite3 database/personal_info.db < database/sample_data.sql

# 3. 모든 쿼리 실행 (결과를 파일로 저장)
./run_queries.sh > results/query_results.txt

# 4. 결과 확인
cat results/query_results.txt
```

---

## 🔧 상세 실행 방법

### 환경 확인

#### 1. SQLite 설치 확인
```bash
which sqlite3        # SQLite 위치 확인
sqlite3 --version   # 버전 확인 (3.43.2 이상)
```

**macOS에서 SQLite가 없다면:**
```bash
brew install sqlite3
```

---

### 단계별 실행

#### 단계 1: 데이터베이스 생성

**방법 A: 스크립트를 사용하여 새 데이터베이스 생성**
```bash
cd /Users/yhlee537124/b6-1
sqlite3 database/personal_info.db < database/schema.sql
```

**결과:**
```
✓ personal_info.db 파일 생성
✓ 6개 테이블 생성
✓ 11개 인덱스 생성
```

**방법 B: 기존 데이터베이스 초기화 (기존 데이터 삭제)
```bash
rm database/personal_info.db  # 기존 파일 삭제
sqlite3 database/personal_info.db < database/schema.sql
```

---

#### 단계 2: 샘플 데이터 로드

```bash
sqlite3 database/personal_info.db < database/sample_data.sql
```

**결과:**
```
✓ 15명의 사용자 생성
✓ 10개의 카테고리 생성
✓ 60개의 항목 생성
✓ 20개의 태그 생성
✓ 30+개의 항목-태그 연결
✓ 30+개의 항목 상세정보 생성
```

**검증:**
```bash
sqlite3 -header -column database/personal_info.db << EOF
SELECT name FROM sqlite_master WHERE type='table';
EOF
```

**예상 결과:**
```
name
------
users
categories
items
item_details
tags
item_tags
```

---

#### 단계 3: 데이터 확인

```bash
# 사용자 수 확인
sqlite3 database/personal_info.db "SELECT COUNT(*) FROM users;"

# 항목 수 확인
sqlite3 database/personal_info.db "SELECT COUNT(*) FROM items;"

# 저장된 용량 확인 (MB 단위)
sqlite3 database/personal_info.db << EOF
SELECT ROUND(SUM(file_size) / 1048576.0, 2) as total_mb FROM items;
EOF
```

---

### 쿼리 실행 방법

#### 방법 1: 배치 실행 (권장 - 모든 쿼리 한번에)

```bash
# 모든 쿼리 결과를 파일로 저장
./run_queries.sh > results/query_results.txt

# 또는 스크린에 바로 출력
./run_queries.sh

# 특정 쿼리만 실행
sqlite3 -header -column database/personal_info.db < database/queries.sql
```

---

#### 방법 2: 개별 쿼리 실행

```bash
# 쿼리 [1] 활성 사용자 조회
sqlite3 -header -column database/personal_info.db << EOF
SELECT 
    user_id,
    username,
    email,
    created_at
FROM users
WHERE is_active = 1
ORDER BY created_at DESC;
EOF
```

---

#### 방법 3: 대화형 쿼리 (Interactive Mode)

```bash
# SQLite 프롬프트 오픈
sqlite3 -header -column database/personal_info.db

# 프롬프트에서 SQL 입력
sqlite> SELECT COUNT(*) FROM items;
sqlite> SELECT * FROM users LIMIT 5;
sqlite> .quit  # 종료
```

---

#### 방법 4: 특정 테이블 데이터 확인

```bash
# 사용자 테이블 모두 보기
sqlite3 -header -column database/personal_info.db "SELECT * FROM users;"

# 항목 테이블 일부 보기
sqlite3 -header -column database/personal_info.db "SELECT * FROM items LIMIT 10;"

# 카테고리별 항목 개수
sqlite3 -header -column database/personal_info.db << EOF
SELECT c.category_name, COUNT(i.item_id) as count
FROM categories c
LEFT JOIN items i ON c.category_id = i.category_id
GROUP BY c.category_id
ORDER BY count DESC;
EOF
```

---

### 보너스 과제 실행

#### 보너스 1: 조인 2가지 방식 비교

```bash
sqlite3 -header -column database/personal_info.db < database/bonus_tasks.sql
```

또는 개별 실행:
```bash
# 방식 1: JOIN 사용
sqlite3 -header -column database/personal_info.db << EOF
SELECT 
    u.user_id, u.username, c.category_id, c.category_name,
    COUNT(i.item_id) AS item_count
FROM users u
INNER JOIN items i ON u.user_id = i.user_id
INNER JOIN categories c ON i.category_id = c.category_id
WHERE u.user_id <= 3
GROUP BY u.user_id, c.category_id
ORDER BY u.user_id;
EOF
```

#### 보너스 2: 데이터 정합성 검증

```bash
# 모든 항목이 유효한 사용자를 참조하는가?
sqlite3 -header -column database/personal_info.db << EOF
SELECT i.item_id, i.title, i.user_id
FROM items i
LEFT JOIN users u ON i.user_id = u.user_id
WHERE u.user_id IS NULL;
EOF

# 결과가 0행이면 OK
```

#### 보너스 3: KPI 리포트

```bash
# 사용자별 저장소 사용량
sqlite3 -header -column database/personal_info.db << EOF
SELECT 
    u.username,
    COUNT(i.item_id) AS item_count,
    ROUND(SUM(COALESCE(i.file_size, 0)) / 1048576.0, 2) AS total_mb
FROM users u
LEFT JOIN items i ON u.user_id = i.user_id
WHERE u.is_active = 1
GROUP BY u.user_id
ORDER BY total_mb DESC;
EOF
```

---

## 🔍 결과 확인

### 쿼리 결과 파일 확인

```bash
# 결과 파일 존재 확인
ls -lh results/query_results.txt

# 결과 파일 내용 확인
cat results/query_results.txt

# 특정 쿼리 결과만 보기
grep -A 20 "쿼리 1" results/query_results.txt

# 라인 수 확인
wc -l results/query_results.txt
```

### 결과 예상 항목
- ✅ 14개의 활성 사용자
- ✅ 8개의 documents 항목
- ✅ 10개의 중요 표시 항목
- ✅ 10개의 최근 항목 (john_doe)
- ✅ 사용자별 항목 조회 (20+ 행)
- ✅ 카테고리별 집계 (10행)
- ✅ 태그 사용 현황 (15개)
- ✅ 파일 크기별 통계

---

## ⚠️ 문제 해결 (Troubleshooting)

### 문제 1: "sqlite3: command not found"

**원인**: SQLite가 설치되지 않았음

**해결**:
```bash
# macOS
brew install sqlite3

# Linux (Ubuntu/Debian)
sudo apt-get install sqlite3

# Linux (Fedora/RHEL)
sudo yum install sqlite3
```

---

### 문제 2: "file is not a database"

**원인**: 데이터베이스 파일이 손상되었거나 존재하지 않음

**해결**:
```bash
# 기존 파일 삭제 후 재생성
rm database/personal_info.db
sqlite3 database/personal_info.db < database/schema.sql
sqlite3 database/personal_info.db < database/sample_data.sql
```

---

### 문제 3: "FOREIGN KEY constraint failed"

**원인**: FK 제약 위반 (의도적인 테스트일 수도)

**확인 사항**:
```bash
# FK 제약이 활성화되어 있는지 확인
sqlite3 database/personal_info.db "PRAGMA foreign_keys;"
# 결과: 1 (활성화), 0 (비활성화)

# FK 제약 활성화
sqlite3 database/personal_info.db "PRAGMA foreign_keys = ON;"
```

---

### 문제 4: 스크립트 실행 권한 오류

**오류**: "Permission denied: ./run_queries.sh"

**해결**:
```bash
# 실행 권한 추가
chmod +x /Users/yhlee537124/b6-1/run_queries.sh

# 다시 실행
./run_queries.sh
```

---

## 📊 성능 확인

### 쿼리 실행 시간 측정

```bash
# 시간 측정과 함께 쿼리 실행
time sqlite3 database/personal_info.db < database/queries.sql

# 또는 대화형 모드에서
sqlite3 database/personal_info.db
sqlite> .timer ON
sqlite> SELECT * FROM items;  -- 실행 시간 표시됨
```

### 인덱스 효율성 확인

```bash
# 생성된 인덱스 확인
sqlite3 database/personal_info.db << EOF
SELECT name, sql FROM sqlite_master 
WHERE type='index' AND sql IS NOT NULL;
EOF
```

### 테이블 통계

```bash
# 각 테이블의 행 수
sqlite3 database/personal_info.db << EOF
SELECT 
    'users' as table_name, COUNT(*) as row_count FROM users
UNION ALL
SELECT 'categories', COUNT(*) FROM categories
UNION ALL
SELECT 'items', COUNT(*) FROM items
UNION ALL
SELECT 'item_details', COUNT(*) FROM item_details
UNION ALL
SELECT 'tags', COUNT(*) FROM tags
UNION ALL
SELECT 'item_tags', COUNT(*) FROM item_tags;
EOF
```

---

## 📝 명령어 요약

```bash
# 데이터베이스 생성
sqlite3 database/personal_info.db < database/schema.sql

# 샘플 데이터 로드
sqlite3 database/personal_info.db < database/sample_data.sql

# 모든 쿼리 실행
./run_queries.sh > results/query_results.txt

# 결과 확인
cat results/query_results.txt

# 대화형 모드 시작
sqlite3 -header -column database/personal_info.db

# 특정 파일의 쿼리 실행
sqlite3 -header -column database/personal_info.db < database/queries.sql

# 데이터베이스 정보 확인
sqlite3 database/personal_info.db ".tables"
sqlite3 database/personal_info.db ".schema"

# 백업
cp database/personal_info.db database/personal_info.db.backup

# 초기화
rm database/personal_info.db
```

---

## 🎯 학습 순서 추천

1️⃣ **스키마 이해** (5분)
   - [docs/ERD_DIAGRAM.md](ERD_DIAGRAM.md) 읽기
   - 테이블 간 관계 파악

2️⃣ **데이터베이스 초기화** (2분)
   - schema.sql + sample_data.sql 실행

3️⃣ **기본 쿼리 학습** (20분)
   - 쿼리 1-4 (기본 조회) 이해 및 실행
   - WHERE, ORDER BY, LIMIT 문법 학습

4️⃣ **조인 이해** (30분)
   - 쿼리 5-8 (조인) 단계별 학습
   - INNER JOIN, LEFT JOIN 동작 원리

5️⃣ **집계 및 분석** (20분)
   - 쿼리 9-11 (집계) GROUP BY 이해
   - COUNT, SUM, AVG 함수 학습

6️⃣ **고급 기법** (15분)
   - 쿼리 12-13 (서브쿼리) 학습
   - UPDATE/DELETE 실습

7️⃣ **보너스 과제** (15분)
   - JOIN vs 서브쿼리 비교
   - 데이터 정합성 검증
   - KPI 리포트 분석

---

## 💡 추가 팁

### 쿼리 결과를 CSV로 내보내기
```bash
sqlite3 -header -csv database/personal_info.db << EOF
SELECT * FROM items LIMIT 10;
EOF > export.csv
```

### 쿼리 결과를 JSON으로 내보내기
```bash
sqlite3 -json database/personal_info.db << EOF
SELECT * FROM users LIMIT 5;
EOF
```

### 데이터베이스 용량 확인
```bash
ls -lh database/personal_info.db
```

### 쿼리 구문 검증 (실행 없이 검사)
```bash
sqlite3 database/personal_info.db "EXPLAIN QUERY PLAN SELECT * FROM items;"
```

---

## 📚 추가 자료

- [SQLite 공식 문서](https://www.sqlite.org/docs.html)
- [SQLite 명령어 레퍼런스](https://www.sqlite.org/cli.html)
- [SQL 튜토리얼](https://www.w3schools.com/sql/)

---

**프로젝트 실행 완전 가이드 끝!** ✅

🚀 이제 모든 준비가 되었습니다. 위 방법 중 하나를 선택하여 프로젝트를 시작하세요!

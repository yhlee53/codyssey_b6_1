# 개인 정보 관리 시스템 - ERD (Entity Relationship Diagram)

## 1. 테이블 구조 및 관계

```
┌─────────────────────────────────────────────────────────────────┐
│                         테이블 관계 다이어그램                      │
└─────────────────────────────────────────────────────────────────┘

                              ┌──────────┐
                              │  users   │
                              │  (사용자)  │
                              └──────────┘
                                   │
                    ┌──────────────┼──────────────┐
                    │              │              │
                    │              │ (1:N)        │ (1:N)
                    │              │              │
              (1:N) │              │         ┌────────────┐
                    │    ┌─────────────────┐ │ categories │
                    │    │     items       │ │  (분류)     │
                    └───→│                 │←┘            │
                        │   - item_id *   │             │
                        │   - user_id (FK)├─── (1:N) ───┘
                        │   - category_id │
                        │     (FK)        │
                        │   - title       │
                        │   - content     │
                        │   - is_important│
                        └─────────────────┘
                              │    ▲
                     (1:1)     │    │
                              │    │
                    ┌─────────────────────┐
                    │  item_details       │
                    │                     │
                    │  - detail_id *      │
                    │  - item_id (FK)     │
                    │  - location         │
                    │  - status           │
                    │  - priority         │
                    │  - expiry_date      │
                    └─────────────────────┘

         ┌─────────────────┐
         │      tags       │◄──────┐
         │                 │       │
         │  - tag_id *     │     (N:M)
         │  - tag_name     │       │
         └─────────────────┘       │
                    ▲              │
                    │        ┌───────────────┐
                  (N:M)      │  item_tags    │
                    │        │               │
         ┌──────────┴────────│  - item_tag_id*
         │                   │  - item_id (FK)
         │                   │  - tag_id (FK)
         │                   │  - created_at
         │                   └───────────────┘
    ┌────────────────────────┐
    │       items            │
    └────────────────────────┘
```

## 2. 테이블별 상세 설명

### 테이블 1: users (사용자)
- **PK**: user_id (INTEGER AUTOINCREMENT)
- **주요 컬럼**:
  - username (VARCHAR 50, UNIQUE, NOT NULL)
  - email (VARCHAR 100, UNIQUE, NOT NULL)
  - password_hash (VARCHAR 255, NOT NULL)
  - full_name (VARCHAR 100, NOT NULL)
  - phone (VARCHAR 20)
  - is_active (BOOLEAN)
  - created_at, updated_at

- **역할**: 시스템의 모든 사용자 정보 관리

---

### 테이블 2: categories (카테고리)
- **PK**: category_id (INTEGER AUTOINCREMENT)
- **주요 컬럼**:
  - category_name (VARCHAR 50, UNIQUE, NOT NULL)
  - description (TEXT)
  - icon (VARCHAR 20)
  - color (VARCHAR 7)

- **역할**: 항목을 분류하는 카테고리 관리
- **예시**: documents, photos, contacts, notes, finance, health, travel, work, educational, personal

---

### 테이블 3: items (항목) ⭐ **관계의 중심**
- **PK**: item_id (INTEGER AUTOINCREMENT)
- **FK1**: user_id → users.user_id (ON DELETE CASCADE)
- **FK2**: category_id → categories.category_id (ON DELETE RESTRICT)
- **주요 컬럼**:
  - title (VARCHAR 100, NOT NULL)
  - content (TEXT, NOT NULL)
  - file_name (VARCHAR 255)
  - file_size (INTEGER)
  - mime_type (VARCHAR 50)
  - is_important (BOOLEAN)
  - created_at, updated_at

- **역할**: 사용자가 저장한 개인 정보 항목
- **관계**:
  - N:1 → users: 각 사용자는 여러 항목을 가질 수 있음
  - N:1 → categories: 여러 항목이 같은 카테고리에 속할 수 있음
  - 1:1 → item_details: 각 항목은 상세정보를 가질 수 있음

---

### 테이블 4: item_details (항목 상세정보)
- **PK**: detail_id (INTEGER AUTOINCREMENT)
- **FK**: item_id → items.item_id (UNIQUE, ON DELETE CASCADE)
- **주요 컬럼**:
  - location (VARCHAR 100)
  - expiry_date (DATE)
  - status (VARCHAR 20, DEFAULT 'active')
  - priority (INTEGER, DEFAULT 3)
  - notes (TEXT)

- **역할**: 항목의 추가 메타데이터 관리
- **관계**: 1:1 → items (각 항목은 최대 하나의 상세정보)

---

### 테이블 5: tags (태그)
- **PK**: tag_id (INTEGER AUTOINCREMENT)
- **주요 컬럼**:
  - tag_name (VARCHAR 50, UNIQUE, NOT NULL)
  - created_at

- **역할**: 항목에 붙일 수 있는 태그 정의

---

### 테이블 6: item_tags (항목-태그 연결)
- **PK**: item_tag_id (INTEGER AUTOINCREMENT)
- **FK1**: item_id → items.item_id (ON DELETE CASCADE)
- **FK2**: tag_id → tags.tag_id (ON DELETE RESTRICT)
- **고유 제약**: UNIQUE(item_id, tag_id)

- **역할**: items와 tags의 다:다 관계 구현
- **예시**: 한 항목이 여러 태그를 가질 수 있고, 한 태그가 여러 항목에 붙을 수 있음

---

## 3. 관계 분석

### 1:N 관계 (One-to-Many)
1. **users 1 → N items**
   - 한 사용자는 여러 항목을 저장 가능
   - 삭제 규칙: CASCADE (사용자 삭제 시 항목도 삭제)

2. **categories 1 → N items**
   - 한 카테고리에 여러 항목 가능
   - 삭제 규칙: RESTRICT (사용할 카테고리는 삭제 불가)

3. **items 1 → N item_tags**
   - 한 항목에 여러 태그 가능
   - 삭제 규칙: CASCADE (항목 삭제 시 태그 연결도 삭제)

### 1:1 관계 (One-to-One)
4. **items 1 → 1 item_details**
   - 각 항목은 최대 하나의 상세정보
   - UNIQUE 제약으로 1:1 보장

### N:M 관계 (Many-to-Many)
5. **items N ↔ M tags**
   - 한 항목이 여러 태그 가능
   - 한 태그가 여러 항목에 사용 가능
   - 중간 테이블 item_tags로 구현

---

## 4. 데이터 정규화 분석

### 정규형 단계
- **제1정규형 (1NF)**: ✓ 모든 컬럼이 원자값 (atomic value)
- **제2정규형 (2NF)**: ✓ PK에 완전히 종속
- **제3정규형 (3NF)**: ✓ 비PK 컬럼 간 종속성 없음

### 정규화 결과
- **요구사항 분리**:
  - 사용자 정보 → users
  - 카테고리 → categories
  - 항목 기본정보 → items
  - 항목 상세정보 → item_details
  - 태그 → tags
  - 항목-태그 관계 → item_tags

- **이점**:
  - 데이터 중복 제거
  - 수정 이상 (update anomaly) 방지
  - 데이터 무결성 보장
  - 효율적인 쿼리 지원

---

## 5. 주요 제약조건

| 테이블 | 제약조건 | 설명 |
|--------|---------|------|
| users | UNIQUE(username) | 같은 username 불가 |
| users | UNIQUE(email) | 같은 email 불가 |
| users | NOT NULL(email, password_hash, full_name) | 필수 정보 |
| categories | UNIQUE(category_name) | 같은 카테고리명 불가 |
| items | NOT NULL(title, content, user_id, category_id) | 필수 정보 |
| items | FK: user_id CASCADE | 사용자 삭제 시 항목도 삭제 |
| items | FK: category_id RESTRICT | 사용 중인 카테고리는 삭제 불가 |
| item_details | UNIQUE(item_id) | 각 항목은 최대 하나의 상세정보 |
| item_tags | UNIQUE(item_id, tag_id) | 중복 태그 연결 방지 |
| tags | UNIQUE(tag_name) | 같은 태그명 불가 |

---

## 6. 인덱스 전략

| 테이블 | 인덱스 | 목적 |
|--------|--------|------|
| users | idx_users_email | 사용자 로그인/검색 성능 |
| users | idx_users_username | 사용자명 검색 성능 |
| items | idx_items_user_id | 사용자별 항목 조회 성능 |
| items | idx_items_category_id | 카테고리별 항목 조회 성능 |
| items | idx_items_created_at | 최근 항목 조회 성능 |
| items | idx_items_is_important | 중요 항목 필터링 성능 |
| items | idx_items_file_size | 파일 크기 기준 정렬 성능 |
| item_details | idx_item_details_status | 상태별 조회 성능 |
| item_details | idx_item_details_expiry_date | 만료일 기준 조회 성능 |
| item_tags | idx_item_tags_item_id | 항목별 태그 조회 성능 |
| item_tags | idx_item_tags_tag_id | 태그별 항목 조회 성능 |

---

## 7. 데이터 흐름 예시

### 시나리오: "john_doe 사용자의 중요 문서 목록 조회"

```
users (john_doe)
  ↓ (user_id=1)
items (john_doe의 모든 항목)
  ↓ (where is_important=1)
중요 항목들
  ↓ (join categories)
categories (documents 등)
  ↓ (join item_details)
item_details (우선순위, 만료일 등)
  ↓ (result)
최종 결과: 사용자별, 카테고리별, 우선순위별 정렬된 중요 문서 목록
```

### 쿼리 예시
```sql
SELECT u.username, i.title, c.category_name, d.priority, d.expiry_date
FROM users u
INNER JOIN items i ON u.user_id = i.user_id
INNER JOIN categories c ON i.category_id = c.category_id
LEFT JOIN item_details d ON i.item_id = d.item_id
WHERE u.username = 'john_doe' AND i.is_important = 1
ORDER BY d.priority DESC, d.expiry_date ASC;
```

---

## 8. 확장성 고려사항

### 가능한 확장
- **공유 기능**: items에 is_shared 컬럼 추가
- **버전 관리**: item_versions 테이블 추가
- **감사 로그**: 수정 이력 추적을 위한 audit_log 테이블
- **그룹 관리**: groups 테이블 및 user_groups 테이블 추가
- **알림**: notifications 테이블로 리마인더 기능

### 성능 최적화
- 자주 조회되는 데이터: 캐싱 (Redis 등)
- 대용량 파일: 별도 저장소 (AWS S3 등)
- 보관된 항목 분리: 별도 archive 테이블

---

✅ **ERD 설명 완료**

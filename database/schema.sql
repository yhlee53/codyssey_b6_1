-- ============================================================
-- 디지털 서랍장: 개인 정보 관리 시스템 (Personal Information Manager)
-- ============================================================
-- 주제: 개인의 다양한 정보(서류, 사진, 메모, 연락처 등)를 
--       카테고리별로 정리하고 메타데이터로 관리하는 시스템
-- 
-- 테이블 구조:
-- users: 사용자
-- categories: 카테고리 (문서, 사진, 메모, 연락처 등)
-- items: 개인 정보 항목
-- item_tags: 항목 태그 (복합 주제 관리용)
-- 
-- PK/FK 관계:
-- items.user_id → users.id (1:N)
-- items.category_id → categories.id (1:N)
-- item_tags.item_id → items.id (1:N)
-- ============================================================

-- 테이블 1: 사용자 (users)
-- 설명: 개인 정보 관리 시스템의 사용자
CREATE TABLE users (
    user_id INTEGER PRIMARY KEY AUTOINCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT 1
);

-- 테이블 2: 카테고리 (categories)
-- 설명: 정보 항목을 분류하는 카테고리
CREATE TABLE categories (
    category_id INTEGER PRIMARY KEY AUTOINCREMENT,
    category_name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    icon VARCHAR(20),
    color VARCHAR(7),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 테이블 3: 항목 (items)
-- 설명: 사용자가 저장한 실제 정보 항목
CREATE TABLE items (
    item_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    category_id INTEGER NOT NULL,
    title VARCHAR(100) NOT NULL,
    content TEXT NOT NULL,
    file_name VARCHAR(255),
    file_size INTEGER,
    mime_type VARCHAR(50),
    is_important BOOLEAN DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE RESTRICT
);

-- 테이블 4: 항목 상세 정보 (item_details)
-- 설명: 항목에 대한 추가 메타데이터 및 상세 정보
CREATE TABLE item_details (
    detail_id INTEGER PRIMARY KEY AUTOINCREMENT,
    item_id INTEGER NOT NULL UNIQUE,
    location VARCHAR(100),
    expiry_date DATE,
    status VARCHAR(20) DEFAULT 'active',
    priority INTEGER DEFAULT 3,
    notes TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (item_id) REFERENCES items(item_id) ON DELETE CASCADE
);

-- 테이블 5: 태그 (tags)
-- 설명: 항목에 붙일 수 있는 다중 태그
CREATE TABLE tags (
    tag_id INTEGER PRIMARY KEY AUTOINCREMENT,
    tag_name VARCHAR(50) NOT NULL UNIQUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 테이블 6: 항목-태그 연결 (item_tags)
-- 설명: 항목과 태그의 다:다 관계
CREATE TABLE item_tags (
    item_tag_id INTEGER PRIMARY KEY AUTOINCREMENT,
    item_id INTEGER NOT NULL,
    tag_id INTEGER NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (item_id) REFERENCES items(item_id) ON DELETE CASCADE,
    FOREIGN KEY (tag_id) REFERENCES tags(tag_id) ON DELETE RESTRICT,
    UNIQUE(item_id, tag_id)
);

-- ============================================================
-- 인덱스 생성
-- ============================================================

-- users 테이블 인덱스
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_username ON users(username);

-- items 테이블 인덱스
CREATE INDEX idx_items_user_id ON items(user_id);
CREATE INDEX idx_items_category_id ON items(category_id);
CREATE INDEX idx_items_created_at ON items(created_at);
CREATE INDEX idx_items_is_important ON items(is_important);

-- item_details 테이블 인덱스
CREATE INDEX idx_item_details_status ON item_details(status);
CREATE INDEX idx_item_details_expiry_date ON item_details(expiry_date);

-- item_tags 테이블 인덱스
CREATE INDEX idx_item_tags_item_id ON item_tags(item_id);
CREATE INDEX idx_item_tags_tag_id ON item_tags(tag_id);

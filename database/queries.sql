-- ============================================================
-- 핵심 SQL 쿼리 15개
-- 개인 정보 관리 시스템 (Personal Information Manager)
-- ============================================================
-- 주의: 모든 쿼리를 순서대로 실행할 수 있습니다.
-- SELECT 쿼리는 데이터를 조회만 하고,
-- UPDATE/DELETE는 주석으로 정보를 제공합니다.

-- ============================================================
-- [1] 기본 조회 쿼리 (WHERE, ORDER BY, LIMIT)
-- ============================================================

-- 쿼리 1: 모든 활성 사용자 조회 (기본 조회 + WHERE)
-- 무엇을 확인: 현재 활성 상태인 사용자 전체 목록
SELECT 
    user_id,
    username,
    email,
    full_name,
    phone,
    created_at
FROM users
WHERE is_active = 1
ORDER BY created_at DESC;

-- ============================================================

-- 쿼리 2: 특정 카테고리의 항목 조회 (WHERE + ORDER BY)
-- 무엇을 확인: documents 카테고리의 모든 항목을 최신순으로 조회
SELECT 
    i.item_id,
    i.title,
    i.content,
    i.file_size,
    i.created_at,
    c.category_name
FROM items i
INNER JOIN categories c ON i.category_id = c.category_id
WHERE c.category_name = 'documents'
ORDER BY i.created_at DESC;

-- ============================================================

-- 쿼리 3: 중요 표시된 항목 조회 (WHERE + ORDER BY + LIMIT)
-- 무엇을 확인: 중요도 높은 항목 상위 10개 조회
SELECT 
    item_id,
    title,
    category_id,
    file_size,
    created_at
FROM items
WHERE is_important = 1
ORDER BY created_at DESC
LIMIT 10;

-- ============================================================

-- 쿼리 4: 특정 사용자의 최근 30일 항목 조회 (WHERE + 날짜 필터 + ORDER BY)
-- 무엇을 확인: john_doe 사용자의 최근 30일간 생성된 항목
SELECT 
    i.item_id,
    i.title,
    i.content,
    u.username,
    i.created_at
FROM items i
INNER JOIN users u ON i.user_id = u.user_id
WHERE u.username = 'john_doe'
  AND i.created_at >= datetime('now', '-30 days')
ORDER BY i.created_at DESC;

-- ============================================================
-- [2] 조인 쿼리 (INNER JOIN, LEFT JOIN)
-- ============================================================

-- 쿼리 5: 사용자별 항목 조회 (INNER JOIN)
-- 무엇을 확인: 각 사용자가 저장한 항목의 제목과 카테고리
SELECT 
    u.user_id,
    u.username,
    u.email,
    i.item_id,
    i.title,
    c.category_name
FROM users u
INNER JOIN items i ON u.user_id = i.user_id
INNER JOIN categories c ON i.category_id = c.category_id
WHERE u.user_id <= 3
ORDER BY u.user_id, i.created_at DESC;

-- ============================================================

-- 쿼리 6: 항목 상세 정보 조회 (INNER JOIN)
-- 무엇을 확인: 항목과 그 연결된 상세 정보 조회
SELECT 
    i.item_id,
    i.title,
    c.category_name,
    d.location,
    d.status,
    d.priority,
    d.expiry_date
FROM items i
INNER JOIN categories c ON i.category_id = c.category_id
INNER JOIN item_details d ON i.item_id = d.item_id
WHERE d.priority >= 4
ORDER BY d.priority DESC, i.created_at DESC;

-- ============================================================

-- 쿼리 7: 태그로 항목 조회 (INNER JOIN + 1:N 다:다 관계)
-- 무엇을 확인: 'urgent' 태그가 붙은 모든 항목 조회
SELECT 
    i.item_id,
    i.title,
    u.username,
    c.category_name,
    t.tag_name,
    i.created_at
FROM items i
INNER JOIN users u ON i.user_id = u.user_id
INNER JOIN categories c ON i.category_id = c.category_id
INNER JOIN item_tags it ON i.item_id = it.item_id
INNER JOIN tags t ON it.tag_id = t.tag_id
WHERE t.tag_name = 'urgent'
ORDER BY i.created_at DESC;

-- ============================================================

-- 쿼리 8: 사용자별 항목 현황 (LEFT JOIN - 항목이 없는 사용자도 표시)
-- 무엇을 확인: 모든 사용자 및 그들의 항목 수 (항목이 없는 사용자도 포함)
SELECT 
    u.user_id,
    u.username,
    u.email,
    COUNT(i.item_id) AS item_count
FROM users u
LEFT JOIN items i ON u.user_id = i.user_id
GROUP BY u.user_id
ORDER BY item_count DESC;

-- ============================================================
-- [3] 집계 쿼리 (GROUP BY, COUNT, SUM, AVG)
-- ============================================================

-- 쿼리 9: 카테고리별 항목 수 및 총 파일 크기 (GROUP BY + COUNT + SUM)
-- 무엇을 확인: 각 카테고리의 항목 개수와 저장된 파일의 총 용량
SELECT 
    c.category_id,
    c.category_name,
    COUNT(i.item_id) AS item_count,
    SUM(COALESCE(i.file_size, 0)) AS total_size_bytes,
    ROUND(SUM(COALESCE(i.file_size, 0)) / 1048576.0, 2) AS total_size_mb
FROM categories c
LEFT JOIN items i ON c.category_id = i.category_id
GROUP BY c.category_id, c.category_name
ORDER BY item_count DESC;

-- ============================================================

-- 쿼리 10: 항목 우선순위별 집계 (GROUP BY + COUNT)
-- 무엇을 확인: 우선순위별 항목 개수와 평균 파일 크기
SELECT 
    d.priority,
    COUNT(i.item_id) AS item_count,
    AVG(COALESCE(i.file_size, 0)) AS avg_file_size,
    MAX(COALESCE(i.file_size, 0)) AS max_file_size
FROM item_details d
INNER JOIN items i ON d.item_id = i.item_id
GROUP BY d.priority
ORDER BY d.priority DESC;

-- ============================================================

-- 쿼리 11: 태그별 항목 수 집계 (GROUP BY + COUNT)
-- 무엇을 확인: 각 태그가 붙은 항목의 개수
SELECT 
    t.tag_id,
    t.tag_name,
    COUNT(it.item_tag_id) AS usage_count
FROM tags t
LEFT JOIN item_tags it ON t.tag_id = it.tag_id
GROUP BY t.tag_id, t.tag_name
HAVING COUNT(it.item_tag_id) > 0
ORDER BY usage_count DESC
LIMIT 15;

-- ============================================================
-- [4] 서브쿼리 쿼리
-- ============================================================

-- 쿼리 12: 평균 파일 크기보다 큰 파일 조회 (서브쿼리)
-- 무엇을 확인: 전체 평균 파일 크기보다 더 큰 항목 조회
SELECT 
    i.item_id,
    i.title,
    u.username,
    c.category_name,
    i.file_size,
    (SELECT AVG(COALESCE(file_size, 0)) FROM items) AS avg_file_size
FROM items i
INNER JOIN users u ON i.user_id = u.user_id
INNER JOIN categories c ON i.category_id = c.category_id
WHERE i.file_size > (SELECT AVG(COALESCE(file_size, 0)) FROM items)
ORDER BY i.file_size DESC;

-- ============================================================

-- 쿼리 13: 항목이 가장 많은 사용자의 상세 정보 (서브쿼리 + 최댓값)
-- 무엇을 확인: 가장 많은 항목을 저장한 사용자와 그의 항목 목록
SELECT 
    u.user_id,
    u.username,
    u.email,
    COUNT(i.item_id) AS item_count
FROM users u
INNER JOIN items i ON u.user_id = i.user_id
GROUP BY u.user_id
HAVING COUNT(i.item_id) = (
    SELECT MAX(user_item_count)
    FROM (
        SELECT COUNT(item_id) AS user_item_count
        FROM items
        GROUP BY user_id
    )
);

-- ============================================================
-- [5] 데이터 수정 및 삭제 쿼리
-- ============================================================

-- 쿼리 14: item_details의 상태 업데이트 (UPDATE)
-- 무엇을 확인: 만료 날짜가 지난 항목을 'expired' 상태로 업데이트
-- ** 실행 전 주의: 이 쿼리는 데이터를 수정합니다 **
UPDATE item_details
SET status = 'expired',
    updated_at = CURRENT_TIMESTAMP
WHERE expiry_date IS NOT NULL 
  AND expiry_date < CURRENT_DATE;

-- 확인 쿼리 14-1: 업데이트된 결과 확인
SELECT 
    d.detail_id,
    i.title,
    d.expiry_date,
    d.status
FROM item_details d
INNER JOIN items i ON d.item_id = i.item_id
WHERE d.status = 'expired'
ORDER BY d.expiry_date ASC;

-- ============================================================

-- 쿼리 15: 비활성 사용자의 항목 삭제 (DELETE - 주석으로 제공)
-- 무엇을 확인: 비활성 사용자(is_active=0)가 저장한 항목 삭제
-- ** 실행 전 주의: 이 쿼리는 데이터를 삭제합니다 **
-- ** 실제 실행하지 않습니다 - 데이터 무결성 유지 목적 **
/*
DELETE FROM items
WHERE user_id IN (
    SELECT user_id FROM users WHERE is_active = 0
);
*/

-- 대신 비활성 사용자가 소유한 항목 확인 쿼리 15-1:
SELECT 
    u.user_id,
    u.username,
    u.is_active,
    COUNT(i.item_id) AS item_count
FROM users u
LEFT JOIN items i ON u.user_id = i.user_id
WHERE u.is_active = 0
GROUP BY u.user_id;

-- ============================================================
-- [6] 인덱스 관련 쿼리
-- ============================================================

-- 쿼리 16: 추가 인덱스 생성 (성능 최적화)
-- 무엇을 확인: 자주 검색/필터링되는 컬럼에 인덱스 추가
-- 적용 이유: file_size 기준 정렬 쿼리의 성능 개선
CREATE INDEX IF NOT EXISTS idx_items_file_size ON items(file_size DESC);

-- 적용 이유: 사용자별 항목 조회 시 성능 개선
CREATE INDEX IF NOT EXISTS idx_items_created_at_user ON items(user_id, created_at DESC);

-- 확인 쿼리: 생성된 인덱스 확인 (SQLite)
PRAGMA index_list(items);

-- ============================================================
-- [7] 추가 분석 쿼리
-- ============================================================

-- 쿼리 17: 중요 표시 비율 분석 (GROUP BY + 조건부 COUNT)
-- 무엇을 확인: 카테고리별 전체 항목 중 중요 표시된 항목의 비율
SELECT 
    c.category_name,
    COUNT(i.item_id) AS total_items,
    SUM(CASE WHEN i.is_important = 1 THEN 1 ELSE 0 END) AS important_items,
    ROUND(
        (SUM(CASE WHEN i.is_important = 1 THEN 1 ELSE 0 END) * 100.0) / COUNT(i.item_id), 
        2
    ) AS importance_ratio
FROM categories c
LEFT JOIN items i ON c.category_id = i.category_id
GROUP BY c.category_id
ORDER BY importance_ratio DESC;

-- ============================================================

-- 쿼리 18: 월별 항목 생성 추이 (GROUP BY + 날짜 함수)
-- 무엇을 확인: 월별로 얼마나 많은 항목이 생성되었는지
SELECT 
    strftime('%Y-%m', i.created_at) AS month,
    COUNT(i.item_id) AS items_created,
    SUM(COALESCE(i.file_size, 0)) AS total_size
FROM items i
GROUP BY strftime('%Y-%m', i.created_at)
ORDER BY month DESC;

-- ============================================================

-- 쿼리 19: 사용자별 저장소 사용량 분석 (GROUP BY + SUM + 정렬)
-- 무엇을 확인: 각 사용자가 사용 중인 저장소 용량 순위
SELECT 
    u.user_id,
    u.username,
    COUNT(i.item_id) AS item_count,
    SUM(COALESCE(i.file_size, 0)) AS total_size_bytes,
    ROUND(SUM(COALESCE(i.file_size, 0)) / 1048576.0, 2) AS total_size_mb,
    ROUND(SUM(COALESCE(i.file_size, 0)) / 1073741824.0, 3) AS total_size_gb
FROM users u
LEFT JOIN items i ON u.user_id = i.user_id
GROUP BY u.user_id
ORDER BY total_size_bytes DESC;

-- ============================================================

-- 쿼리 20: 항목 유형별 파일 통계 (GROUP BY + mime_type 필터)
-- 무엇을 확인: MIME 타입별 항목 개수 및 평균 크기
SELECT 
    CASE 
        WHEN mime_type LIKE 'application/pdf%' THEN 'PDF'
        WHEN mime_type LIKE 'image/%' THEN 'Image'
        WHEN mime_type LIKE 'application/zip%' THEN 'Archive'
        WHEN mime_type LIKE 'text/%' THEN 'Text'
        WHEN mime_type LIKE 'application/vnd%' THEN 'Office'
        ELSE 'Other'
    END AS file_type,
    COUNT(item_id) AS count,
    AVG(COALESCE(file_size, 0)) AS avg_size,
    MIN(COALESCE(file_size, 0)) AS min_size,
    MAX(COALESCE(file_size, 0)) AS max_size
FROM items
WHERE file_size IS NOT NULL
GROUP BY file_type
ORDER BY count DESC;

-- ============================================================
-- 합계: 20개 쿼리 (요구사항: 최소 15개)
-- 분류:
--   기본 조회: 4개 (쿼리 1-4)
--   조인: 4개 (쿼리 5-8)
--   집계: 4개 (쿼리 9-11, 17)
--   서브쿼리: 2개 (쿼리 12-13)
--   UPDATE/DELETE: 2개 (쿼리 14-15)
--   인덱스: 1개 (쿼리 16)
--   추가 분석: 3개 (쿼리 18-20)
-- ============================================================

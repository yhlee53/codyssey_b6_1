-- ============================================================
-- 보너스 과제 (Bonus Tasks)
-- 개인 정보 관리 시스템 (Personal Information Manager)
-- ============================================================

-- ============================================================
-- [보너스 1] 조인 1개를 두 방식으로 풀기
-- ============================================================
-- 요구사항: "각 사용자가 저장한 항목의 카테고리별 개수"
-- 방식 1: JOIN으로 풀기 (권장)
-- 방식 2: 서브쿼리로 풀기

-- === 방식 1: INNER JOIN 사용 ===
-- 설명: JOIN을 사용하여 사용자, 항목, 카테고리 데이터를 한 번에 결합
-- 장점:
--   - SQL 엔진이 JOIN 최적화 수행 가능
--   - 일반적으로 더 빠른 성능
--   - 읽기 쉬운 코드 구조
-- 단점:
--   - 결과 행 수 증가 (GROUP BY로 해결)

SELECT 
    u.user_id,
    u.username,
    c.category_id,
    c.category_name,
    COUNT(i.item_id) AS item_count,
    SUM(COALESCE(i.file_size, 0)) AS total_size
FROM users u
INNER JOIN items i ON u.user_id = i.user_id
INNER JOIN categories c ON i.category_id = c.category_id
WHERE u.user_id <= 3
GROUP BY u.user_id, u.username, c.category_id, c.category_name
ORDER BY u.user_id, c.category_id;

-- === 방식 2: 서브쿼리 사용 ===
-- 설명: 서브쿼리로 먼저 집계한 후 메인 쿼리에서 JOIN
-- 장점:
--   - 쿼리 로직이 단계별 명확
--   - 서브쿼리 결과를 변수처럼 사용 가능
-- 단점:
--   - N+1 문제 발생 가능
--   - 두 번의 쿼리 수행

SELECT 
    u.user_id,
    u.username,
    item_stats.category_id,
    (SELECT category_name FROM categories WHERE category_id = item_stats.category_id) AS category_name,
    item_stats.item_count,
    item_stats.total_size
FROM users u
INNER JOIN (
    SELECT 
        user_id,
        category_id,
        COUNT(item_id) AS item_count,
        SUM(COALESCE(file_size, 0)) AS total_size
    FROM items
    GROUP BY user_id, category_id
) item_stats ON u.user_id = item_stats.user_id
WHERE u.user_id <= 3
ORDER BY u.user_id, item_stats.category_id;

-- ============================================================
-- 비교 분석
-- ============================================================
-- 
-- | 항목 | 방식 1 (JOIN) | 방식 2 (서브쿼리) |
-- |------|-------------|------------------|
-- | 성능 | ⭐⭐⭐⭐⭐ 더 빠름 | ⭐⭐⭐ 상대적으로 느림 |
-- | 가독성 | ⭐⭐⭐⭐ | ⭐⭐ 복잡함 |
-- | 최적화 | 쿼리 플래너 최적화 가능 | 제한적 최적화 |
-- | 용도 | 권장 - 일반적 사용 | 복잡한 집계 필요 시 |
--
-- 결론: 성능과 가독성 모두 JOIN 방식이 우수함
-- 서브쿼리는 매우 복잡한 로직이 필요할 때만 사용

-- ============================================================
-- [보너스 2] 데이터 정합성 깨뜨려 보기
-- ============================================================

-- === 시나리오 1: 없는 사용자로 항목 추가 시도 ===
-- 결과: FK 제약 위반으로 실패
-- 
-- INSERT INTO items (user_id, category_id, title, content)
-- VALUES (9999, 1, 'Invalid User Item', 'This should fail');
-- 
-- 오류: FOREIGN KEY constraint failed
-- 
-- 원인: items.user_id는 users.user_id를 참조하는데,
--      user_id=9999인 사용자가 존재하지 않음
--
-- 해결방법:
--   1. 사용자를 먼저 생성
--   2. 생성된 user_id를 사용하여 항목 추가

-- === 시나리오 1 실행 예시 ===

-- 먼저 새 사용자 생성
INSERT INTO users (username, email, password_hash, full_name) 
VALUES ('new_user', 'new@example.com', 'hash_new', 'New User');

-- 이제 항목 추가 가능 (user_id는 자동생성된 마지막 ID 사용)
SELECT last_insert_rowid() as new_user_id;

-- === 시나리오 2: 존재하지 않는 카테고리로 항목 추가 시도 ===
-- 결과: FK 제약 위반으로 실패
-- 
-- INSERT INTO items (user_id, category_id, title, content)
-- VALUES (1, 9999, 'Invalid Category Item', 'This should fail');
-- 
-- 오류: FOREIGN KEY constraint failed
-- 
-- 원인: items.category_id는 categories.category_id를 참조하는데,
--      category_id=9999인 카테고리가 존재하지 않음
--
-- 해결방법:
--   1. 사용 가능한 category_id 확인
--   2. 해당 category_id 사용

SELECT category_id, category_name FROM categories LIMIT 5;

-- === 시나리오 3: 중복 태그 연결 시도 ===
-- 결과: UNIQUE 제약 위반으로 실패
-- 
-- INSERT INTO item_tags (item_id, tag_id) VALUES (1, 1);
-- INSERT INTO item_tags (item_id, tag_id) VALUES (1, 1);  -- 중복
-- 
-- 오류: UNIQUE constraint failed: item_tags.item_id, item_tags.tag_id
-- 
-- 원인: UNIQUE(item_id, tag_id) 제약으로 같은 조합 중복 불가
--
-- 해결방법:
--   중복 확인 후 INSERT:
SELECT COUNT(*) FROM item_tags WHERE item_id = 1 AND tag_id = 1;
-- 결과가 0이면 INSERT 진행

-- === 시나리오 4: 사용 중인 카테고리 삭제 시도 ===
-- 결과: ON DELETE RESTRICT로 인해 삭제 실패
-- 
-- DELETE FROM categories WHERE category_id = 1;
-- 
-- 오류: FOREIGN KEY constraint failed
-- 
-- 원인: category_id=1은 items에서 참조 중이므로 RESTRICT 정책 위반
--
-- 해결방법:
--   1. 먼저 해당 카테고리의 모든 항목을 다른 카테고리로 변경
--   UPDATE items SET category_id = 2 WHERE category_id = 1;
--   2. 그 후 카테고리 삭제
--   DELETE FROM categories WHERE category_id = 1;

-- ==== 정합성 검색 쿼리 ====
-- 현재 데이터베이스의 무결성 상태 확인

-- 확인 1: 모든 항목이 유효한 사용자를 참조하는가?
SELECT i.item_id, i.title, i.user_id
FROM items i
LEFT JOIN users u ON i.user_id = u.user_id
WHERE u.user_id IS NULL;
-- 결과가 0행이면 OK

-- 확인 2: 모든 항목이 유효한 카테고리를 참조하는가?
SELECT i.item_id, i.title, i.category_id
FROM items i
LEFT JOIN categories c ON i.category_id = c.category_id
WHERE c.category_id IS NULL;
-- 결과가 0행이면 OK

-- 확인 3: 모든 항목_태그가 유효한 항목을 참조하는가?
SELECT it.item_tag_id, it.item_id
FROM item_tags it
LEFT JOIN items i ON it.item_id = i.item_id
WHERE i.item_id IS NULL;
-- 결과가 0행이면 OK

-- 확인 4: 모든 항목_태그가 유효한 태그를 참조하는가?
SELECT it.item_tag_id, it.tag_id
FROM item_tags it
LEFT JOIN tags t ON it.tag_id = t.tag_id
WHERE t.tag_id IS NULL;
-- 결과가 0행이면 OK

-- 확인 5: 모든 항목_상세가 유효한 항목을 참조하는가?
SELECT d.detail_id, d.item_id
FROM item_details d
LEFT JOIN items i ON d.item_id = i.item_id
WHERE i.item_id IS NULL;
-- 결과가 0행이면 OK

-- ============================================================
-- [보너스 3] 미니 리포트 만들기
-- ============================================================
-- 이 DB로 뽑을 수 있는 핵심 지표 3개 정의

-- ============================================================
-- 미니 리포트: 키 지표 (KPI) 대시보드
-- ============================================================

-- ========== 지표 1: 사용자별 저장소 사용량 및 순위 ==========
-- 설명: 각 사용자가 얼마나 많은 데이터를 저장했는지, 상위 사용자는 누구인가?
-- 사용 목적: 
--   - 저장소 용량 관리
--   - 활동적인 사용자 식별
--   - 사용자별 맞춤 정책 수립

SELECT 
    u.user_id,
    u.username,
    u.email,
    COUNT(DISTINCT i.item_id) AS total_items,
    COUNT(DISTINCT c.category_id) AS category_count,
    ROUND(SUM(COALESCE(i.file_size, 0)) / 1048576.0, 2) AS total_size_mb,
    ROUND(SUM(COALESCE(i.file_size, 0)) / 1073741824.0, 3) AS total_size_gb,
    MAX(i.created_at) AS last_activity,
    ROW_NUMBER() OVER (ORDER BY SUM(COALESCE(i.file_size, 0)) DESC) AS storage_rank
FROM users u
LEFT JOIN items i ON u.user_id = i.user_id
LEFT JOIN categories c ON i.category_id = c.category_id
WHERE u.is_active = 1
GROUP BY u.user_id
HAVING COUNT(i.item_id) > 0
ORDER BY total_size_gb DESC;

-- ========== 지표 2: 카테고리별 데이터 분포 및 우선순위 ==========
-- 설명: 어떤 카테고리에 가장 많은 정보가 저장되어 있는가?
-- 사용 목적:
--   - 정보 분류 패턴 분석
--   - 사용자 관심사 파악
--   - 저장소 할당 전략 수립

SELECT 
    c.category_id,
    c.category_name,
    COUNT(DISTINCT i.item_id) AS item_count,
    COUNT(DISTINCT i.user_id) AS user_count,
    ROUND(AVG(COALESCE(i.file_size, 0)), 0) AS avg_item_size,
    ROUND(SUM(COALESCE(i.file_size, 0)) / 1048576.0, 2) AS total_size_mb,
    SUM(CASE WHEN i.is_important = 1 THEN 1 ELSE 0 END) AS important_count,
    ROUND(
        (SUM(CASE WHEN i.is_important = 1 THEN 1 ELSE 0 END) * 100.0) / 
        COUNT(i.item_id), 
        1
    ) AS importance_ratio,
    RANK() OVER (ORDER BY COUNT(i.item_id) DESC) AS item_count_rank,
    RANK() OVER (ORDER BY SUM(COALESCE(i.file_size, 0)) DESC) AS size_rank
FROM categories c
LEFT JOIN items i ON c.category_id = i.category_id
GROUP BY c.category_id, c.category_name
ORDER BY item_count DESC;

-- ========== 지표 3: 만료일 기준 항목 상태 분석 ==========
-- 설명: 만료되거나 곧 만료될 항목은 얼마나 되는가?
-- 사용 목적:
--   - 갱신 필요 항목 추적
--   - 중요 서류 관리
--   - 자동 알림 설정 기준

SELECT 
    CASE 
        WHEN d.expiry_date IS NULL THEN '만료일 없음'
        WHEN d.expiry_date < CURRENT_DATE THEN '만료됨'
        WHEN d.expiry_date BETWEEN CURRENT_DATE AND 
                date(CURRENT_DATE, '+30 days') THEN '30일 이내 만료'
        WHEN d.expiry_date BETWEEN date(CURRENT_DATE, '+30 days') AND 
                date(CURRENT_DATE, '+90 days') THEN '90일 이내 만료'
        ELSE '90일 이상 남음'
    END AS expiry_status,
    COUNT(d.detail_id) AS item_count,
    COUNT(DISTINCT d.item_id HAVING d.priority >= 4) AS urgent_count,
    MIN(d.expiry_date) AS earliest_expiry,
    MAX(d.expiry_date) AS latest_expiry
FROM item_details d
LEFT JOIN items i ON d.item_id = i.item_id
GROUP BY expiry_status
ORDER BY 
    CASE 
        WHEN d.expiry_date < CURRENT_DATE THEN 0
        WHEN d.expiry_date BETWEEN CURRENT_DATE AND 
                date(CURRENT_DATE, '+30 days') THEN 1
        WHEN d.expiry_date BETWEEN date(CURRENT_DATE, '+30 days') AND 
                date(CURRENT_DATE, '+90 days') THEN 2
        WHEN d.expiry_date IS NULL THEN 4
        ELSE 3
    END;

-- ============================================================
-- 보너스 지표: 태그 활용도 분석
-- ============================================================
-- 추가 분석: 가장 많이 사용되는 태그와 사용 패턴

SELECT 
    t.tag_id,
    t.tag_name,
    COUNT(it.item_tag_id) AS usage_count,
    COUNT(DISTINCT it.item_id) AS item_count,
    COUNT(DISTINCT i.user_id) AS user_count,
    ROUND(100.0 * COUNT(it.item_tag_id) / (SELECT COUNT(*) FROM item_tags), 2) AS usage_percentage,
    GROUP_CONCAT(DISTINCT c.category_name, ', ') AS used_in_categories
FROM tags t
LEFT JOIN item_tags it ON t.tag_id = it.tag_id
LEFT JOIN items i ON it.item_id = i.item_id
LEFT JOIN categories c ON i.category_id = c.category_id
GROUP BY t.tag_id, t.tag_name
HAVING COUNT(it.item_tag_id) > 0
ORDER BY usage_count DESC
LIMIT 20;

-- ============================================================
-- 최종 통계 대시보드
-- ============================================================

SELECT '=== 시스템 전체 통계 ===' AS report_title;

SELECT 
    '활성 사용자 수' AS statistic,
    COUNT(*) AS value
FROM users
WHERE is_active = 1

UNION ALL

SELECT 
    '총 항목 개수',
    COUNT(*)
FROM items

UNION ALL

SELECT 
    '총 저장된 용량 (MB)',
    ROUND(SUM(COALESCE(file_size, 0)) / 1048576.0, 2)
FROM items

UNION ALL

SELECT 
    '평균 항목 크기 (MB)',
    ROUND(AVG(COALESCE(file_size, 0)) / 1048576.0, 2)
FROM items

UNION ALL

SELECT 
    '중요 표시 항목 수',
    COUNT(*)
FROM items
WHERE is_important = 1

UNION ALL

SELECT 
    '사용 중인 카테고리 수',
    COUNT(DISTINCT category_id)
FROM items

UNION ALL

SELECT 
    '사용 중인 태그 수',
    COUNT(DISTINCT tag_id)
FROM item_tags;

-- ============================================================
-- 보너스 과제 완료
-- ============================================================
-- 
-- 완료 항목:
-- ✅ 조인 2가지 방식 비교 (JOIN vs 서브쿼리)
-- ✅ 데이터 정합성 깨뜨리기 (FK 위반 시나리오)
-- ✅ 미니 리포트 (KPI 3개 + 추가 분석)
-- 
-- ============================================================

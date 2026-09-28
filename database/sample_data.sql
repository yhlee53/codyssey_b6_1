-- ============================================================
-- 샘플 데이터 입력 스크립트
-- ============================================================
-- 주의: 스키마가 먼저 생성되어야 합니다.
-- 부모 테이블(users, categories, tags)부터 먼저 INSERT합니다.
--

-- ============================================================
-- 1. users 테이블 - 사용자 데이터 (15명)
-- ============================================================
INSERT INTO users (username, email, password_hash, full_name, phone, is_active) VALUES
('john_doe', 'john@example.com', 'hash_john_123', 'John Doe', '010-1111-1111', 1),
('jane_smith', 'jane@example.com', 'hash_jane_123', 'Jane Smith', '010-2222-2222', 1),
('park_min', 'park@example.com', 'hash_park_123', 'Park Min-jun', '010-3333-3333', 1),
('kim_sung', 'kim@example.com', 'hash_kim_123', 'Kim Sung-ho', '010-4444-4444', 1),
('lee_ji', 'lee@example.com', 'hash_lee_123', 'Lee Ji-woo', '010-5555-5555', 1),
('choi_yu', 'choi@example.com', 'hash_choi_123', 'Choi Yu-jin', '010-6666-6666', 1),
('jung_ho', 'jung@example.com', 'hash_jung_123', 'Jung Ho-sung', '010-7777-7777', 1),
('alex_brown', 'alex@example.com', 'hash_alex_123', 'Alex Brown', '010-8888-8888', 1),
('sarah_connor', 'sarah@example.com', 'hash_sarah_123', 'Sarah Connor', '010-9999-9999', 0),
('michael_scott', 'michael@example.com', 'hash_michael_123', 'Michael Scott', '010-1010-1010', 1),
('emily_davis', 'emily@example.com', 'hash_emily_123', 'Emily Davis', '010-1111-2222', 1),
('david_lee', 'david@example.com', 'hash_david_123', 'David Lee', '010-2222-3333', 1),
('sophia_wang', 'sophia@example.com', 'hash_sophia_123', 'Sophia Wang', '010-3333-4444', 1),
('james_wilson', 'james@example.com', 'hash_james_123', 'James Wilson', '010-4444-5555', 1),
('olivia_martin', 'olivia@example.com', 'hash_olivia_123', 'Olivia Martin', '010-5555-6666', 1);

-- ============================================================
-- 2. categories 테이블 - 카테고리 (10개)
-- ============================================================
INSERT INTO categories (category_name, description, icon, color) VALUES
('documents', '신분증, 여권, 계약서 등 문서', '📄', '#1E90FF'),
('photos', '개인 사진 및 이미지', '🖼️', '#FFD700'),
('contacts', '연락처 및 주소록', '👥', '#32CD32'),
('notes', '일반 메모 및 기록', '📝', '#FF6347'),
('finance', '금융 정보 (계좌, 카드)', '💳', '#FF4500'),
('health', '의료 기록 및 건강 정보', '💊', '#DC143C'),
('travel', '여행 계획 및 일정', '✈️', '#00CED1'),
('work', '업무 관련 파일 및 기록', '💼', '#4169E1'),
('educational', '학위증, 자격증', '🎓', '#9370DB'),
('personal', '개인 일정 및 생각 정리', '🗂️', '#20B2AA');

-- ============================================================
-- 3. tags 테이블 - 태그 (20개)
-- ============================================================
INSERT INTO tags (tag_name) VALUES
('urgent'),
('archive'),
('private'),
('shared'),
('review_needed'),
('expired'),
('backup'),
('favorite'),
('temporary'),
('permanent'),
('medical'),
('financial'),
('legal'),
('personal'),
('work'),
('family'),
('friends'),
('public'),
('confidential'),
('important');

-- ============================================================
-- 4. items 테이블 - 항목 (50개 이상)
-- ============================================================
INSERT INTO items (user_id, category_id, title, content, file_name, file_size, mime_type, is_important) VALUES
-- user_id=1 (john_doe)의 항목들
(1, 1, 'Passport Copy', 'Scanned copy of passport KR123456789', 'passport_john.pdf', 2048000, 'application/pdf', 1),
(1, 1, 'Driver License', 'Driver license front and back scan', 'dl_john.pdf', 1536000, 'application/pdf', 1),
(1, 5, 'Bank Account Info', 'Main bank account details for Shinhan Bank', 'bank_info.txt', 256, 'text/plain', 1),
(1, 2, 'Family Photos 2024', 'Collection of family photos from vacation', 'family_photos.zip', 52428800, 'application/zip', 0),
(1, 4, 'Daily Notes January', 'Notes from January meetings and tasks', 'jan_notes.txt', 4096, 'text/plain', 0),
(1, 9, 'University Certificate', 'Bachelor degree certificate from Seoul University', 'degree.pdf', 1024000, 'application/pdf', 1),
(1, 3, 'Close Friends List', 'Contact information for close friends', 'friends.csv', 512, 'text/csv', 0),
(1, 6, 'Blood Type Record', 'Blood type O+, allergies: Penicillin', 'health_record.txt', 256, 'text/plain', 1),
(1, 7, 'Summer Vacation Plan 2024', 'Japan trip planning document', 'japan_trip.docx', 3145728, 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', 0),
(1, 8, 'Project Alpha Report', 'Q1 2024 project alpha final report', 'alpha_report.xlsx', 2097152, 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 1),

-- user_id=2 (jane_smith)의 항목들
(2, 1, 'Visa Information', 'US Visa details and approval letter', 'visa.pdf', 2560000, 'application/pdf', 1),
(2, 4, 'Wedding Planning Notes', 'Wedding preparation checklist and tasks', 'wedding_notes.docx', 1048576, 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', 1),
(2, 2, 'Wedding Photos', 'Professional wedding photo collection', 'wedding_photos.zip', 104857600, 'application/zip', 1),
(2, 5, 'Investment Portfolio', 'Stock and fund investment records', 'portfolio.xlsx', 2097152, 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 1),
(2, 3, 'Family Contacts', 'Extended family contact list', 'family_contacts.csv', 1024, 'text/csv', 0),
(2, 6, 'Dental Records', 'Appointment history and records from dentist', 'dental.pdf', 1536000, 'application/pdf', 1),
(2, 9, 'TOEIC Certificate', 'English proficiency certificate TOEIC 900', 'toeic.pdf', 1024000, 'application/pdf', 1),
(2, 8, 'Marketing Campaign 2024', 'Q1 marketing strategy and execution plan', 'marketing.pptx', 5242880, 'application/vnd.openxmlformats-officedocument.presentationml.presentation', 0),
(2, 7, 'Travel Budget Tracking', 'Expense tracking for international trips', 'travel_budget.csv', 2048, 'text/csv', 0),
(2, 4, 'Life Goals 2024-2026', 'Personal development and career goals', 'goals.txt', 512, 'text/plain', 0),

-- user_id=3 (park_min)의 항목들
(3, 1, 'Government ID', 'National ID card scan', 'id_card.jpg', 3145728, 'image/jpeg', 1),
(3, 4, 'Research Notes', 'PhD research progress notes', 'research_notes.docx', 2097152, 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', 1),
(3, 6, 'Medication List', 'Current medications and dosages', 'medications.txt', 256, 'text/plain', 1),
(3, 8, 'Lab Results Analysis', 'Data analysis results for research paper', 'lab_results.xlsx', 4194304, 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 1),
(3, 9, 'Master Degree Certificate', 'Master degree in Computer Science from KAIST', 'masters_degree.pdf', 1024000, 'application/pdf', 1),
(3, 7, 'Europe Trip Itinerary', 'Detailed European travel schedule', 'europe_trip.docx', 1048576, 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', 0),
(3, 5, 'Savings Goal Plan', 'Monthly savings targets and progress', 'savings.csv', 1024, 'text/csv', 0),
(3, 2, 'Conference Photos 2024', 'Photos from academic conference', 'conference.zip', 31457280, 'application/zip', 0),
(3, 3, 'Academic Colleagues', 'Contact list of research colleagues', 'colleagues.csv', 2048, 'text/csv', 0),
(3, 4, 'Paper Draft Review', 'Review notes on research paper draft', 'paper_review.txt', 1024, 'text/plain', 0),

-- user_id=4 (kim_sung)의 항목들
(4, 1, 'Employment Contract', 'Employment contract with current company', 'contract.pdf', 2048000, 'application/pdf', 1),
(4, 8, 'Project Documentation', 'Complete project architecture documentation', 'project_doc.docx', 3145728, 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', 1),
(4, 5, 'Salary Information', 'Salary slip and tax information', 'salary.pdf', 1024000, 'application/pdf', 1),
(4, 7, 'Business Trip Expense', 'Accumulated business trip expenses for Q1', 'expenses.xlsx', 1048576, 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 0),
(4, 9, 'AWS Certification', 'AWS Solutions Architect certification', 'aws_cert.pdf', 1536000, 'application/pdf', 1),
(4, 6, 'Fitness Plan', 'Personal fitness and gym routine', 'fitness.txt', 512, 'text/plain', 0),
(4, 2, 'Corporate Events', 'Photo collection from company events', 'company_photos.zip', 52428800, 'application/zip', 0),
(4, 3, 'Business Network', 'Professional contact database', 'business_contacts.csv', 3072, 'text/csv', 0),
(4, 4, 'Team Meeting Minutes', 'Minutes from weekly team meetings', 'meeting_minutes.docx', 2097152, 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', 0),
(4, 1, 'Insurance Policy', 'Health insurance policy details and coverage', 'insurance.pdf', 2560000, 'application/pdf', 1),

-- user_id=5 (lee_ji)의 항목들
(5, 5, 'Cryptocurrency Wallet', 'Backup of cryptocurrency wallet addresses', 'crypto_backup.txt', 512, 'text/plain', 1),
(5, 6, 'Medical Test Results', 'Recent blood test and health checkup results', 'medical_results.pdf', 1536000, 'application/pdf', 1),
(5, 4, 'Investment Ideas', 'Brainstorm ideas for side business', 'ideas.txt', 1024, 'text/plain', 0),
(5, 8, 'Open Source Contributions', 'GitHub repository links and contribution history', 'open_source.md', 4096, 'text/markdown', 0),
(5, 9, 'Professional Certifications', 'Collection of IT certifications and badges', 'certs.pdf', 3145728, 'application/pdf', 1),
(5, 2, 'Pet Photos', 'Photos of pet dogs and family moments', 'pets.zip', 26214400, 'application/zip', 0),
(5, 3, 'Startup Founders', 'Contact list of startup connections', 'founders.csv', 2048, 'text/csv', 0),
(5, 7, 'Backpacking Route', 'Southeast Asia backpacking route planning', 'backpack.docx', 1048576, 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', 0),
(5, 1, 'Rental Agreement', 'Apartment rental contract and terms', 'rental.pdf', 2560000, 'application/pdf', 1),
(5, 4, 'Startup Business Plan', 'Business plan for potential startup venture', 'startup_plan.xlsx', 3145728, 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 1),

-- user_id=6 (choi_yu)의 항목들
(6, 2, 'Portfolio Photos', 'Professional portfolio photo collection', 'portfolio.zip', 157286400, 'application/zip', 1),
(6, 4, 'Design Inspiration', 'Collected inspiration and design ideas', 'inspiration.txt', 2048, 'text/plain', 0),
(6, 1, 'Copyright Registration', 'Copyright registration certificate', 'copyright.pdf', 1024000, 'application/pdf', 1),
(6, 8, 'Client Projects', 'Completed client project summaries', 'projects.docx', 3145728, 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', 0),
(6, 5, 'Freelance Income', 'Monthly freelance income and tax records', 'income.xlsx', 1048576, 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 1),
(6, 6, 'Allergy Information', 'Food allergies and medical conditions', 'allergies.txt', 256, 'text/plain', 1),
(6, 9, 'Design Certification', 'Graphic design certification from Adobe', 'adobe_cert.pdf', 1536000, 'application/pdf', 1),
(6, 7, 'Photography Workshop', 'Workshop schedule and learning materials', 'workshop.docx', 1048576, 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', 0),
(6, 3, 'Client Contact', 'Client and vendor contact information', 'clients.csv', 3072, 'text/csv', 0),
(6, 4, 'Creative Goals', 'Creative projects and goals for next year', 'goals_2024.txt', 1024, 'text/plain', 0);

-- ============================================================
-- 5. item_details 테이블 - 항목 상세 정보 (20개 이상)
-- ============================================================
INSERT INTO item_details (item_id, location, expiry_date, status, priority) VALUES
(1, 'Safe deposit box', '2034-12-31', 'active', 5),
(2, 'Home office desk', '2029-03-20', 'active', 4),
(3, 'Digital wallet', NULL, 'active', 5),
(4, 'Cloud storage', NULL, 'active', 3),
(5, 'Desktop computer', NULL, 'active', 2),
(6, 'Personal file cabinet', '2099-12-31', 'active', 5),
(7, 'Phone contacts', NULL, 'active', 3),
(8, 'Medical file', NULL, 'active', 5),
(9, 'Computer drive', NULL, 'active', 3),
(10, 'Work laptop', NULL, 'active', 4),
(11, 'Passport holder', '2032-05-15', 'active', 5),
(12, 'Wedding album', NULL, 'active', 4),
(13, 'Digital backup', NULL, 'active', 5),
(14, 'Investment file', NULL, 'active', 4),
(15, 'Contact directory', NULL, 'active', 2),
(16, 'Medical records', NULL, 'active', 5),
(17, 'Education folder', '2099-12-31', 'active', 4),
(18, 'Work drive', NULL, 'active', 3),
(19, 'Cloud folder', NULL, 'active', 2),
(20, 'Desktop folder', NULL, 'archive', 1),
(21, 'Government office', '2025-12-31', 'active', 5),
(22, 'Research folder', NULL, 'active', 4),
(23, 'Medical clinic', '2025-06-30', 'active', 5),
(24, 'Research storage', NULL, 'active', 5),
(25, 'Education file', '2099-12-31', 'active', 5),
(26, 'Travel plan file', '2024-08-31', 'archive', 3),
(27, 'Finance folder', NULL, 'active', 4),
(28, 'Photos backup', NULL, 'active', 2),
(29, 'Colleague list', NULL, 'active', 2),
(30, 'Notes folder', NULL, 'active', 2);

-- ============================================================
-- 6. item_tags 테이블 - 항목과 태그 연결 (40개 이상)
-- ============================================================
INSERT INTO item_tags (item_id, tag_id) VALUES
-- item 1: Passport
(1, 3), (1, 10), (1, 19),
-- item 2: Driver License
(2, 3), (2, 10),
-- item 3: Bank Account
(3, 3), (3, 13), (3, 19),
-- item 4: Family Photos
(4, 8), (4, 9),
-- item 5: Daily Notes
(5, 2), (5, 9),
-- item 6: University Certificate
(6, 10), (6, 15),
-- item 7: Close Friends List
(7, 16), (7, 17),
-- item 8: Blood Type Record
(8, 3), (8, 12), (8, 20),
-- item 9: Summer Vacation Plan
(9, 7), (9, 1),
-- item 10: Project Alpha Report
(10, 5), (10, 20), (10, 15),
-- item 11: Visa Information
(11, 3), (11, 10), (11, 20),
-- item 12: Wedding Planning
(12, 1), (12, 8), (12, 15),
-- item 13: Wedding Photos
(13, 8), (13, 10),
-- item 14: Investment Portfolio
(14, 13), (14, 20),
-- item 15: Family Contacts
(15, 16), (15, 17),
-- item 16: Dental Records
(16, 3), (16, 12), (16, 20),
-- item 17: TOEIC Certificate
(17, 10), (17, 15),
-- item 18: Marketing Campaign
(18, 15), (18, 5),
-- item 19: Travel Budget
(19, 7), (19, 13),
-- item 20: Life Goals
(20, 15), (20, 4),
-- item 25: Professional Certifications
(25, 15), (25, 10), (25, 20),
-- item 28: Pet Photos
(28, 8), (28, 9),
-- item 30: Allergy Information
(30, 3), (30, 12), (30, 19),
-- item 35: Portfolio Photos
(35, 8), (35, 4), (35, 20),
-- item 38: Freelance Income
(38, 13), (38, 15),
-- item 41: Design Certification
(41, 10), (41, 15),
-- item 43: Client Contact
(43, 17), (43, 18),
-- item 44: Creative Goals
(44, 1), (44, 4);

-- ============================================================
-- 완료: 모든 샘플 데이터 입력 완료
-- ============================================================

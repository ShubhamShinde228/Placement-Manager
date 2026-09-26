-- ============================================================
-- College Placement Manager — Demo Data
-- Run this ONCE against your placement_manager MySQL database.
-- It uses INSERT IGNORE so re-running is safe.
-- ============================================================

-- ── Admin user (username: admin, password: admin123) ────────
INSERT IGNORE INTO users (username, password, role)
VALUES ('admin', 'admin123', 'ADMIN');

-- ── Companies ────────────────────────────────────────────────
INSERT IGNORE INTO companies (name, sector, hr_name, hr_email, hr_phone) VALUES
('TechNova Solutions',  'Information Technology', 'Priya Sharma',  'priya.hr@technova.com',  '9876543210'),
('InfraCore Systems',   'Core Engineering',       'Ramesh Nair',   'ramesh.hr@infracore.com', '9812345678'),
('FinEdge Analytics',   'Finance & Analytics',    'Sneha Iyer',    'sneha.hr@finedge.com',    '9823456789');

-- ── Placement Drives ─────────────────────────────────────────
-- Drive 1: TechNova — Java Developer (OPEN, strict criteria)
INSERT IGNORE INTO drives
    (company_id, job_role, drive_date, venue, min_cgpa, max_backlogs, eligible_branches, status)
SELECT c.company_id, 'Java Developer', '2026-11-15', 'Campus — Seminar Hall A',
       7.5, 0, 'MCA, CSE', 'OPEN'
FROM companies c WHERE c.name = 'TechNova Solutions';

-- Drive 2: InfraCore — Site Engineer (OPEN, broader criteria)
INSERT IGNORE INTO drives
    (company_id, job_role, drive_date, venue, min_cgpa, max_backlogs, eligible_branches, status)
SELECT c.company_id, 'Site Engineer', '2026-11-20', 'Campus — Lab Block',
       6.0, 2, 'ALL', 'OPEN'
FROM companies c WHERE c.name = 'InfraCore Systems';

-- Drive 3: FinEdge — Data Analyst (UPCOMING)
INSERT IGNORE INTO drives
    (company_id, job_role, drive_date, venue, min_cgpa, max_backlogs, eligible_branches, status)
SELECT c.company_id, 'Data Analyst', '2026-12-05', 'Online (Google Meet)',
       7.0, 1, 'MCA, CSE, IT', 'UPCOMING'
FROM companies c WHERE c.name = 'FinEdge Analytics';

-- ── Students ─────────────────────────────────────────────────
-- Rahul: ELIGIBLE for TechNova (CGPA 8.7, MCA, 0 backlogs)
INSERT IGNORE INTO students (name, email, phone, branch, cgpa, backlogs) VALUES
('Rahul Patil',  'rahul.patil@college.edu',  '9001111111', 'MCA', 8.7, 0),
-- Amit: NOT ELIGIBLE for TechNova (CGPA 6.8 < 7.5) but eligible for InfraCore
('Amit Sharma',  'amit.sharma@college.edu',  '9002222222', 'MCA', 6.8, 0),
-- Sneha: ELIGIBLE for TechNova (CGPA 8.2, MCA, 0 backlogs)
('Sneha Joshi',  'sneha.joshi@college.edu',  '9003333333', 'MCA', 8.2, 0),
-- Kiran: Has backlogs — NOT ELIGIBLE for TechNova (max backlogs = 0)
('Kiran Mehta',  'kiran.mehta@college.edu',  '9004444444', 'CSE', 7.8, 2),
-- Deepa: Eligible for all
('Deepa Rao',    'deepa.rao@college.edu',    '9005555555', 'CSE', 9.1, 0);

-- ============================================================
-- HOW TO DEMONSTRATE THE BUSINESS FLOW
-- ============================================================
--
-- DEMO 1 — Rahul Patil (Eligible)
--   Go to Applications → select Rahul → TechNova Java Developer → Apply
--   Result: Application accepted ✓
--   Go to Interviews → schedule "Aptitude" round → mark PASS
--   Go to Interviews → schedule "Technical" round → mark PASS
--   Go to Selections → Rahul appears → set package 9.5 LPA → Finalise
--   Dashboard: counts increment live ✓
--
-- DEMO 2 — Amit Sharma (Not Eligible — CGPA fail)
--   Go to Applications → select Amit → TechNova Java Developer → Apply
--   Result: "CGPA requirement not met. Student: 6.80, Required: 7.50" ✗
--
-- DEMO 3 — Sneha Joshi (Eligible, apply but do not select yet)
--   Go to Applications → select Sneha → TechNova → Apply → success
--   Go to Selections → Sneha does NOT appear (no PASS interview yet)
--   Go to Interviews → mark PASS → now Sneha appears in Selections ✓
--
-- DEMO 4 — Duplicate application
--   Try applying Rahul to TechNova again
--   Result: "No duplicate application" rule triggers ✗
--
-- DEMO 5 — Closed drive
--   Close the InfraCore drive (edit → CLOSED)
--   Try applying any student → "Drive is not open" message ✗
-- ============================================================

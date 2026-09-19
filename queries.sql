-- EduTrack Data Audit — 12 queries
-- Target table: enrollments

-- ============================================================
-- Queries — Reading and Filtering
-- ============================================================

-- 1. List all enrollments for 'Intro to Python'
SELECT student_name, student_email, completion_percentage
FROM enrollments
WHERE course_title = 'Intro to Python';

-- 2. Enrollments where completion_percentage is less than 10 (potential dropouts)
SELECT *
FROM enrollments
WHERE completion_percentage < 10;

-- 3. Enrollments where instructor is NULL
SELECT *
FROM enrollments
WHERE instructor IS NULL;

-- 4. Five students with the highest completion_percentage who have not yet passed
SELECT student_name, student_email, course_title, completion_percentage, passed
FROM enrollments
WHERE passed = false
ORDER BY completion_percentage DESC
LIMIT 5;

-- 5. Enrollments created in the last year, newest first
SELECT *
FROM enrollments
WHERE enrollment_date >= CURRENT_DATE - INTERVAL '1 year'
ORDER BY enrollment_date DESC;

-- ============================================================
-- Queries — Data Corrections
-- Confirm with SELECT before UPDATE/DELETE.
-- ============================================================

-- 6. INSERT the missing enrollment from the edutrack.sql comments (id = 18)
INSERT INTO enrollments (
  id,
  student_id,
  student_name,
  student_email,
  course_id,
  course_title,
  category,
  enrollment_date,
  completion_percentage,
  passed,
  monthly_fee_paid,
  instructor
) VALUES (
  18,
  3,
  'Lucia Fernandes',
  'lucia.fernandes@student.edutrack.com',
  5,
  'Advanced Python',
  'Programming',
  '2025-04-01',
  0,
  false,
  69.99,
  'Carlos Vega'
);

-- 7. UPDATE NULL instructor values
-- Preview: SELECT * FROM enrollments WHERE instructor IS NULL;
UPDATE enrollments
SET instructor = 'Pending assignment'
WHERE instructor IS NULL;

-- 8. DELETE enrollments for imported @test.com accounts
-- Preview: SELECT * FROM enrollments WHERE student_email ILIKE '%@test.com';
DELETE FROM enrollments
WHERE student_email ILIKE '%@test.com';

-- ============================================================
-- Queries — Aggregation and Reporting
-- ============================================================

-- 9. Count enrollments grouped by category
SELECT category, COUNT(*) AS enrollment_count
FROM enrollments
GROUP BY category
ORDER BY enrollment_count DESC;

-- 10. Average completion_percentage grouped by course_title, lowest to highest
SELECT course_title, AVG(completion_percentage) AS avg_completion_percentage
FROM enrollments
GROUP BY course_title
ORDER BY avg_completion_percentage ASC;

-- 11. Courses with more than 3 enrollments
SELECT course_title, COUNT(*) AS enrollment_count
FROM enrollments
GROUP BY course_title
HAVING COUNT(*) > 3;

-- 12. Total revenue (SUM of monthly_fee_paid) by category, highest to lowest
SELECT category, SUM(monthly_fee_paid) AS total_revenue
FROM enrollments
GROUP BY category
ORDER BY total_revenue DESC;

-- EduTrack Data Audit — Related Tables
-- Target schema: students, courses, enrollments (normalized)
-- Every query uses at least one JOIN. No subqueries.
-- ON DELETE CASCADE is course theory only — not used here. FKs are
-- REFERENCES students(id) / courses(id) with the default NO ACTION.

-- ============================================================
-- Queries — INNER JOIN
-- ============================================================

-- 1. Every enrollment with student name, course title, and completion
SELECT
  s.name AS student_name,
  c.title AS course_title,
  e.completion_percentage
FROM enrollments AS e
INNER JOIN students AS s ON e.student_id = s.id
INNER JOIN courses AS c ON e.course_id = c.id
ORDER BY s.name, c.title;

-- 2. Students who passed at least one course (name, email, course title)
SELECT
  s.name,
  s.email,
  c.title AS course_title
FROM enrollments AS e
INNER JOIN students AS s ON e.student_id = s.id
INNER JOIN courses AS c ON e.course_id = c.id
WHERE e.passed = TRUE
ORDER BY s.name, c.title;

-- 3. Average completion percentage per instructor, highest to lowest
SELECT
  c.instructor_name,
  AVG(e.completion_percentage) AS avg_completion_percentage
FROM enrollments AS e
INNER JOIN courses AS c ON e.course_id = c.id
GROUP BY c.instructor_name
ORDER BY avg_completion_percentage DESC;

-- ============================================================
-- Queries — LEFT JOIN (detecting missing data)
-- ============================================================

-- 4. Students with no enrollments
SELECT
  s.id,
  s.name,
  s.email,
  s.signup_date
FROM students AS s
LEFT JOIN enrollments AS e ON s.id = e.student_id
WHERE e.id IS NULL;

-- 5. Courses with no enrollments
SELECT
  c.id,
  c.title,
  c.category,
  c.instructor_name,
  c.monthly_fee
FROM courses AS c
LEFT JOIN enrollments AS e ON c.id = e.course_id
WHERE e.id IS NULL;

-- ============================================================
-- Queries — Aggregation across tables
-- ============================================================

-- 6. Students enrolled in more than one course
SELECT
  s.name,
  COUNT(e.id) AS course_count
FROM students AS s
INNER JOIN enrollments AS e ON s.id = e.student_id
GROUP BY s.id, s.name
HAVING COUNT(e.id) > 1
ORDER BY course_count DESC, s.name;

-- 7. Total revenue per category using courses.monthly_fee
SELECT
  c.category,
  SUM(c.monthly_fee) AS total_revenue
FROM enrollments AS e
INNER JOIN courses AS c ON e.course_id = c.id
GROUP BY c.category
ORDER BY total_revenue DESC;

-- 8. Instructors and enrollment seats in their courses (COUNT of join rows)
SELECT
  c.instructor_name,
  COUNT(e.id) AS student_count
FROM enrollments AS e
INNER JOIN courses AS c ON e.course_id = c.id
GROUP BY c.instructor_name
ORDER BY student_count DESC, c.instructor_name;

-- ============================================================
-- Queries — Data integrity
-- ============================================================

-- 9. Enrollments whose student_id does not match any student
SELECT
  e.id,
  e.student_id,
  e.course_id,
  e.enrollment_date
FROM enrollments AS e
LEFT JOIN students AS s ON e.student_id = s.id
WHERE s.id IS NULL;

-- 10. Enrollments whose course_id does not match any course
SELECT
  e.id,
  e.student_id,
  e.course_id,
  e.enrollment_date
FROM enrollments AS e
LEFT JOIN courses AS c ON e.course_id = c.id
WHERE c.id IS NULL;

# EduTrack data audit — Related Tables

SQL audit of EduTrack’s normalized schema: `students`, `courses`, and `enrollments` joined by foreign keys.

## Files

- [`edutrack_v2.sql`](edutrack_v2.sql) — dump that creates and seeds the three tables
- [`queries.sql`](queries.sql) — 10 JOIN queries (INNER JOIN, LEFT JOIN, GROUP BY / HAVING)
- [`analysis_report.md`](analysis_report.md) — results for each query
- [`diagram.png`](diagram.png) — ER diagram from [diagram.4geeks.com](https://diagram.4geeks.com)

## How to run

1. Create or open a [Supabase](https://supabase.com) project.
2. In the SQL Editor, run the full [`edutrack_v2.sql`](https://raw.githubusercontent.com/4GeeksAcademy/ai-engineering-syllabus/refs/heads/main/content/projects/edutrack-data-audit-sql-related-tables/edutrack_v2.sql) dump.
3. Confirm with `SELECT * FROM enrollments LIMIT 5;`, `SELECT * FROM students LIMIT 5;`, and `SELECT * FROM courses LIMIT 5;`.
4. Model the tables on [diagram.4geeks.com](https://diagram.4geeks.com) before writing queries.
5. Run the statements in `queries.sql`.

Every query uses at least one JOIN. There are no subqueries. Cascade delete is theory only — it is not in `queries.sql`.

Auth coverage is not part of this SQL audit (no application auth). Check query syntax with `uv run pytest` (fails under 70% coverage of the syntax checker).

## What the queries cover

1. Every enrollment with student name, course title, and completion
2. Students who passed at least one course
3. Average completion per instructor
4. Students with no enrollments
5. Courses with no enrollments
6. Students enrolled in more than one course
7. Total revenue by category using `courses.monthly_fee`
8. Enrollment seats per instructor (`COUNT(e.id)`)
9. Enrollments whose `student_id` does not match a student
10. Enrollments whose `course_id` does not match a course

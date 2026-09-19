# EduTrack data audit

SQL audit of EduTrack’s `enrollments` table: filtering, data cleanup, and category reporting.

## Files

- [`queries.sql`](queries.sql) — 12 queries (SELECT, INSERT, UPDATE, DELETE, GROUP BY / HAVING)
- [`analysis_report.md`](analysis_report.md) — results for each query

Work is on `enrollments` only. `students` and `courses` are present in the dump for context.

## How to run

1. Create or open a [Supabase](https://supabase.com) project.
2. In the SQL Editor, run the full [`edutrack.sql`](https://raw.githubusercontent.com/4GeeksAcademy/ai-engineering-syllabus/refs/heads/main/content/projects/edutrack-data-audit-sql/edutrack.sql) dump.
3. Confirm with `SELECT * FROM enrollments LIMIT 5;`.
4. Run the statements in `queries.sql` in order.

Run a matching `SELECT` before the `UPDATE` and `DELETE`. The `INSERT` (id 18) will error if that row already exists.

## What the queries cover

1. Intro to Python enrollments (name, email, completion)
2. Completion under 10% (potential dropouts)
3. Null instructor
4. Top 5 completion among rows that have not passed
5. Enrollments in the last year
6. Insert the missing enrollment from the dump comments
7. Set null instructor to `Pending assignment`
8. Delete `@test.com` enrollments
9. Count by category
10. Average completion by course (lowest to highest)
11. Courses with more than 3 enrollments (`HAVING`)
12. Total `monthly_fee_paid` by category (highest to lowest)

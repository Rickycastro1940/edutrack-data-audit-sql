# EduTrack analysis report — Related Tables

Results come from joining `students`, `courses`, and `enrollments` after importing `edutrack_v2.sql`. Every query uses at least one JOIN. There are no subqueries. `ON DELETE CASCADE` is not in these queries (theory only; FKs use default `NO ACTION`).

## Entity-relationship diagram

See [`diagram.png`](diagram.png).

- Primary keys: `students.id`, `courses.id`, `enrollments.id`
- Foreign keys: `enrollments.student_id` → `students.id`, `enrollments.course_id` → `courses.id`
- 1:1 — none in this schema
- 1:n — one student has many enrollments; one course has many enrollments
- n:m — students and courses through `enrollments`

---

## Queries — INNER JOIN

### 1. Every enrollment: student full name, course title, completion percentage

Join: `enrollments` INNER JOIN `students` INNER JOIN `courses`.

Result: 16

- Emily Watson — Advanced Python — 40%
- Emily Watson — Intro to Python — 85%
- Emily Watson — Web Design Basics — 60%
- Klaus Weber — Data Analysis with SQL — 78%
- Klaus Weber — Intro to Python — 92%
- Lucia Fernandes — Advanced Python — 0%
- Lucia Fernandes — Digital Marketing 101 — 3%
- Lucia Fernandes — Web Design Basics — 5%
- Marco Rossi — Advanced Python — 95%
- Marco Rossi — Intro to Python — 88%
- Pierre Dubois — Data Analysis with SQL — 20%
- Pierre Dubois — UI/UX Fundamentals — 0%
- Priya Sharma — Digital Marketing 101 — 70%
- Priya Sharma — Intro to Python — 55%
- Yuki Nakamura — Data Analysis with SQL — 45%
- Yuki Nakamura — UI/UX Fundamentals — 0%

### 2. Students who passed at least one course: name, email, course title

Join: `enrollments` INNER JOIN `students` INNER JOIN `courses` WHERE `passed = TRUE`.

Result: 6

- Emily Watson — emily.watson@student.edutrack.com — Intro to Python
- Klaus Weber — klaus.weber@student.edutrack.com — Data Analysis with SQL
- Klaus Weber — klaus.weber@student.edutrack.com — Intro to Python
- Marco Rossi — marco.rossi@student.edutrack.com — Advanced Python
- Marco Rossi — marco.rossi@student.edutrack.com — Intro to Python
- Priya Sharma — priya.sharma@student.edutrack.com — Digital Marketing 101

Klaus Weber and Marco Rossi each passed two courses, so each appears twice.

### 3. Average completion percentage per instructor (highest to lowest)

Join: `enrollments` INNER JOIN `courses`. Instructor is `courses.instructor_name`.

Result: 4

- Marta López — 66.14
- Carlos Vega — 40.00
- Lucia Prades — 36.50
- Pending assignment — 0.00

---

## Queries — LEFT JOIN (detecting missing data)

### 4. Students with no enrollments

Join: `students` LEFT JOIN `enrollments` WHERE `enrollments.id IS NULL`.

Result: 1

- Giulia Romano — giulia.romano@student.edutrack.com — signup_date 2024-05-07

Registered on the platform and never signed up for a course.

### 5. Courses with no enrollments

Join: `courses` LEFT JOIN `enrollments` WHERE `enrollments.id IS NULL`.

Result: 1

- Email Campaigns — Marketing — Lucia Prades — monthly_fee 19.99

In the catalog; nobody has signed up.

---

## Queries — Aggregation across tables

### 6. Students enrolled in more than one course

Join: `students` INNER JOIN `enrollments`, `GROUP BY` student, `HAVING COUNT(*) > 1`.

Result: 7

- Emily Watson — 3
- Lucia Fernandes — 3
- Klaus Weber — 2
- Marco Rossi — 2
- Pierre Dubois — 2
- Priya Sharma — 2
- Yuki Nakamura — 2

Giulia Romano is excluded because she has zero enrollments.

### 7. Total revenue per category using `courses.monthly_fee`

Join: `enrollments` INNER JOIN `courses`. Sum is catalog `monthly_fee`, not `enrollments.monthly_fee_paid`.

Result:

- Programming — 409.93
- Data — 179.97
- Design — 169.96
- Marketing — 59.98

### 8. Instructors and number of students currently enrolled in their courses

Join: `enrollments` INNER JOIN `courses`. Count is `COUNT(e.id)` (enrollment seats).

Result: 4

- Marta López — 7
- Carlos Vega — 5
- Lucia Prades — 2
- Pending assignment — 2

---

## Queries — Data integrity

### 9. Enrollments whose `student_id` does not match any student (orphans)

Join: `enrollments` LEFT JOIN `students` WHERE `students.id IS NULL`.

Result: 0

No orphaned student references. `enrollments.student_id` references `students(id)`.

### 10. Enrollments whose `course_id` does not match any course (orphans)

Join: `enrollments` LEFT JOIN `courses` WHERE `courses.id IS NULL`.

Result: 0

No orphaned course references. `enrollments.course_id` references `courses(id)`.

---

## Finding (AI / data)

Query 8 was first written as `COUNT(DISTINCT e.student_id)`. That treats “students enrolled” as unique people, so Carlos Vega scored 3 (Emily is in two of his courses but counted once) and Marta López scored 6. The course wording is seats-in-courses; `COUNT(e.id)` is 5 for Carlos and 7 for Marta. The DISTINCT version is a plausible agent misread, not a SQL error.

Auth coverage does not apply: there is no app auth layer. RLS is disabled on `students`, `courses`, and `enrollments`, so the Data API can read those tables with the anon key. That is out of scope for the JOIN assignment.

Cascade delete: FKs are `REFERENCES students(id)` and `REFERENCES courses(id)` with no `ON DELETE CASCADE`. Deleting a student who still has enrollments fails. That behavior is not tested in Q1–Q10.

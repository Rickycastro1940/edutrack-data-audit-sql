# EduTrack analysis report

Results are from the live `enrollments` table after the data-correction queries (16 enrollments).

## Enrollments in 'Intro to Python'

Result: 4

- Emily Watson — emily.watson@student.edutrack.com — 85%
- Klaus Weber — klaus.weber@student.edutrack.com — 92%
- Marco Rossi — marco.rossi@student.edutrack.com — 88%
- Priya Sharma — priya.sharma@student.edutrack.com — 55%

## Enrollments where completion_percentage is less than 10

Result: 5

- Yuki Nakamura — UI/UX Fundamentals — 0%
- Pierre Dubois — UI/UX Fundamentals — 0%
- Lucia Fernandes — Advanced Python — 0%
- Lucia Fernandes — Digital Marketing 101 — 3%
- Lucia Fernandes — Web Design Basics — 5%

## Enrollments where instructor is NULL

Result: 0

Two rows matched this filter before the UPDATE (Yuki Nakamura and Pierre Dubois, both UI/UX Fundamentals). After assigning `pending assignment`, the same SELECT returns no rows.

## Five highest completion_percentage values where passed = false

Result: 5

- Emily Watson — Web Design Basics — 60%
- Priya Sharma — Intro to Python — 55%
- Yuki Nakamura — Data Analysis with SQL — 45%
- Emily Watson — Advanced Python — 40%
- Pierre Dubois — Data Analysis with SQL — 20%

## Enrollments created in the last year (ordered by enrollment_date descending)

Result: 0

`enrollment_date >= CURRENT_DATE - INTERVAL '1 year'` returned no rows on 19 Sep 2026. The newest enrollment is 2025-04-01 (id 18).

## INSERT missing enrollment (id 18)

Result: 1

- Lucia Fernandes — lucia.fernandes@student.edutrack.com — Advanced Python — 2025-04-01 — completion 0 — passed false — monthly_fee_paid 69.99 — instructor Carlos Vega

## UPDATE NULL instructor to 'pending assignment'

Result: 2

- id 10 — Yuki Nakamura — UI/UX Fundamentals
- id 11 — Pierre Dubois — UI/UX Fundamentals

## DELETE enrollments for @test.com accounts

Result: 2

- id 13 — James Miller — james.miller@test.com — Intro to Python
- id 14 — Alex Chen — alex.chen@test.com — Web Design Basics

Remaining `@test.com` enrollments: 0

## Enrollments by category

Result:

- Programming: 7
- Design: 4
- Data: 3
- Marketing: 2

## Average completion_percentage by course_title (lowest to highest)

Result:

- UI/UX Fundamentals: 0.00
- Web Design Basics: 32.50
- Digital Marketing 101: 36.50
- Advanced Python: 45.00
- Data Analysis with SQL: 47.67
- Intro to Python: 80.00

## Courses with more than 3 enrollments (HAVING)

Result:

- Intro to Python: 4

## Total revenue (SUM of monthly_fee_paid) by category (highest to lowest)

Result:

- Programming: 409.93
- Data: 179.97
- Design: 169.96
- Marketing: 59.98

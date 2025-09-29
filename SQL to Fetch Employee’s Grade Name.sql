SELECT
  papf.person_number,
  pgft.name gradename
FROM
  per_all_people_f papf,
  per_all_assignments_m paam,
  per_grades_f pgf,
  per_grades_f_tl pgft
WHERE
  papf.person_id = paam.person_id
  AND TRUNC(SYSDATE) BETWEEN papf.effective_start_date
  AND papf.effective_end_date
  AND paam.primary_assignment_flag = 'Y'
  AND paam.assignment_type = 'E'
  AND paam.effective_latest_change = 'Y'
  AND TRUNC(SYSDATE) BETWEEN paam.effective_start_date
  AND paam.effective_end_date
  AND paam.grade_id = pgf.grade_id
  AND TRUNC(SYSDATE) BETWEEN pgf.effective_start_date
  AND pgf.effective_end_date
  AND pgf.grade_id = pgft.grade_id
  AND pgft.language = 'US'
  AND TRUNC(SYSDATE) BETWEEN pgft.effective_start_date
  AND pgft.effective_end_date
  and papf.person_number = nvl(:personnumber, papf.person_number)
order by
  papf.person_number asc,
  pgft.name asc nulls first
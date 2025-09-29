SELECT
  papf.person_number,
  paam.assignment_number,
  pastt.user_status assignmentstatus
FROM
  per_all_people_f papf,
  per_all_assignments_m paam,
  per_assignment_status_types past,
  per_assignment_status_types_tl pastt
WHERE
  papf.person_id = paam.person_id
  AND paam.assignment_status_type_id = past.assignment_status_type_id
  AND past.assignment_status_type_id = pastt.assignment_status_type_id
  AND pastt.source_lang = upper('US')
  AND TRUNC(SYSDATE) BETWEEN papf.effective_start_date
  AND papf.effective_end_date
  AND paam.primary_assignment_flag = upper('Y')
  AND paam.assignment_type = 'E'
  and paam.effective_latest_change = upper('Y')
  AND TRUNC(SYSDATE) BETWEEN paam.effective_start_date
  AND paam.effective_end_date
  AND TRUNC(SYSDATE) BETWEEN past.start_date
  AND NVL(past.end_date, SYSDATE)
  AND papf.person_number = nvl(:personnumber, papf.person_number)
  AND paam.assignment_number = '0017'
order by
  papf.person_number asc,
  pastt.user_status asc nulls first
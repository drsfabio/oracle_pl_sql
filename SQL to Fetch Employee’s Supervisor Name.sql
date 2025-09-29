SELECT
  papf.person_number,
  ppnf.full_name supervisorname
FROM
  per_all_people_f papf,
  per_all_assignments_m paam,
  per_assignment_supervisors_f pasf,
  per_person_names_f ppnf
WHERE
  papf.person_id = paam.person_id
  AND paam.primary_assignment_flag = 'Y'
  AND paam.assignment_type = 'E'
  and paam.effective_latest_change = 'Y'
  AND TRUNC(SYSDATE) BETWEEN paam.effective_start_date
  AND paam.effective_end_date
  AND TRUNC(SYSDATE) BETWEEN paam.effective_start_date
  AND paam.effective_end_date
  AND papf.person_id = pasf.person_id
  AND pasf.manager_type = 'LINE_MANAGER'
  AND ppnf.person_id = pasf.manager_id
  AND ppnf.name_type = 'GLOBAL'
  AND TRUNC(SYSDATE) BETWEEN pasf.effective_start_date
  AND pasf.effective_end_date
  AND TRUNC(SYSDATE) BETWEEN ppnf.effective_start_date
  AND ppnf.effective_end_date
  and papf.person_number = nvl(:personnumber, papf.person_number)
order by
  papf.person_number asc,
  ppnf.full_name asc nulls first
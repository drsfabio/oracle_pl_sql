SELECT
  papf.person_number,
  hapf.POSITION_CODE,
  hapft.name positionname
FROM
  per_all_people_f papf,
  per_all_assignments_m paam,
  hr_all_positions_f hapf,
  hr_all_positions_f_tl hapft
WHERE
  papf.person_id = paam.person_id
  AND TRUNC(SYSDATE) BETWEEN papf.effective_start_date
  AND papf.effective_end_date
  AND paam.primary_assignment_flag = 'Y'
  AND paam.assignment_type = 'E'
  AND paam.effective_latest_change = 'Y'
  AND TRUNC(SYSDATE) BETWEEN paam.effective_start_date
  AND paam.effective_end_date
  AND paam.position_id = hapf.position_id
  AND TRUNC(SYSDATE) BETWEEN hapf.effective_start_date
  AND hapf.effective_end_date
  AND hapf.position_id = hapft.position_id
  AND hapft.language = 'US'
  AND TRUNC(SYSDATE) BETWEEN hapft.effective_start_date
  AND hapft.effective_end_date
  and papf.person_number = nvl(:personnumber, papf.person_number)
order by
  papf.person_number asc,
  hapft.name asc nulls first
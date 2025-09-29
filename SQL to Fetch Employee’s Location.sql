SELECT
  papf.person_number,
  pldft.location_name locationname
FROM
  per_all_people_f papf,
  per_all_assignments_m paam,
  per_location_details_f pldf,
  per_location_details_f_tl pldft
WHERE
  papf.person_id = paam.person_id
  AND TRUNC(SYSDATE) BETWEEN papf.effective_start_date
  AND papf.effective_end_date
  AND paam.primary_assignment_flag = 'Y'
  AND paam.assignment_type = 'E'
  AND paam.effective_latest_change = 'Y'
  AND TRUNC(SYSDATE) BETWEEN paam.effective_start_date
  AND paam.effective_end_date
  AND paam.location_id = pldf.location_id
  AND TRUNC(SYSDATE) BETWEEN pldf.effective_start_date
  AND pldf.effective_end_date
  AND pldf.location_details_id = pldft.location_details_id
  AND pldft.language = 'US'
  AND TRUNC(SYSDATE) BETWEEN pldft.effective_start_date
  AND pldft.effective_end_date
  and papf.person_number = nvl(:personnumber, papf.person_number)
order by
  papf.person_number asc,
  pldft.location_name asc nulls first
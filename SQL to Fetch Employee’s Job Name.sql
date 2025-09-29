SELECT
  papf.person_number,
  pjft.name jobname
FROM
  per_all_people_f papf,
  per_all_assignments_m paam,
  per_jobs_f pjf,
  per_jobs_f_tl pjft
WHERE
  papf.person_id = paam.person_id
  AND TRUNC(SYSDATE) BETWEEN papf.effective_start_date
  AND papf.effective_end_date
  AND paam.primary_assignment_flag = 'Y'
  AND paam.assignment_type = 'E'
  and paam.effective_latest_change = 'Y'
  AND TRUNC(SYSDATE) BETWEEN paam.effective_start_date
  AND paam.effective_end_date
  AND paam.job_id = pjf.job_id
  AND TRUNC(SYSDATE) BETWEEN pjf.effective_start_date
  AND pjf.effective_end_date
  AND pjf.job_id = pjft.job_id
  AND pjft.language = 'US'
  AND TRUNC(SYSDATE) BETWEEN pjft.effective_start_date
  AND pjft.effective_end_date
  and papf.person_number = nvl(:personnumber, papf.person_number)
order by
  papf.person_number asc,
  pjft.name asc nulls first
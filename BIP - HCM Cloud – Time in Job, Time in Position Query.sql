SELECT papf.person_number
,paam.assignment_number
,paam.assignment_status_type
,pjfv.name Job_Name
,hapfv.name Position_Name
,round((
months_between(sysdate, (
SELECT MIN(paam1.effective_start_date)
FROM per_all_assignments_m paam1
WHERE paam1.person_id = paam.person_id
AND paam1.assignment_id = paam.assignment_id /* Remove this if you want the time to be calculated even across global transfers/rehires */
AND paam1.assignment_type NOT IN ('ET','CT','PT')
AND paam1.job_id = paam.job_id
AND NOT EXISTS (
SELECT 'x'
FROM per_all_assignments_m paam2
WHERE paam2.person_id = paam.person_id
AND paam2.assignment_id = paam.assignment_id /* Remove this if you want the time to be calculated even across global transfers/rehires */
AND paam2.job_id <> paam1.job_id
AND paam2.assignment_type NOT IN ('ET','CT','PT')
AND paam2.effective_start_date > paam1.effective_start_date
)
)) / 12
), 2) time_in_job_years
,round((
months_between(sysdate, (
SELECT MIN(paam1.effective_start_date)
FROM per_all_assignments_m paam1
WHERE paam1.person_id = paam.person_id
AND paam1.assignment_id = paam.assignment_id /* Remove this if you want the time to be calculated even across global transfers/rehires */
AND paam1.assignment_type NOT IN ('ET','CT','PT')
AND paam1.position_id = paam.position_id
AND NOT EXISTS (
SELECT 'x'
FROM per_all_assignments_m paam2
WHERE paam2.person_id = paam.person_id
AND paam2.assignment_id = paam.assignment_id /* Remove this if you want the time to be calculated even across global transfers/rehires */
AND paam2.position_id <> paam1.position_id
AND paam2.assignment_type NOT IN ('ET','CT','PT')
AND paam2.effective_start_date > paam1.effective_start_date
)
)) / 12
), 2) time_in_position_years
FROM per_all_assignments_m paam
,per_all_people_f papf
,HR_ALL_POSITIONS_F_VL hapfv
,PER_JOBS_F_VL pjfv
WHERE papf.person_id = paam.person_id
AND paam.assignment_type NOT IN ('ET','CT','PT')
AND paam.assignment_status_type = 'ACTIVE'
AND paam.primary_flag = 'Y'
AND paam.effective_latest_change = 'Y'
AND paam.position_id = hapfv.position_id(+)
AND paam.job_id = pjfv.job_id(+)
AND sysdate BETWEEN pjfv.effective_start_date(+)
AND pjfv.effective_end_date(+)
AND sysdate BETWEEN hapfv.effective_start_date(+)
AND hapfv.effective_end_date(+)
AND sysdate BETWEEN papf.effective_start_date
AND papf.effective_end_date
AND sysdate BETWEEN paam.effective_start_date
AND paam.effective_end_date
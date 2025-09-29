SELECT papf.person_number,
    ppnf.first_name,
    ppnf.middle_names,
    ppnf.last_name,
    ppnf.title,
    pjft.name job_name,
    hauft.name department_name,
    haouf.attribute1,
    haouf.attribute2,
    haouf.attribute3,
    haouf.attribute4,
    to_char (ppos.date_start, 'DD-MM-RRRR', 'nls_date_language=American') date_of_joining,
    to_char (pp.date_of_birth, 'DD-MM-RRRR', 'nls_date_language=American') date_of_birth,
    to_char (ppos.actual_termination_date, 'DD-MM-RRRR', 'nls_date_language=American') actual_termination_date
FROM per_all_people_f papf,
per_person_names_f ppnf,
per_all_assignments_m paam,
per_jobs_f_tl pjft,
per_periods_of_service ppos,
per_persons pp,
hr_all_organization_units_f haouf,
hr_organization_units_f_tl hauft
WHERE paam.person_id = ppnf.person_id
    AND papf.person_id = ppnf.person_id
    AND papf.person_id = paam.person_id
    AND paam.job_id = pjft.job_id(+)
    AND pjft.language = USERENV('LANG')
    AND hauft.language = 'US'
    AND paam.period_of_service_id = ppos.period_of_service_id
    AND paam.person_id = pp.person_id
    AND haouf.organization_id = paam.organization_id
    AND haouf.organization_id = hauft.organization_id
    AND TRUNC(SYSDATE)BETWEEN papf.effective_start_date
    AND papf.effective_end_date
    AND TRUNC(SYSDATE)BETWEEN paam.effective_start_date
    AND paam.effective_end_date
    AND TRUNC(SYSDATE)BETWEEN ppnf.effective_start_date
    AND ppnf.effective_end_date
    AND TRUNC(SYSDATE)BETWEEN haouf.effective_start_date
    AND haouf.effective_end_date
    AND TRUNC(SYSDATE)BETWEEN hauft.effective_start_date
    AND hauft.effective_end_date
    AND TRUNC(SYSDATE)BETWEEN pjft.effective_start_date
    AND pjft.effective_end_date
    AND paam.effective_latest_change = 'Y'
    AND paam.primary_flag = 'Y'
    AND paam.assignment_type = 'E'
    --AND paam.assignment_status_type = 'ACTIVE'
    AND ppnf.name_type = 'GLOBAL'
    --AND ppnf.last_name LIKE '%DOS REIS SILVA%'
    --AND papf.person_number IN ('5924','3403', '849')
    AND ppnf.full_name LIKE '%JORGE RICARDO%'
ORDER BY 1, 2
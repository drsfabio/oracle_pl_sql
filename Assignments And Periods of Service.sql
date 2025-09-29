SELECT
paam.person_id,
paam.assignment_id,
paam.assignment_name,
paam.assignment_number,
paam.assignment_sequence,
paam.action_code,
paam.reason_code,
paam.effective_start_date,
paam.effective_end_date,
ppnf.full_name,
paam.period_of_service_id,
ppos.date_start,
ppos.actual_termination_date
FROM
per_all_assignments_m paam
LEFT JOIN per_periods_of_service ppos
ON ppos.period_of_service_id = paam.period_of_service_id
        AND ppos.person_id = paam.person_id
LEFT JOIN per_person_names_f ppnf
ON ppnf.person_id = paam.person_id
        AND ppnf.name_type = 'GLOBAL'
        AND paam.effective_start_date between ppnf.effective_start_date
        AND ppnf.effective_end_date
WHERE
paam.assignment_status_type = 'ACTIVE'
        AND paam.assignment_type = 'E'
        AND paam.effective_latest_change = 'Y'
        AND TRUNC(
    SYSDATE)
between paam.effective_start_date
        AND paam.effective_end_date
--AND paam.assignment_number = '0041949'
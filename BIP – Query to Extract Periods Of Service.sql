SELECT DISTINCT
    allpeople.person_number,
    to_char(
        periodsofservice.date_start, 'RRRR/MM/DD'
    ) date_start,
    to_char(
        nvl(
            periodsofservice.actual_termination_date, '4712-12-31'
        ), 'RRRR/MM/DD'
    ) actual_termination_date,
    personnames.first_name,
    personnames.last_name,
    personnames.full_name,
    to_char(
        personnames.effective_end_date, 'RRRR/MM/DD'
    ) effective_end_date,
    allassignments.assignment_number,
    allassignments.assignment_type,
    allassignments.employee_category,
    allassignments.assignment_status_type,
    SUBSTR(
        allassignments.assignment_number, 1, 3
    ) employer,
    SUBSTR(
        allassignments.assignment_number, 4, 10
    ) employee
FROM
    per_periods_of_service periodsofservice
    INNER JOIN per_all_people_f      allpeople ON allpeople.person_id = periodsofservice.person_id
    INNER JOIN per_person_names_f    personnames ON personnames.person_id = periodsofservice.person_id
                                                 AND personnames.name_type = 'GLOBAL'
                                                 AND sysdate BETWEEN personnames.effective_start_date AND personnames.effective_end_date
    INNER JOIN per_all_assignments_m allassignments ON allassignments.person_id = periodsofservice.person_id
                                                       AND allassignments.period_of_service_id = periodsofservice.period_of_service_id
                                                       AND sysdate BETWEEN allassignments.effective_start_date AND allassignments.effective_end_date
                                                       AND allassignments.assignment_type <> 'ET'
    LEFT OUTER JOIN xle_establishment_v   establishment ON establishment.establishment_id = periodsofservice.legal_entity_id;
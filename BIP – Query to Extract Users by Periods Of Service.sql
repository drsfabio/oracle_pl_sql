SELECT DISTINCT
  allpeople.person_number,
  personnames.first_name,
  personnames.last_name,
  personnames.full_name,
  to_char (periodsofservice.date_start, 'RRRR-MM-DD') date_start,
  to_char (
    nvl (
      periodsofservice.actual_termination_date,
      '4712-12-31'
    ),
    'RRRR-MM-DD'
  ) actual_termination_date,
  allassignments.assignment_number,
  allassignments.primary_flag,
  allassignments.assignment_type,
  allassignments.assignment_status_type,
  substr (
    allassignments.assignment_number,
    1,
    3
  ) employer,
  substr (allassignments.assignment_number, 4) employee,
  users.username,
  users.user_guid
FROM
  per_periods_of_service periodsofservice
  INNER JOIN per_all_assignments_m allassignments ON allassignments.person_id = periodsofservice.person_id
  AND allassignments.period_of_service_id = periodsofservice.period_of_service_id
  AND sysdate BETWEEN allassignments.effective_start_date
  AND allassignments.effective_end_date
  AND allassignments.assignment_type = 'E'
  INNER JOIN per_all_people_f allpeople ON allpeople.person_id = periodsofservice.person_id
  AND sysdate BETWEEN allpeople.effective_start_date
  AND allpeople.effective_end_date
  INNER JOIN per_person_names_f personnames ON personnames.person_id = allassignments.person_id
  AND personnames.name_type = 'BR'
  AND allassignments.effective_end_date BETWEEN personnames.effective_start_date
  AND personnames.effective_end_date
  INNER JOIN per_users users ON users.person_id = periodsofservice.person_id
WHERE
  assignment_status_type = 'ACTIVE'
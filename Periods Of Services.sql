-- Resultado em PER_PERIODS_OF_SERVICE: 98.290 - 98.306
WITH consistencia AS (
  SELECT
    allpeople.person_number,
    allassignments.assignment_number,
    substr(allassignments.assignment_number, 1, 3) AS employer,
    substr(allassignments.assignment_number, 4) AS employee,
    personnames.first_name,
    personnames.last_name,
    personnames.full_name,
    to_char(periodsofservice.date_start, 'RRRR-MM-DD') AS date_start,
    to_char(
      NVL(
        periodsofservice.actual_termination_date,
        '4712-12-31'
      ),
      'RRRR-MM-DD'
    ) AS actual_termination_date,
    allassignments.primary_flag,
    allassignments.assignment_type,
    allassignments.assignment_status_type,
    allassignments.ACTION_CODE
  FROM
    per_periods_of_service periodsofservice
    INNER JOIN per_all_assignments_m allassignments ON allassignments.person_id = periodsofservice.person_id
    AND allassignments.period_of_service_id = periodsofservice.period_of_service_id
    AND SYSDATE BETWEEN allassignments.effective_start_date
    AND allassignments.effective_end_date
    AND allassignments.assignment_type = 'E'
    AND allassignments.assignment_status_type = 'ACTIVE'
    INNER JOIN per_all_people_f allpeople ON allpeople.person_id = periodsofservice.person_id
    AND SYSDATE BETWEEN allpeople.effective_start_date
    AND allpeople.effective_end_date
    INNER JOIN per_person_names_f personnames ON personnames.person_id = allassignments.person_id
    AND personnames.name_type = 'BR'
    AND allassignments.effective_end_date BETWEEN personnames.effective_start_date
    AND personnames.effective_end_date
  WHERE
    1 = 1
    AND REGEXP_LIKE(allassignments.assignment_number, '^[0-9]+$')
    AND (
      allassignments.ACTION_CODE = 'HIRE'
      OR allassignments.ACTION_CODE = 'REHIRE'
    )
  ORDER BY
    1
)
SELECT
  person_number,
  assignment_number,
  employer,
  employee,
  first_name,
  last_name,
  full_name,
  date_start,
  actual_termination_date,
  primary_flag,
  assignment_type,
  assignment_status_type,
  action_code
FROM
  consistencia
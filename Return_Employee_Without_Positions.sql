SELECT COUNT(1) AS "Employee Position Empty"
FROM PER_ALL_ASSIGNMENTS_M ASG
INNER JOIN PER_PERSON_NAMES_F pern ON (asg.person_id = pern.person_id
                                       AND pern.name_type = 'GLOBAL'
                                       AND trunc(sysdate) BETWEEN pern.effective_start_date AND pern.effective_end_date)
INNER JOIN PER_PERSONS_V perv ON (asg.person_id = perv.person_id)
LEFT JOIN HR_ALL_POSITIONS_F_VL POS ON (POS.POSITION_ID = ASG.POSITION_ID
                                        AND ASG.EFFECTIVE_END_DATE BETWEEN POS.EFFECTIVE_START_DATE AND POS.EFFECTIVE_END_DATE)
WHERE asg.assignment_type = 'E'
  AND trunc(sysdate) BETWEEN asg.effective_start_date AND asg.effective_end_date
  AND asg.assignment_status_type <> 'INACTIVE'
  AND pos.name IS NULL
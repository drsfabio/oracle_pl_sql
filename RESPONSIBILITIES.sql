SELECT
  pn.DISPLAY_NAME,
  pall.PERSON_NUMBER,
  asg.ASSIGNMENT_NUMBER,
  aor.*
FROM
  fusion.PER_ASG_RESPONSIBILITIES aor
  JOIN fusion.PER_PERSON_NAMES_F pn ON aor.PERSON_ID = pn.PERSON_ID
  JOIN fusion.PER_ALL_PEOPLE_F pall ON aor.PERSON_ID = pall.PERSON_ID
  JOIN fusion.PER_ALL_ASSIGNMENTS_M asg ON aor.PERSON_ID = asg.PERSON_ID
WHERE
  TRUNC(sysdate) BETWEEN pn.effective_start_date
  AND pn.effective_end_date
  AND pn.NAME_TYPE = 'GLOBAL'
  AND asg.ASSIGNMENT_TYPE IN ('E', 'C', 'N', 'P')
  AND TRUNC(sysdate) BETWEEN asg.effective_start_date
  AND asg.effective_end_date
  and aor.RESPONSIBILITY_TYPE = 'HR_REP'
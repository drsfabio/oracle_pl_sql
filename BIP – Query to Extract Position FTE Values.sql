SELECT Positions.POSITION_CODE "Position Code"
      ,Positions.NAME "Position Name"
      ,Positions.FTE "Position Current FTE"
      ,Positions.INCUMBENT_FTE "Current Incumbent FTE"
      ,Positions.FTE - Positions.INCUMBENT_FTE "Difference FTE"
  FROM
(SELECT HAPF.POSITION_CODE, HAPFT.NAME,
        HAPF.FTE, 
        (select SUM(PAWMF.VALUE)
           from per_all_assignments_m PAAM,
                per_assign_work_measures_f PAWMF
          where 1 = 1
            AND PAAM.POSITION_ID = HAPF.POSITION_ID 
            AND SYSDATE  BETWEEN PAAM.EFFECTIVE_START_DATE AND PAAM.EFFECTIVE_END_DATE
            AND PAAM.ASSIGNMENT_TYPE = 'E'
            AND PAAM.ASSIGNMENT_STATUS_TYPE = 'ACTIVE'
            AND PAAM.ASSIGNMENT_ID = PAWMF.ASSIGNMENT_ID
            AND PAWMF.UNIT = 'FTE') AS INCUMBENT_FTE
   FROM hr_all_positions_f HAPF, 
        hr_all_positions_f_tl HAPFT
  WHERE HAPF.POSITION_ID = HAPFT.POSITION_ID 
    AND USERENV('LANG') = HAPFT.LANGUAGE 
    AND TRUNC(SYSDATE)  BETWEEN HAPF.EFFECTIVE_START_DATE AND HAPF.EFFECTIVE_END_DATE
    AND TRUNC(SYSDATE)  BETWEEN HAPFT.EFFECTIVE_START_DATE AND HAPFT.EFFECTIVE_END_DATE
  ORDER BY HAPFT.NAME ) Positions
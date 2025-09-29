SELECT DISTINCT 
       TO_CHAR (pvgf.effective_start_date, 'DD/MON/YYYY') effective_start_date,
       TO_CHAR (pvgf.effective_end_date, 'DD/MON/YYYY') effective_end_date,
       pjfv.job_code,
       pjfv.name job_name,
       pgfv.grade_code,
       pgfv.name grade_name,
       pvgf.valid_grade_id,
       pgfv.grade_id,
       pjfv.job_id
  FROM per_valid_grades_f pvgf,
       per_jobs_f_vl pjfv,
       per_grades_f_vl pgfv 
 WHERE 1=1
   AND pvgf.job_id = pjfv.job_id
   AND pvgf.grade_id = pgfv.grade_id
   AND pvgf.effective_start_date BETWEEN pjfv.effective_start_date AND pjfv.effective_end_date
   AND pvgf.effective_start_date BETWEEN pgfv.effective_start_date AND pgfv.effective_end_date
ORDER BY job_code,grade_code
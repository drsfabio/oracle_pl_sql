SELECT COUNT(*) Colaboradores_Ativos
FROM per_all_assignments_m paam
INNER JOIN per_all_people_f papf_emp ON papf_emp.person_id = paam.person_id
AND TRUNC(SYSDATE) BETWEEN papf_emp.effective_start_date AND papf_emp.effective_end_date
INNER JOIN per_person_names_f ppnf ON ppnf.person_id = papf_emp.person_id
AND ppnf.name_type ='GLOBAL'
AND TRUNC(SYSDATE) BETWEEN ppnf.effective_start_date AND ppnf.effective_end_date
LEFT JOIN hr_all_positions_f hapf ON hapf.position_id = paam.position_id
AND TRUNC(SYSDATE) BETWEEN hapf.effective_start_date AND hapf.effective_end_date
LEFT JOIN hr_all_positions_f_tl hapft ON hapft.position_id = hapf.position_id
AND USERENV('LANG') = hapft.LANGUAGE
AND TRUNC(SYSDATE) BETWEEN hapft.effective_start_date AND hapft.effective_end_date
WHERE TRUNC(SYSDATE) BETWEEN paam.effective_start_date AND paam.effective_end_date
  AND paam.assignment_type ='E'
  AND paam.assignment_status_type = 'ACTIVE'
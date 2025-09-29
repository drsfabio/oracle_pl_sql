SELECT papf.person_number
      ,paam.assignment_number
      ,houft.name legal_entity_name
      ,bbrf.benefit_relation_name
      ,bbrf.status
      ,TO_CHAR(bbrf.effective_start_date,'YYYY/MM/DD') effective_start_date
      ,TO_CHAR(bbrf.effective_end_date,'YYYY/MM/DD') effective_end_date 
  FROM per_all_people_f papf 
      ,per_all_assignments_m paam  
      ,ben_benefit_relations_f bbrf
      ,hr_organization_units_f_tl houft
 WHERE 1 =1 
   AND bbrf.person_id = papf.person_id 
   AND paam.person_id = papf.person_id 
   AND bbrf.rel_prmry_asg_id = paam.assignment_id   
   AND bbrf.legal_entity_id = houft.organization_id 
   AND houft.LANGUAGE = 'US'
   AND paam.assignment_type NOT LIKE '%T'
   AND paam.effective_latest_change = 'Y'
   AND TRUNC(SYSDATE) BETWEEN papf.effective_start_date AND papf.effective_end_date
   AND TRUNC(SYSDATE) BETWEEN paam.effective_start_date AND paam.effective_end_date
 ORDER BY papf.person_number,paam.assignment_number,bbrf.effective_start_date
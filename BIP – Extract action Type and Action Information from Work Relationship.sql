SELECT papf.person_number
      ,ppnf.full_name
      ,pao.action_type_code
      ,pav.action_name
      ,part.action_reason termination_reason 
  FROM per_all_people_f papf
      ,per_person_names_f ppnf
      ,per_periods_of_service ppos
      ,per_actions_vl pav
      ,per_action_reasons_tl part
      ,per_action_occurrences pao
 WHERE papf.person_id =ppnf.person_id 
   AND papf.person_id =ppos.person_id  
   AND UPPER(ppnf.name_type)='GLOBAL' 
  --AND TO_CHAR(ppos.actual_termination_date,'dd-mm-yyyy')<TO_CHAR(SYSDATE,'dd-mm-yyyy') 
   AND ppos.action_occurrence_id = pao.action_occurrence_id 
   AND pao.action_reason_id = part.action_reason_id (+)
   AND part.language (+) = USERENV('LANG')
   AND TRUNC(SYSDATE) BETWEEN TRUNC(papf.effective_start_date) AND TRUNC(papf.effective_end_date)
   AND TRUNC(SYSDATE) BETWEEN TRUNC(ppnf.effective_start_date) AND TRUNC(ppnf.effective_end_date)
   AND papf.person_number = '123351'
   AND pao.action_id = pav.action_id
order by papf.person_number
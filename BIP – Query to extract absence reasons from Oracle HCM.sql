SELECT aarft.name absence_reason_name
      ,to_char(aarf.effective_start_date,'YYYY/MM/DD') reason_start_date
      ,to_char(aarf.effective_end_date,'YYYY/MM/DD') reason_end_date
      ,aarf.legislation_code legislation_code
      ,aarf.status reason_status
      ,aarft.description reason_description
      ,aarf.base_name reason_base_name
  FROM ANC_ABSENCE_REASONS_F aarf
      ,ANC_ABSENCE_REASONS_F_TL aarft
 WHERE aarf.absence_reason_id=aarft.absence_reason_id
   AND aarf.effective_start_date BETWEEN aarft.effective_start_date AND aarft.effective_end_date
   AND aarft.language=userenv('LANG')
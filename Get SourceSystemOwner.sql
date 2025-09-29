SELECT papf.person_number ,
       h.source_system_owner ,
       h.source_system_id ,
       h.surrogate_id
FROM HRC_INTEGRATION_KEY_MAP h ,
     PER_ALL_PEOPLE_F Papf
WHERE h.object_name = 'Person'
  AND h.surrogate_id = papf.PERSON_ID
  AND sysdate BETWEEN papf.effective_start_date AND papf.effective_end_date
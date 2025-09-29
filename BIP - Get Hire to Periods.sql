SELECT   to_char(trunc(ppos.last_update_date), 'YYYY-MM-DD') AS "Last Update",
         part.action_reason AS "Motivo",
         COUNT(1) AS "Total de Registros"
FROM     per_all_people_f papf,
         per_person_names_f ppnf,
         per_periods_of_service_v ppos,
         per_action_reasons_tl part,
         per_action_occurrences pao
WHERE    papf.person_id = ppnf.person_id
AND      papf.person_id = ppos.person_id
AND      UPPER(ppnf.name_type) = UPPER('GLOBAL')
AND      ppos.action_occurrence_id = pao.action_occurrence_id
AND      pao.action_reason_id = part.action_reason_id
AND      part.language = userenv('LANG')
AND      trunc(SYSDATE) BETWEEN trunc(papf.effective_start_date)
AND      trunc(papf.effective_end_date)
AND      trunc(SYSDATE) BETWEEN trunc(ppnf.effective_start_date)
AND      trunc(ppnf.effective_end_date)
AND      ppos.last_update_date >= '2024-09-18'
GROUP BY to_char(trunc(ppos.last_update_date), 'YYYY-MM-DD'),
         part.action_reasonorder BY 1 desc
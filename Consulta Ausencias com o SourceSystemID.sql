SELECT map.OBJECT_NAME, map.GUID, map.SURROGATE_ID, map.SOURCE_SYSTEM_ID, abs_entries.START_DATE, abs_types_vl.NAME,abs_entries.END_DATE
FROM anc_per_abs_entries  abs_entries
-- Relaciona o tipos de ausencias com as ausencias registradas
LEFT JOIN anc_absence_types_f abs_types_f ON abs_types_f.absence_type_id = abs_entries.absence_type_id
AND SYSDATE between abs_types_f.effective_start_date AND abs_types_f.effective_end_date
-- Relaciona as traduções dos tipos de ausencias com os tipos de ausencias
INNER JOIN anc_absence_types_vl abs_types_vl ON abs_types_vl.absence_type_id = abs_entries.absence_type_id
AND abs_types_vl.status = upper('A')
AND TRUNC (SYSDATE) BETWEEN abs_types_vl.effective_start_date
AND abs_types_vl.effective_end_date
-- Relacion a fonte de entrada de dados aos registros de ausencias
LEFT JOIN hrc_integration_key_map map ON map.SURROGATE_ID = abs_entries.PER_ABSENCE_ENTRY_ID
--AND map.OBJECT_NAME = 'PesonAbsenceEntry'
WHERE ROWNUM < 2000 AND abs_entries.END_DATE = TO_DATE('2100-12-30','YYYY-MM-DD')
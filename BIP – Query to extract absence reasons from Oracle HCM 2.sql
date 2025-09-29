SELECT papf.person_number
,type.name absence_type
,fdt.dm_document_id ucm_content_id
,fdt.file_name
,to_char(apae.start_date,'DD-Mon-RRRR', 'nls_date_language=American') absence_start_date
,to_char(apae.end_date,'DD-Mon-RRRR', 'nls_date_language=American') absence_end_date
,apae.source
FROM fnd_attached_documents fad
,fnd_documents_tl fdt
,anc_per_abs_entries apae
,anc_absence_types_vl type
,per_all_people_f papf
WHERE 1 = 1
AND fad.entity_name ='ANC_ATTACHMENT'
AND fad.pk1_value = apae.per_absence_entry_id
AND fdt.document_id = fad.document_id
AND fdt.language = userenv('LANG')
AND apae.absence_type_id = type.absence_type_id
--AND type.name = 'Sick Leave'
AND papf.person_id = apae.person_id
-- AND papf.person_number in (:PERSON_NUMBER)
AND trunc(SYSDATE) BETWEEN papf.effective_start_date AND papf.effective_end_date
SELECT DATA_ROW
FROM
  (SELECT 'METADATA' || CHR (124) || 'PersonAbsenceEntry' || CHR (124) || 'PerAbsenceEntryId' || CHR (124) || 'AbsenceStatus' || CHR (124) || 'AbsenceTypeId' || CHR (124) || 'AssignmentId' || CHR (124) || 'EmployerId' || CHR (124) || 'PersonId' || CHR (124) || 'StartDate' || CHR (124) || 'EndDate' || CHR (124) || 'SourceSystemId' || CHR (124) || 'SourceSystemOwner' AS DATA_ROW
   FROM DUAL
   UNION ALL SELECT 'MERGE' || CHR (124) || 'PersonAbsenceEntry' || CHR (124) || apae.per_absence_entry_id || CHR (124) || 'ORA_WITHDRAWN' || CHR (124) || apae.absence_type_id || CHR (124) || apae.assignment_id || CHR (124) || apae.legal_entity_id || CHR (124) || apae.person_id || CHR (124) || to_char(apae.start_date,'RRRR/MM/DD') || CHR (124) || to_char(apae.end_date,'RRRR/MM/DD') || CHR (124) || hikm.source_system_id || CHR (124) || hikm.source_system_owner
   FROM ANC_PER_ABS_ENTRIES apae,
        HRC_INTEGRATION_KEY_MAP hikm
   WHERE hikm.surrogate_id = apae.per_absence_entry_id)
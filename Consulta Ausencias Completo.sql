SELECT
    DISTINCT SUBSTR(allassignment.assignment_number, 1, 3) employer,
    SUBSTR(allassignment.assignment_number, 4, 50) employee,
    allassignment.assignment_number,
    absencerecords.abs_record_source,
    absencerecords.per_absence_entry_id,
    absencerecords.period_of_service_id,
    absencerecords.single_day_flag,
    absencerecords.start_date_duration,
    absencerecords.end_date_duration,
    absencerecords.legal_entity_id,
    absencerecords.person_id,
    absencerecords.absence_type_id,
    absencetypes.name,
    absencetypes.attribute1 absencetypes_attr1,
    absencetypes.attribute2 absencetypes_attr2,
    absencetypes.attribute3 absencetypes_attr3,
    absencerecords.absence_entry_basic_flag,
    absencerecords.absence_status_cd,
    absencerecords.approval_status_cd,
    absencerecords.approval_datetime,
    absencerecords.start_date,
    absencerecords.start_datetime,
    absencerecords.end_datetime,
    absencerecords.end_date,
    absencerecords.start_time,
    absencerecords.end_time,
    absencerecords.duration,
    absencerecords.created_by,
    absencerecords.creation_date,
    absencerecords.last_updated_by,
    absencerecords.last_update_date,
    absencerecords.attribute1 absencerecords_attr1,
    absencerecords.attribute2 absencerecords_attr2,
    absencerecords.user_mode,
    absencerecords.source,
    absencerecords.legislation_code,
    absencerecords.overridden,
    absencerecords.assignment_id,
    absencetype.base_name,
    absencetype.status,
    absencetype.min_duration,
    absencetype.max_duration_rule_cd,
    absencetype.max_duration,
    absencetype.agreement_flag
FROM
anc_per_abs_entries absencerecords
LEFT JOIN anc_absence_types_f absencetype ON absencetype.absence_type_id = absencerecords.absence_type_id
AND SYSDATE between absencetype.effective_start_date
AND absencetype.effective_end_date
INNER JOIN anc_absence_types_vl absencetypes ON absencetypes.absence_type_id = absencerecords.absence_type_id
AND absencetypes.status = upper('a')
AND TRUNC(SYSDATE) between absencetypes.effective_start_date
AND absencetypes.effective_end_date
INNER JOIN per_all_assignments_m allassignment ON allassignment.assignment_id = absencerecords.assignment_id
AND allassignment.assignment_type = upper('e')
AND allassignment.assignment_status_type = upper('active')
AND allassignment.effective_latest_change = upper('y')
AND TRUNC(SYSDATE) between allassignment.effective_start_date
AND allassignment.effective_end_date
AND SYSDATE between allassignment.effective_start_date
AND allassignment.effective_end_date
INNER JOIN per_periods_of_service periodsservice ON periodsservice.period_of_service_id = absencerecords.period_of_service_id
AND NVL(
periodsservice.ACTUAL_TERMINATION_DATE,
TO_DATE(SYSDATE, 'rrrr/mm/dd')
) >= TRUNC(SYSDATE)
WHERE
1 = 1
AND allassignment.assignment_number = '0041949'
ORDER BY
1
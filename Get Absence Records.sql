SELECT
    DISTINCT
    substr(allassignment.assignment_number, 1, 3) employer,
    substr(allassignment.assignment_number, 4, 50) employee,
    allassignment.assignment_number,
    absencerecords.person_id,
    absencerecords.period_of_service_id,
    absencerecords.start_date,
    absencerecords.start_time,
    absencerecords.per_absence_entry_id,
    absencerecords.legal_entity_id,
    absencerecords.absence_type_id,
    absencetypes.name,
    nvl(
    absencerecords.end_date,
    to_date('4712-12-31', 'rrrr/mm/dd')
    ) end_date,
    nvl(absencerecords.end_time, '23:59') end_time,
    absencerecords.duration,
    absencerecords.single_day_flag,
    absencerecords.start_date_duration,
    absencerecords.end_date_duration,
    absencetypes.attribute1 absencetypes_attr1,
    absencetypes.attribute2 absencetypes_attr2,
    absencetypes.attribute3 absencetypes_attr3,
    absencerecords.absence_entry_basic_flag,
    absencerecords.absence_status_cd,
    absencerecords.approval_status_cd,
    absencerecords.approval_datetime,
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
    absencetype.agreement_flag,
    absencerecords.abs_record_source
FROM
per_all_assignments_m allassignment
INNER JOIN anc_per_abs_entries absencerecords ON absencerecords.assignment_id = allassignment.assignment_id
INNER JOIN anc_absence_types_f absencetype ON absencetype.absence_type_id = absencerecords.absence_type_id
and sysdate between absencetype.effective_start_date
and absencetype.effective_end_date
INNER JOIN anc_absence_types_vl absencetypes ON absencetypes.absence_type_id = absencerecords.absence_type_id
and absencetypes.status = upper('a')
and trunc(sysdate) between absencetypes.effective_start_date
and absencetypes.effective_end_date
WHERE
1 = 1
and allassignment.assignment_type = upper('e')
and allassignment.assignment_status_type = upper('active')
and allassignment.effective_latest_change = upper('y')
and trunc(sysdate) between allassignment.effective_start_date
and allassignment.effective_end_date
and sysdate between allassignment.effective_start_date
and allassignment.effective_end_date
and(
absencerecords.start_date BETWEEN nvl(NULL, absencerecords.start_date)
AND trunc(sysdate)
or nvl(
absencerecords.end_date,
to_date('4712-12-31', 'rrrr/mm/dd')
) BETWEEN nvl(NULL, absencerecords.end_date)
AND trunc(sysdate)
or absencerecords.end_date >= trunc(sysdate)
)
ORDER BY
1
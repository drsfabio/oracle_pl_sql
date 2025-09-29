SELECT DISTINCT
allpeople.person_number,
allassignments.person_id,
allassignments.assignment_id,
absenceentries.per_absence_entry_id,
absencetypes.absence_type_id,
absencetypes.name absence_type,
to_char(
    absenceentries.start_date,'DD/MM/RRRR')
start_date,
to_char(
    NVL(
        absenceentries.end_date,'4712-12-31')
    ,'DD/MM/RRRR')
end_date,
absenceentries.duration,
allassignments.assignment_number,
allassignments.assignment_type,
allassignments.employee_category,
allassignments.assignment_status_type,
SUBSTR(
    allassignments.assignment_number,1,3)
Employer,
SUBSTR(
    allassignments.assignment_number,4,50)
Employee
FROM
anc_per_abs_entries absenceentries
INNER JOIN per_periods_of_service periodsofservice
ON(
    periodsofservice.period_of_service_id = absenceentries.period_of_service_id
    )
INNER JOIN per_all_people_f allpeople
ON(
    allpeople.person_id = periodsofservice.person_id
    )
        AND(
    trunc(
        sysdate)
    BETWEEN allpeople.effective_start_date
            AND allpeople.effective_end_date
    )
INNER JOIN anc_absence_types_vl absencetypes
ON(
    absencetypes.absence_type_id = absenceentries.absence_type_id
    )
        AND(
    trunc(
        sysdate)
    BETWEEN absencetypes.effective_start_date
            AND absencetypes.effective_end_date
    )
INNER JOIN per_all_assignments_m allassignments
ON(
    allassignments.person_id = periodsofservice.person_id
    )
        AND(
    allassignments.period_of_service_id = periodsofservice.period_of_service_id
    )
        AND(
    allassignments.assignment_type = 'E'
    )
        AND(
    absenceentries.start_date BETWEEN allassignments.effective_start_date
            AND allassignments.effective_end_date
    )
ORDER BY 1,
allpeople.person_number,
absenceentries.start_date;;
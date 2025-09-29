SELECT COUNT(1) RECORDS
FROM anc_per_abs_entries AbsenceEntries
INNER JOIN per_periods_of_service PeriodsOfService
ON PeriodsOfService.PERIOD_OF_SERVICE_ID = AbsenceEntries.PERIOD_OF_SERVICE_ID
INNER JOIN per_all_people_f AllPeople
ON AllPeople.PERSON_ID = PeriodsOfService.PERSON_ID
AND SYSDATE BETWEEN AllPeople.EFFECTIVE_START_DATE AND AllPeople.EFFECTIVE_END_DATE
INNER JOIN anc_absence_types_vl AbsenceTypes
ON AbsenceTypes.ABSENCE_TYPE_ID = AbsenceEntries.ABSENCE_TYPE_ID
AND SYSDATE BETWEEN AbsenceTypes.EFFECTIVE_START_DATE AND AbsenceTypes.EFFECTIVE_END_DATE
ORDER BY AllPeople.PERSON_NUMBER,AbsenceEntries.START_DATE

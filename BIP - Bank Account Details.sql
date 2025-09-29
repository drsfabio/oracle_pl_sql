WITH manager_details AS
(
	SELECT pasf.assignment_id
	, ppnf.full_name manager_name
	, ppf.person_number manager_pnum
	FROM per_person_names_f ppnf
	, per_assignment_supervisors_f pasf
	, per_people_f ppf
	WHERE ppnf.name_type = UPPER('GLOBAL')
	AND ppnf.person_id = pasf.manager_id
	AND pasf.manager_id = ppf.person_id(+)
	AND pasf.manager_type = UPPER('LINE_MANAGER')
	AND TRUNC(SYSDATE) BETWEEN TRUNC(ppnf.effective_start_date) AND TRUNC(ppnf.effective_end_date)
	AND TRUNC(SYSDATE) BETWEEN TRUNC(pasf.effective_start_date) AND TRUNC(pasf.effective_end_date)
	AND TRUNC(SYSDATE) BETWEEN TRUNC(ppf.effective_start_date(+)) AND TRUNC(ppf.effective_end_date(+))
)
, comp_manager_details AS
(
	SELECT pasf.assignment_id
	, ppnf.full_name manager_name
	FROM per_person_names_f ppnf
	, per_assignment_supervisors_f pasf
	WHERE ppnf.name_type = UPPER('GLOBAL')
	AND ppnf.person_id = pasf.manager_id
	AND pasf.manager_type = UPPER('ECL_COMPENSATION_MANAGER')
	AND TRUNC(SYSDATE) BETWEEN TRUNC(ppnf.effective_start_date) AND TRUNC(ppnf.effective_end_date)
	AND TRUNC(SYSDATE) BETWEEN TRUNC(pasf.effective_start_date) AND TRUNC(pasf.effective_end_date)
)
, national_identifier AS
(
	SELECT person_id
	, national_identifier_number
	, national_identifier_id
	FROM per_national_identifiers
	WHERE national_identifier_type = UPPER('NID')
)
, tan_number AS
(
	SELECT person_id
	, national_identifier_number
	FROM per_national_identifiers
	WHERE national_identifier_type = UPPER('ECL_TAN')
)
, per_addr AS
(
	SELECT addr.person_id
	, addr.address_type
	, addr.address_line_1
    , addr.address_line_2
	, addr.address_line_3
	, addr.town_or_city
	, addr.address_id
	, addr.country
	, addr.REGION_1
    FROM per_person_addresses_v addr
    WHERE NVL(:p_effective_date, SYSDATE) BETWEEN addr.effective_start_date AND addr.effective_end_date
    AND addr.address_type = 'HOME'
)

, organization_code AS
(
	SELECT hauf.organization_id
	, hauf.attribute1 
    FROM hr_all_organization_units_f hauf
	WHERE NVL(:p_effective_date, SYSDATE) BETWEEN hauf.effective_start_date AND hauf.effective_end_date

) 
, address_mapping AS
(
	select fnd.LOOKUP_CODE, FND.MEANING
    from FND_LOOKUP_VALUES_VL fnd
    where lookup_type = 'ADDRESS_TYPE'
    AND fnd.enabled_flag = 'Y'
)
, home_phone AS
(
	SELECT ppv.person_id
	, ppv.phone_id
	, ppv.PHONE_TYPE
	, ppv.PHONE_NUMBER
	, ppv.COUNTRY_CODE_NUMBER
	, ppv.DATE_FROM
	, ppv.DATE_TO
	FROM PER_PHONES_V ppv
	WHERE ppv.PHONE_TYPE = 'H1'
	AND SYSDATE >= ppv.date_from
	AND ppv.phone_id IN (SELECT MAX(PHONE_ID)
							FROM PER_PHONES_V
							WHERE 1=1 
							AND ppv.PHONE_TYPE = 'H1'
							AND person_id = ppv.person_id
						 )
	
)
, mobile_phone AS
(
	SELECT ppv.person_id
	, ppv.phone_id
	, ppv.PHONE_TYPE
	, ppv.PHONE_NUMBER
	, ppv.COUNTRY_CODE_NUMBER
	, ppv.DATE_FROM
	, ppv.DATE_TO
	FROM PER_PHONES_V ppv
	WHERE ppv.PHONE_TYPE = 'HM'
	AND SYSDATE >= ppv.date_from
	AND ppv.phone_id IN (SELECT MAX(PHONE_ID)
							FROM PER_PHONES_V
							WHERE 1=1 
							AND ppv.PHONE_TYPE = 'HM'
							AND person_id = ppv.person_id
						 )
	

)
, org_tree AS(
   SELECT
        *
    FROM
        (
            SELECT
                ptnr.organization_id,
                dept_anc.name,
                ptnr.distance
            FROM
                per_org_tree_node_rf_v ptnr,
                fnd_tree_version ftv,
                hr_all_organization_units_vl dept,
                hr_all_organization_units_vl dept_anc
            WHERE
                1 = 1
                AND ptnr.tree_structure_code = 'PER_ORG_TREE_STRUCTURE'
                AND ptnr.tree_code =  'Eclosia Group'
                AND ptnr.tree_version_id = ftv.tree_version_id
                AND ftv.status = 'ACTIVE'
                AND ptnr.organization_id = dept.organization_id
                AND ptnr.ancestor_organization_id = dept_anc.organization_id
        ) PIVOT (
            MAX ( name )
            FOR distance
            IN ( 0 lm5, 1 lm4, 2 lm3, 3 lm2, 4 lm1 , 5 lml0)
        )
)
, seniority_date AS 
(
    SELECT 
      psdf.person_id
     ,MIN(psdf.seniority_date) seniority_date
    FROM PER_SENIORITY_DATES_F psdf
    WHERE psdf.SENIORITY_DATE_CODE(+) = 'ECL_ENTERPRISE_SD_New_Rule'
    GROUP BY psdf.person_id
)
, disability_info AS
(
  SELECT pdf.person_id,
         LISTAGG (
            HR_GENERAL.DECODE_LOOKUP ('DISABILITY_CATEGORY', pdf.CATEGORY),
            '; ')
         WITHIN GROUP (ORDER BY
                          HR_GENERAL.DECODE_LOOKUP ('DISABILITY_CATEGORY',
                                                    pdf.CATEGORY))
            disability_category
    FROM per_disabilities_f pdf
   WHERE     1 = 1
         AND SYSDATE BETWEEN pdf.effective_start_date(+)
                         AND pdf.effective_end_date(+)
GROUP BY pdf.person_id
ORDER BY pdf.person_id
)
, shoe_size AS
(
SELECT ppei.person_id, LISTAGG (ppei.pei_information1,'; ') WITHIN GROUP (ORDER BY ppei.pei_information1)uniform_size
   FROM per_people_extra_info ppei
   WHERE     1 = 1
         AND ppei.pei_information_category = 'Eclosia_Shoe_Size'
         AND SYSDATE BETWEEN ppei.effective_start_date(+) AND ppei.effective_end_date(+)
GROUP BY ppei.person_id
ORDER BY ppei.person_id
)
, shirt_size AS
(
SELECT ppei.person_id, LISTAGG (ppei.pei_information1,'; ') WITHIN GROUP (ORDER BY ppei.pei_information1)uniform_size
   FROM per_people_extra_info ppei
   WHERE     1 = 1
         AND ppei.pei_information_category = 'Shirt size'
         AND SYSDATE BETWEEN ppei.effective_start_date(+) AND ppei.effective_end_date(+)
GROUP BY ppei.person_id
ORDER BY ppei.person_id
)
, trousers_size AS
(
SELECT ppei.person_id, LISTAGG (ppei.pei_information1,'; ') WITHIN GROUP (ORDER BY ppei.pei_information1)uniform_size
   FROM per_people_extra_info ppei
   WHERE     1 = 1
         AND ppei.pei_information_category = 'Trousers size'
         AND SYSDATE BETWEEN ppei.effective_start_date(+) AND ppei.effective_end_date(+)
GROUP BY ppei.person_id
ORDER BY ppei.person_id
)
, areas_of_responsibility AS
(
    SELECT asg.assignment_id, LISTAGG (aor.responsibility_name,'; ') WITHIN GROUP (ORDER BY aor.responsibility_name)responsibility_name
       FROM per_asg_responsibilities aor
        JOIN per_all_people_f pall ON aor.person_id=pall.person_id
        JOIN per_all_assignments_m asg ON aor.person_id=asg.person_id
        AND asg.assignment_type IN ('E','C','N','P')
        AND TRUNC(sysdate) BETWEEN asg.effective_start_date AND asg.effective_end_date
		AND sysdate between pall.effective_start_date and pall.effective_end_date
		AND asg.assignment_status_type <> UPPER('INACTIVE')
    GROUP BY asg.assignment_id
    ORDER BY asg.assignment_id
)
, bank_details AS(
SELECT LISTAGG(iebc.bank_number,',') WITHIN GROUP (ORDER BY iebc.bank_number) bank_number,
        LISTAGG(iebc.bank_account_type,',') WITHIN GROUP (ORDER BY iebc.bank_account_type) bank_account_type,
        LISTAGG(iebc.bank_account_name,',') WITHIN GROUP (ORDER BY iebc.bank_account_name) bank_account_name,
        LISTAGG(iebc.bank_name,',') WITHIN GROUP (ORDER BY iebc.bank_name) bank_name,
		LISTAGG(iebcv.bank_account_num,',') WITHIN GROUP (ORDER BY iebcv.bank_account_num) bank_account_num,
		papf.person_id
 FROM iby_ext_bank_accounts_v iebc,
		iby_ext_bank_accounts iebcv,
		hz_parties hz_per,
		per_all_people_f papf,
		 iby_pmt_instr_uses_all   uses
 WHERE 1=1
		AND iebc.ext_bank_account_id = iebcv.ext_bank_account_id
		AND hz_per.party_id = iebc.primary_acct_owner_party_id
		AND hz_per.orig_system_reference = papf.person_id
		AND TRUNC(SYSDATE) BETWEEN papf.effective_start_date AND NVL(papf.effective_end_date, SYSDATE)
		AND uses.instrument_id = iebc.ext_bank_account_id
		AND SYSDATE BETWEEN NVL(uses.start_date,SYSDATE) AND NVL(uses.end_date,SYSDATE)
GROUP BY papf.person_id

),
nationality AS 
(
	SELECT meaning, lookup_code 
	FROM FND_LOOKUP_VALUES
	WHERE lookup_type = 'NATIONALITY'
	AND language = 'US'
)

SELECT  ppf.person_id 
, ppf.person_number   person_number
, paaf.assignment_number   
, ppnf.first_name
, ppnf.last_name
, ppnf.known_as
, pav.action_name
, HR_GENERAL.DECODE_LOOKUP('PER_ROLE_ASSIGNMENT_STATUS', paaf.assignment_status_type) assignment_status_type
, paaf.employment_category
, HR_GENERAL.DECODE_LOOKUP('EMP_CAT', paaf.employment_category) assignment_category
, HR_GENERAL.DECODE_LOOKUP('EMPLOYEE_CATG', paaf.employee_category) worker_category
, HR_GENERAL.DECODE_LOOKUP('PART_FULL_TIME', hap.full_part_time) full_part_time
, HR_GENERAL.DECODE_LOOKUP('REGULAR_TEMPORARY', hap.permanent_temporary_flag) permanent_temporary
, ple.name legal_entity
, CASE
	WHEN pplf.sex = 'F' THEN 'Female'
	WHEN pplf.sex = 'M' THEN 'Male'
	WHEN pplf.sex IS NULL THEN ''
END AS gender
, pd.name sub_department
, ppos.date_start date_joined_company
, NVL(sd.seniority_date,ppos.date_start) date_joined_group
, pjft.name job_name
, pgf.grade_code
, hap.attribute1 hay_grade
, hap.attribute2 comp_grade
, pgft.name grade_name
, hap.name position_name
--, per_addr.address_type
, per_addr.address_line_1
, per_addr.address_line_2
, per_addr.address_line_3
, per_addr.town_or_city
, per_addr.REGION_1 AS "DISTRICT"
, per_addr.country AS "COUNTRY_CODE"
, am.meaning AS "ADDRESS_TYPE"
, ftv.territory_short_name AS "COUNTRY"
, home_phone.COUNTRY_CODE_NUMBER AS "HOME_AREA_CODE"
, home_phone.PHONE_NUMBER AS "HOME_PHONE_NUMBER"
, mobile_phone.COUNTRY_CODE_NUMBER AS "MOBILE_AREA_CODE"
, mobile_phone.PHONE_NUMBER AS "MOBILE_PHONE_NUMBER"
, mobile_phone.DATE_FROM
, mobile_phone.DATE_TO
, national_identifier.national_identifier_number 
, tan_number.national_identifier_number tan_number
, loc_det.location_name
, md.manager_name
, md.manager_pnum
, cmd.manager_name comp_manager_name
, email.email_address
, ppfn.date_of_birth
, ps.user_status pay_status
, CASE WHEN paaf.primary_flag = 'Y' THEN 'Yes' 
   WHEN paaf.primary_flag = 'N' THEN 'No'
   ELSE '' 
   END primary_flag
, oc.attribute1 financial_dimension
, ot.lm4 department
, pjffv.job_family_name 
, houft.name business_unit
, di.disability_category 
, shoe_size.uniform_size shoe_size
, shirt_size.uniform_size shirt_size
, trousers_size.uniform_size trousers_size
, aor.responsibility_name
, bd.bank_number
, bd.bank_account_type
, bd.bank_account_name
, bd.bank_name
, bd.bank_account_num
, lookup_ms.meaning marital_status 
, nation.meaning citizenship 
, paaf.ASS_ATTRIBUTE3 employment_status

FROM per_person_secured_list_v ppf
, per_people_f ppfn
, per_assignment_secured_list_v paaf
, per_actions_vl pav  
, per_legal_employers ple
, per_people_legislative_f pplf
, per_departments pd
, per_periods_of_service ppos
, per_jobs_f_tl pjft
, per_grades_f pgf
, per_grades_f_tl pgft
, per_person_names_f ppnf
, hr_all_positions hap
, per_addr
, national_identifier
, tan_number
, per_assignment_status_types_vl ps
, hr_locations_all_f loc
, hr_locations_all_tl loc_det
, manager_details md 
, comp_manager_details cmd
, per_email_addresses_v email
, organization_code oc
, org_tree ot
, seniority_date sd
, per_jobs_f pjf
, per_job_family_f_vl pjffv
, hr_organization_units_f_tl houft
, disability_info di
, shoe_size
, shirt_size
, trousers_size
, areas_of_responsibility aor
, fnd_territories_vl ftv
, address_mapping am
, home_phone
, mobile_phone
, bank_details bd
, fnd_common_lookups lookup_ms
, nationality nation

WHERE 1 = 1
--join assignment
AND ppf.person_id = paaf.person_id 
AND paaf.assignment_status_type <> UPPER('INACTIVE')
AND paaf.effective_latest_change = 'Y'
AND paaf.assignment_type IN ('E','C')
AND NVL(:p_effective_date, SYSDATE) BETWEEN paaf.effective_start_date AND paaf.effective_end_date
AND NVL(:p_effective_date, SYSDATE) BETWEEN ppf.effective_start_date AND ppf.effective_end_date

AND ppf.person_id = ppfn.person_id
AND NVL(:p_effective_date, SYSDATE) BETWEEN ppfn.effective_start_date AND ppfn.effective_end_date

/*AND TRUNC(paaf.effective_start_date)  >= NVL(:p_Date_From, TRUNC(paaf.effective_start_date))
AND TRUNC(paaf.effective_end_date) >= NVL (:p_Date_To, TRUNC(paaf.effective_end_date)) 
AND TRUNC(ppf.effective_start_date)  >= NVL(:p_Date_From, TRUNC(ppf.effective_start_date))
AND TRUNC(ppf.effective_end_date) >= NVL (:p_Date_To, TRUNC(ppf.effective_end_date)) */

AND pplf.marital_status = lookup_ms.lookup_code(+)
AND lookup_ms.LOOKUP_TYPE(+) = 'ORA_PER_MAR_STATUS'

--join action_code
AND paaf.action_code = pav.action_code
--AND paaf.action_code IN ('HIRE','REHIRE','ADD_CWK' )
--AND pav.action_name = NVL(:p_Action, ac.action_name)

--join legal employers
AND ple.organization_id (+) = paaf.legal_entity_id
AND ppf.person_id = pplf.person_id (+)
AND SYSDATE BETWEEN ple.effective_start_date AND ple.effective_end_date -- get only active legal entity
AND NVL(:p_effective_date, SYSDATE) BETWEEN pplf.effective_start_date AND pplf.effective_end_date
AND(ple.name IN (:p_legal_entity) OR COALESCE (:p_legal_entity, NULL) IS NULL)

--AND TRUNC(pplf.effective_start_date)  >= NVL(:p_Date_From, TRUNC(pplf.effective_start_date))
--AND TRUNC(pplf.effective_end_date) >= NVL (:p_Date_To, TRUNC(pplf.effective_end_date)) 

--AND ple.name = 'Agrifarm Company Ltd'

--join department
AND pd.business_group_id = paaf.business_group_id
AND pd.organization_id = paaf.organization_id
AND NVL(:p_effective_date, SYSDATE) BETWEEN pd.effective_start_date AND pd.effective_end_date
AND(pd.name IN (:p_sub_department) OR COALESCE (:p_sub_department, NULL) IS NULL)


AND paaf.organization_id = ot.organization_id(+) 
AND(ot.lm4 IN (:p_department) OR COALESCE (:p_department, NULL) IS NULL)


--join period of service
AND ppf.person_id = ppos.person_id
AND ppos.legislation_code = pplf.legislation_code
AND ppos.legal_entity_id = paaf.legal_entity_id
AND ppos.business_group_id = paaf.business_group_id
--DOC START SDA ECLOSIAHCM : ACTIVE LIST
-- AND ppos.actual_termination_date IS NULL
--DOC START SDA ECLOSIAHCM : ACTIVE LIST
AND paaf.period_of_service_id = ppos.period_of_service_id
--AND TRUNC(ppos.date_start ) between NVL(:p_Date_From,TRUNC(ppos.date_start )) and NVL(:p_Date_To,TRUNC(ppos.date_start )) 

--join business_unit
AND paaf.business_unit_id =houft.ORGANIZATION_ID(+)
AND houft.language(+) = userenv('LANG')
AND SYSDATE BETWEEN houft.effective_start_date(+) AND houft.effective_end_date(+)  
AND(houft.name IN (:p_business_unit) OR COALESCE (:p_business_unit, NULL) IS NULL)

--join jobs
AND paaf.job_id =pjft.job_id(+)
AND pjft.language(+) = userenv('LANG')
AND SYSDATE BETWEEN pjft.effective_start_date(+) AND pjft.effective_end_date(+)  
AND(pjft.name IN (:p_job) OR COALESCE (:p_job, NULL) IS NULL)


--join job_family
AND paaf.job_id = pjf.job_id(+) 
AND SYSDATE BETWEEN pjf.effective_start_date(+) AND pjf.effective_end_date(+)  
AND pjf.job_family_id =pjffv.job_family_id(+)
AND SYSDATE BETWEEN pjffv.effective_start_date(+) AND pjffv.effective_end_date(+)  

--join grade
AND paaf.grade_id  = pgf.grade_id(+)
AND pgft.grade_id(+) = pgf.grade_id
AND pgft.language(+) = userenv('LANG')
AND(pgft.name IN (:p_grade) OR COALESCE (:p_grade, NULL) IS NULL)
AND (pgft.name IS NULL OR SYSDATE BETWEEN pgft.effective_start_date AND pgft.effective_end_date)

--join person name
AND ppf.person_id = ppnf.person_id
AND ppnf.name_type = 'GLOBAL'
AND NVL(:p_effective_date, SYSDATE) BETWEEN ppnf.effective_start_date AND ppnf.effective_end_date
--AND TRUNC(ppnf.effective_start_date)  >= NVL(:p_Date_From, TRUNC(ppnf.effective_start_date))
--AND TRUNC(ppnf.effective_end_date) >= NVL (:p_Date_To, TRUNC(ppnf.effective_end_date))

--join position
AND paaf.position_id = hap.position_id (+)
AND SYSDATE BETWEEN hap.effective_start_date AND hap.effective_end_date 

--join address
AND paaf.person_id = per_addr.person_id (+)
AND ppf.mailing_address_id = per_addr.address_id(+)

--join NID
AND ppf.person_id = national_identifier.person_id (+)
AND ppf.PRIMARY_NID_ID = national_identifier.NATIONAL_IDENTIFIER_ID(+)

--join TAN
AND ppf.person_id = tan_number.person_id (+)

--join payroll status
AND paaf.assignment_status_type_id =  ps.assignment_status_type_id (+)

--join location
AND paaf.location_id = loc.location_id (+)
AND SYSDATE BETWEEN loc.effective_start_date AND loc.effective_end_date -- fetch only active departments
AND loc_det.location_details_id = loc.location_details_id
AND (loc_det.location_name IN (:p_location) OR COALESCE (:p_location, NULL) IS NULL)
AND loc_det.language = userenv('LANG')

--join manager
AND paaf.assignment_id = md.assignment_id(+)  

--join comp manager
AND paaf.assignment_id = cmd.assignment_id(+) 

AND paaf.person_id = email.person_id(+)
AND email.email_type(+) = 'W1'

--join organization_code
AND oc.organization_id = pd.organization_id

AND paaf.person_id = sd.person_id(+)

AND paaf.person_id = di.person_id(+)

AND paaf.person_id = shoe_size.person_id(+)

AND paaf.person_id = shirt_size.person_id(+)

AND paaf.person_id = trousers_size.person_id(+)

AND paaf.assignment_id = aor.assignment_id(+)  

--join phone number
AND paaf.person_id = home_phone.person_id(+)
AND paaf.person_id = mobile_phone.person_id(+)
--AND ppf.PRIMARY_PHONE_ID = ppv.phone_id(+) --primary

AND pplf.legislation_code = nation.lookup_code(+)

AND ftv.territory_code(+) = per_addr.country
AND am.LOOKUP_CODE(+) = per_addr.address_type
AND ppos.date_start <= NVL(:p_effective_date, ppos.date_start)
AND TRUNC(SYSDATE) >= nvl(TRUNC(home_phone.DATE_FROM(+)), TRUNC(SYSDATE)) AND TRUNC(SYSDATE) <=NVL(TRUNC(home_phone.DATE_TO(+)), TRUNC(SYSDATE))
AND TRUNC(SYSDATE) >= nvl(TRUNC(mobile_phone.DATE_FROM(+)), TRUNC(SYSDATE)) AND TRUNC(SYSDATE) <= NVL(TRUNC(mobile_phone.DATE_TO(+)), TRUNC(SYSDATE))
--AND ppf.person_number = '63046'
AND ppf.person_id = bd.person_id(+)

ORDER BY ppf.person_number ASC
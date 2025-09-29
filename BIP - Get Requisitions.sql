WITH CONTEXT_INDEX AS (

SELECT NVL(MAX(TO_NUMBER(SUBSTR(REQ.REQUISITION_NUMBER, 3, 9))), 0) AS INDEX_OUT

FROM IRC_REQUISITIONS_B REQ
	
WHERE 1 = 1
AND REQ.REQUISITION_NUMBER LIKE ('RV%')
)


-- SELECT ('METADATA|JobRequisition|RequisitionNumber|RecruitingType|RequisitionTitle|HiringManagerId|RecruiterPersonNumber|LegalEmployerName|OrganizationId|PositionCode|JobCode|BusinessUnitShortCode|CurrentStateCode|CurrentPhaseCode|ApplyWhenNotPostedFlag|UnlimitedOpeningsFlag|BaseLanguageCode|CandidateSelectionProcessCode|ExternalApplyFlowCode|DepartmentName|NumberOfOpenings|MaximumSalary') AS LINE
-- FROM DUAL
-- UNION ALL
-- SELECT ('MERGE|JobRequisition|' || RequisitionNumber || '|' || RecruitingType || '|' || RequisitionTitle || '|' || HiringManagerId || '|' || RecruiterPersonNumber || '|' || LegalEmployerName || '|' || OrganizationId || '|' || PositionCode || '|' || JobCode || '|' || BusinessUnitShortCode || '|' || CurrentStateCode || '|' || CurrentPhaseCode || '|' || ApplyWhenNotPostedFlag || '|' || UnlimitedOpeningsFlag || '|' || BaseLanguageCode || '|' || CandidateSelectionProcessCode || '|' || ExternalApplyFlowCode || '|' || DepartmentName || '|' || NumberOfOpenings || '|' || MaximumSalary) AS LINE

SELECT ('METADATA|JobRequisition|RequisitionNumber|RecruitingType|RequisitionTitle|HiringManagerId|RecruiterPersonNumber|LegalEmployerName|OrganizationId|PositionCode|JobCode|BusinessUnitShortCode|CurrentStateCode|CurrentPhaseCode|ApplyWhenNotPostedFlag|UnlimitedOpeningsFlag|BaseLanguageCode|CandidateSelectionProcessCode|ExternalApplyFlowCode|DepartmentName|NumberOfOpenings|MaximumSalary|Code') AS LINE
FROM DUAL
UNION ALL
SELECT ('MERGE|JobRequisition|' || RequisitionNumber || '|' || RecruitingType || '|' || RequisitionTitle || '|' || HiringManagerId || '|' || RecruiterPersonNumber || '|' || LegalEmployerName || '|' || OrganizationId || '|' || PositionCode || '|' || JobCode || '|' || BusinessUnitShortCode || '|' || CurrentStateCode || '|' || CurrentPhaseCode || '|' || ApplyWhenNotPostedFlag || '|' || UnlimitedOpeningsFlag || '|' || BaseLanguageCode || '|' || CandidateSelectionProcessCode || '|' || ExternalApplyFlowCode || '|' || DepartmentName || '|' || NumberOfOpenings || '|' || MaximumSalary || '|' || CandidateSelectionProcessCode) AS LINE

FROM
(

	SELECT 'MERGE' AS METADATA
	,'JobRequisition' AS JobRequisition
	,('RV' || LPAD(TO_CHAR(DECODE(CID.INDEX_OUT, NULL, 0, CID.INDEX_OUT) + ROWNUM), 9, '0')) AS RequisitionNumber
	--,''  AS RequisitionNumber
	,'ORA_PROFESSIONAL' AS RecruitingType
	,JOT.NAME  AS RequisitionTitle
	,SUBSTR(POF.ATTRIBUTE8, 0, INSTR(POF.ATTRIBUTE8, '-')-1) AS HiringManagerId


    -- 13/10/2024 - Benites - Ao invés de obter o recrutador da tela, buscar o recrutador na lookup
    -- ,:P_Recruiter AS RecruiterPersonNumber

    ,(
        select fnd1.description 
        from 
            HR_ORGANIZATION_INFORMATION_F RIF1,
            HR_ORGANIZATION_V EST1,
            FND_LOOKUP_VALUES FND1
        where RIF1.ORG_INFORMATION_CONTEXT IN ('LACLS_BR_HCM_LRU_CODE', 'GM_EFF_ORG_FILIAL_DL')
          and RIF1.ORGANIZATION_ID = EST1.ORGANIZATION_ID
          and trunc(sysdate) BETWEEN RIF1.EFFECTIVE_START_DATE AND RIF1.EFFECTIVE_END_DATE 
          and substr(est1.organization_code, -14, 14)= pof.attribute19
          and est1.CLASSIFICATION_CODE = 'HCM_REPORTING_ESTABLISHMENT'
          and fnd1.meaning = RIF1.ORG_INFORMATION1
          and lookup_type = 'GM_RECRUTADOR_FILIAL'
          and language = 'PTB'
          and rownum=1
    ) AS RecruiterPersonNumber
    -- 13/10/2024 - Fim





	-- ,GEO.GEOGRAPHY_ID AS PrimaryLocationId
	,LEP.NAME AS LegalEmployerName
	,EMP.ORGANIZATION_ID AS OrganizationId
	--,EMP.NAME  AS OrganizationName
	--,'HCM_LEMP' AS ClassificationCode
	,POF.POSITION_CODE  AS PositionCode
	,JOB.JOB_CODE AS JobCode
	--,:P_Code AS Code
	--,EducationLevel
	,BUS.NAME  AS BusinessUnitShortCode
	,'REQUISITION_IN_PROGRESS' AS CurrentStateCode
	,'REQUISITION_JOB_FORMATTING' AS CurrentPhaseCode
	,'Y' AS ApplyWhenNotPostedFlag
	,'N' AS UnlimitedOpeningsFlag
	,'PTB' AS BaseLanguageCode
	,PRC.CODE AS CandidateSelectionProcessCode
	,'CANDIDATURA_GERAL' AS ExternalApplyFlowCode
	,DEP.NAME AS DepartmentName
	,(POF.FTE - (SELECT COUNT(1) FROM PER_ALL_ASSIGNMENTS_M ASG2 
								WHERE ASG2.POSITION_ID = POF.POSITION_ID 
								AND ASG2.ASSIGNMENT_TYPE IN ('E', 'P')
								AND ASG2.EFFECTIVE_LATEST_CHANGE = 'Y'
								AND ASG2.ASSIGNMENT_STATUS_TYPE = 'ACTIVE'
								AND SYSDATE BETWEEN ASG2.EFFECTIVE_START_DATE AND ASG2.EFFECTIVE_END_DATE)) AS NumberOfOpenings -- Total Vaga - Populado
	,RTV.VALUE AS MaximumSalary -- Colocar salario
	
	
	FROM HR_ALL_POSITIONS_F POF
		
		LEFT JOIN CONTEXT_INDEX CID
			ON (1 = 1)
		
		LEFT JOIN HR_ALL_POSITIONS_F_TL PTL
				ON (PTL.POSITION_ID = POF.POSITION_ID
				AND PTL.LANGUAGE = 'PTB'
				AND SYSDATE BETWEEN PTL.EFFECTIVE_START_DATE AND PTL.EFFECTIVE_END_DATE)
	
		-- Job Information --
		INNER JOIN PER_JOBS_F JOB  
			ON (JOB.JOB_ID = POF.JOB_ID
			AND SYSDATE BETWEEN JOB.EFFECTIVE_START_DATE AND JOB.EFFECTIVE_END_DATE)

		LEFT JOIN PER_JOBS_F_TL JOT
			ON (JOT.JOB_ID = JOB.JOB_ID
			AND JOT.LANGUAGE = 'PTB'
			AND SYSDATE BETWEEN JOT.EFFECTIVE_START_DATE AND JOT.EFFECTIVE_END_DATE)
		
		-- Business Unit
		LEFT JOIN HR_ORGANIZATION_V BUS
			ON (BUS.ORGANIZATION_ID = POF.BUSINESS_UNIT_ID
			AND BUS.CLASSIFICATION_CODE = 'FUN_BUSINESS_UNIT'
			AND SYSDATE BETWEEN BUS.EFFECTIVE_START_DATE AND BUS.EFFECTIVE_END_DATE)
		
		LEFT JOIN HR_OPERATING_UNITS BUE
			ON (BUE.ORGANIZATION_ID = BUS.ORGANIZATION_ID
			AND SYSDATE BETWEEN NVL(BUE.DATE_FROM, TO_DATE('1951-01-01','YYYY-MM-DD')) AND NVL(BUE.DATE_TO, TO_DATE('4712-12-31','YYYY-MM-DD')))
			
		-- Legal Entity
		LEFT JOIN HR_ORGANIZATION_V LEP
			ON (LEP.LEGAL_ENTITY_ID = BUE.DEFAULT_LEGAL_CONTEXT_ID
			AND LEP.STATUS = 'A'
			AND LEP.CLASSIFICATION_CODE = 'HCM_LEMP'
			AND SYSDATE BETWEEN LEP.EFFECTIVE_START_DATE AND LEP.EFFECTIVE_END_DATE)
	
		-- Department
		LEFT JOIN HR_ORGANIZATION_V DEP
			ON (DEP.ORGANIZATION_ID = POF.ORGANIZATION_ID
			AND DEP.CLASSIFICATION_CODE = 'DEPARTMENT'
			AND SYSDATE BETWEEN DEP.EFFECTIVE_START_DATE AND DEP.EFFECTIVE_END_DATE)
	
		-- Organization
		LEFT JOIN XLE_REGISTRATIONS_V REV
			ON (REV.REGISTRATION_NUMBER = POF.ATTRIBUTE19
			AND REV.LEGAL_ENTITY_ID IS NULL)
			
		LEFT JOIN HZ_GEOGRAPHIES GEO
			ON (GEO.GEOGRAPHY_NAME = REV.REGION_2
			AND GEO.COUNTRY_CODE =  REV.COUNTRY
			AND SYSDATE BETWEEN NVL(GEO.START_DATE, TO_DATE('1951-01-01','YYYY-MM-DD')) AND NVL(GEO.END_DATE, TO_DATE('4712-12-31','YYYY-MM-DD')))
	
		LEFT JOIN XLE_ETB_PROFILES ETP
			ON (REV.ESTABLISHMENT_ID = ETP.ESTABLISHMENT_ID)
	
		LEFT JOIN HR_ORGANIZATION_V EMP
			ON (EMP.LEGAL_ENTITY_ID = ETP.LEGAL_ENTITY_ID
			AND EMP.CLASSIFICATION_CODE = 'HCM_LEMP'
			AND SYSDATE BETWEEN EMP.EFFECTIVE_START_DATE AND EMP.EFFECTIVE_END_DATE)
	
		-- Rate
		LEFT JOIN PER_GRADE_STEPS_F PGD
			ON (PGD.GRADE_STEP_ID = POF.ENTRY_STEP_ID
			AND SYSDATE BETWEEN PGD.EFFECTIVE_START_DATE AND PGD.EFFECTIVE_END_DATE)
		
		LEFT JOIN PER_RATES_F RTF
			ON (RTF.GRADE_LADDER_ID = POF.GRADE_LADDER_ID
			AND SYSDATE BETWEEN RTF.EFFECTIVE_START_DATE AND RTF.EFFECTIVE_END_DATE)
	
		LEFT JOIN PER_RATE_VALUES_F RTV
			ON (RTV.RATE_OBJECT_ID = PGD.GRADE_STEP_ID
			AND RTV.RATE_ID = RTF.RATE_ID
			AND SYSDATE BETWEEN RTV.EFFECTIVE_START_DATE AND RTV.EFFECTIVE_END_DATE)
	
		-- Requisition Template
		LEFT JOIN IRC_REQUISITIONS_B IRB
			ON (IRB.REQUISITION_ID = POF.REQUISITION_TEMPLATE_ID)
			
		LEFT JOIN IRC_PROCESSES_B PRC
			ON (PRC.PROCESS_ID = IRB.SUBS_PROCESS_TEMPLATE_ID )
	
	
	WHERE 1 = 1
	AND SYSDATE BETWEEN POF.EFFECTIVE_START_DATE AND POF.EFFECTIVE_END_DATE
	
	-- Position Code
	AND (CASE
			WHEN DECODE(:P_PositionCode, NULL, 1, 0) = 1 THEN 1
			WHEN (POF.POSITION_CODE) IN (:P_PositionCode) THEN 1
			ELSE 0
	END) = 1
	
)
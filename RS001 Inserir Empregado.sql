-- Employee
 --
-- Vinicius L Cabral (Peloton) >  Grupo Matheus > RSData
-- Update Date: 2023-12-26
-- Inclusão e movimentação Empregado
-- Doc Reference:
--
 WITH ASSIGN_PARAM AS ( -- If you are testing use the line below

                       SELECT CASE
                                  WHEN :P_AsgNumber IS NULL THEN SYSDATE
                                  ELSE NVL(TO_DATE(TO_CHAR(:P_UpdateDate, 'YYYY-MM-DD'), 'YYYY-MM-DD'), SYSDATE)
                              END AS EXTRACTION_DATE
                       FROM DUAL )
SELECT -- Pending Worker Analysis
CASE -- This Person Was a Pending Worker in the past

    WHEN
           (SELECT COUNT(1)
            FROM PER_ALL_ASSIGNMENTS_M ASG2
            WHERE ASG2.PERSON_ID = ASG.PERSON_ID
              AND ASG2.ASSIGNMENT_TYPE = 'P') > 0 THEN '1'
    ELSE '0'
END AS novoContrato,
-- Candidato
-- NovoContrato S - TpVerEmpregado CPF
 -- Alteração Candidato
-- NovoContrato N - TpVerEmpregado CPF
 -- Admissão 1 vinculo de Empregado
-- NovoContrato F - TpVerEmpregado CPF
 -- Alteração/Atualização 1 vinculo de Empregado
-- NovoContrato N - TpVerEmpregado Matricula
 -- Admissão 2 vinculo de Empregado
-- NovoContrato S - TpVerEmpregado Matricula
 -- Alteração/Atualização 2 vinculo de Empregado
-- NovoContrato N - TpVerEmpregado Matricula
 -- End Pending Worker Analysis

'' AS codIntegracaoEmpresa,
'' AS nrCNPJEmpresa,
'' AS razaoSocialEmpresa,
'' AS denominacaoEmpresa,
'' AS statusEmpresa,
'' AS idEmpresa,
PEO.PERSON_NUMBER AS idEmpregado,
PEO.PERSON_NUMBER AS codIntegracaoEmpregado,
NAM.FULL_NAME AS nomeEmpregado,
'' AS carteiraTrabalhoDigital,
regexp_replace(CPF.NATIONAL_IDENTIFIER_NUMBER,'\W') AS nrCPF,
'' AS nrNIT,
SUBSTR(ASG.ASSIGNMENT_NUMBER, 4, 50) AS nrMatricula,
NVL(AEI.AEI_ATTRIBUTE16, SUBSTR(ASG.ASSIGNMENT_NUMBER, 4, 50)) AS matriculaRh,
--SEV.PDS_INFORMATION9 AS categoriaTrabalhador,

ASG.ASS_ATTRIBUTE2 AS categoriaTrabalhador,
TO_CHAR(PSO.DATE_OF_BIRTH, 'DD/MM/YYYY') AS dtNascimento,
PEL.SEX AS tpSexo,
PEL.PER_INFORMATION1 AS nrCTPS,
PEL.PER_INFORMATION2 AS nrSerieCTPS,
TO_CHAR(PEL.PER_INFORMATION_DATE1, 'DD/MM/YYYY') AS dtEmiCTPS,
TO_CHAR(PEL.ATTRIBUTE_DATE1, 'DD/MM/YYYY') AS dtValidadeCTPS,
PEL.PER_INFORMATION3 AS ufEmiCTPS,
SUBSTR(regexp_replace(RG.NATIONAL_IDENTIFIER_NUMBER,'\W'), 0, 15) AS nrIdentidade,
RG.PLACE_OF_ISSUE AS orgaoExpedidorRG,
TO_CHAR(RG.ISSUE_DATE, 'DD/MM/YYYY') AS dtEmiRG,

  (SELECT GEO.GEOGRAPHY_NAME
   FROM HZ_GEOGRAPHIES GEO
   WHERE GEO.GEOGRAPHY_CODE = RG.ATTRIBUTE1
     AND ASG.EFFECTIVE_END_DATE BETWEEN GEO.START_DATE AND GEO.END_DATE
     AND ROWNUM = 1) AS ufEmiRG,
SUBSTR(regexp_replace(RNE.NATIONAL_IDENTIFIER_NUMBER,'\W'), 0, 15) AS Rne,
'' AS tpVinculo,
'' AS BRPDH,
'' AS regimeRevezamento,
CASE
    WHEN ASG.ASSIGNMENT_TYPE = 'P' THEN TO_CHAR(ASG.PROJECTED_START_DATE, 'DD/MM/YYYY')
    ELSE TO_CHAR(SEV.DATE_START, 'DD/MM/YYYY')
END AS dtAdmissao,
TO_CHAR(SEV.ACTUAL_TERMINATION_DATE, 'DD/MM/YYYY') AS dtDemissao,
'' AS txObs,
--ADR.ADDRESS_ID,

CASE
    WHEN ADR.ADDRESS_LINE_1 IS NOT NULL THEN (ADR.ADDL_ADDRESS_ATTRIBUTE3 || ' ' || ADR.ADDRESS_LINE_1 || ' ' || ADR.ADDRESS_LINE_2 || ' ' || ADR.ADDRESS_LINE_3)
    ELSE NULL
END AS enderecoEmpregado,
ADR.TOWN_OR_CITY AS cidadeEmpregado,
'' AS cidadeCodIbge,
ADR.ADDRESS_LINE_4 AS bairroEmpregado,
ADR.REGION_2 AS estadoEmpregado,
ADR.POSTAL_CODE AS nrCEP,
--CASE WHEN PPH.PHONE_NUMBER IS NOT NULL THEN (PPH.COUNTRY_CODE_NUMBER || PPH.AREA_CODE || PPH.PHONE_NUMBER || PPH.VALIDITY || PPH.EXTENSION)

NULL AS nrTelefone,
        CASE
            WHEN PPH.AREA_CODE IS NOT NULL THEN LPAD(regexp_replace(PPH.AREA_CODE,'\W'), 3, '0')
            WHEN PPH.PHONE_NUMBER IS NOT NULL THEN SUBSTR(LPAD(regexp_replace(PPH.PHONE_NUMBER,'\W'), 12, '0'), 1, 3)
            ELSE NULL
        END AS dddCelular,
        CASE
            WHEN PPH.AREA_CODE IS NOT NULL THEN regexp_replace(PPH.PHONE_NUMBER,'\W')
            WHEN PPH.PHONE_NUMBER IS NOT NULL THEN SUBSTR(LPAD(regexp_replace(PPH.PHONE_NUMBER,'\W'), 12, '0'), 4, 9)
            ELSE NULL
        END AS nrCelular,
        -- Salary Information. Because of SQL restrictions its not possible no execute nested Querys in Left Joins Objects
-- To Solve This, a Subquery was Created to Retrieve this Data
-- In this case We Want to Retrieve Max Salary Until Parameter Date
-- (Some cases Employee May not have Salary and we want to Retrieve the Record Anyway)
 --(SELECT CMP.SALARY_AMOUNT
--FROM CMP_SALARY CMP
--WHERE CMP.ASSIGNMENT_ID = ASG.ASSIGNMENT_ID
--AND CMP.DATE_FROM = (SELECT MAX(CMP2.DATE_FROM) FROM CMP_SALARY CMP2 WHERE CMP2.ASSIGNMENT_ID = CMP.ASSIGNMENT_ID AND CMP2.DATE_FROM <= ASP.EXTRACTION_DATE)
--AND ROWNUM = 1
--) AS remuneracaoMensal,

        NULL AS remuneracaoMensal,
                -- End Salary Information

                NAM2.FULL_NAME AS nomeMae,
                --

                '' AS tpFilPrevidencia,
                PEL.MARITAL_STATUS AS tpEstadoCivil,
                '' AS tpAposentado,
                TET.NATIONAL_IDENTIFIER_NUMBER AS nrEleitor,
                --

                DVR.LICENSE_NUMBER AS nrCNH,
                TO_CHAR(DVR.DATE_TO, 'DD/MM/YYYY') AS dtValCNH,
                --

                '' AS cdRFID,
                '' AS cdBarras,
                PSO.BLOOD_TYPE AS grupoSanguineo,
                -- Disabilities information
 --(SELECT DIS.CATEGORY
--FROM PER_DISABILITIES_F DIS
--WHERE DIS.PERSON_ID = ASG.PERSON_ID
--AND DIS.STATUS = 'A'
--AND DIS.EFFECTIVE_START_DATE = (SELECT MAX(DIS2.EFFECTIVE_START_DATE) FROM PER_DISABILITIES_F DIS2 WHERE DIS.PERSON_ID = DIS2.PERSON_ID AND DIS2.EFFECTIVE_START_DATE <= ASP.EXTRACTION_DATE)
--AND ROWNUM = 1
--) AS deficiencia,
 --CASE WHEN (SELECT COUNT(1)
--FROM PER_DISABILITIES_F DIS
--WHERE DIS.PERSON_ID = ASG.PERSON_ID
--AND DIS.STATUS = 'A'
--AND ASP.EXTRACTION_DATE BETWEEN DIS.EFFECTIVE_START_DATE AND DIS.EFFECTIVE_END_DATE
--) > 0 THEN 'S'
--ELSE 'N' END AS tpDeficiencia,

                DIS.CATEGORY AS deficiencia,
                CASE
                    WHEN DIS.CATEGORY IS NOT NULL THEN 'SIM'
                    ELSE 'NAO'
                END AS tpDeficiencia,
                --

                PRM.EMAIL_ADDRESS AS email,
                CASE
                    WHEN PSO.COUNTRY_OF_BIRTH IN ('BR',
                                                  'BRAZIL',
                                                  'Brazil',
                                                  'brazil',
                                                  'BRAsIL',
                                                  'Brasil',
                                                  'brasil') THEN '1'
                    WHEN PSO.COUNTRY_OF_BIRTH IS NULL THEN ''
                    ELSE '2'
                END AS nacionalidade,
                '' AS pais,
                --PSO.COUNTRY_OF_BIRTH AS pais,

                GREATEST(ASG.LAST_UPDATE_DATE, PEO.LAST_UPDATE_DATE, PSO.LAST_UPDATE_DATE, NVL(NAM.LAST_UPDATE_DATE, ASG.LAST_UPDATE_DATE), NVL(PEL.LAST_UPDATE_DATE, ASG.LAST_UPDATE_DATE), NVL(ADR.LAST_UPDATE_DATE, ASG.LAST_UPDATE_DATE),NVL(PPH.LAST_UPDATE_DATE, ASG.LAST_UPDATE_DATE), NVL(PRM.LAST_UPDATE_DATE, ASG.LAST_UPDATE_DATE), NVL(CPF.LAST_UPDATE_DATE, ASG.LAST_UPDATE_DATE), NVL(RG.LAST_UPDATE_DATE, ASG.LAST_UPDATE_DATE), NVL(TET.LAST_UPDATE_DATE, ASG.LAST_UPDATE_DATE), NVL(SEV.LAST_UPDATE_DATE, ASG.LAST_UPDATE_DATE), NVL(DIS.LAST_UPDATE_DATE, ASG.LAST_UPDATE_DATE), NVL(REL.LAST_UPDATE_DATE, ASG.LAST_UPDATE_DATE), NVL(NAM2.LAST_UPDATE_DATE, ASG.LAST_UPDATE_DATE), NVL(DVR.LAST_UPDATE_DATE, ASG.LAST_UPDATE_DATE)) AS UpdateDate,
                ASG.LAST_UPDATE_DATE AS AsgUpdateDate,
                ASG.EFFECTIVE_START_DATE AS EffectiveStartDate,
                ASG.EFFECTIVE_END_DATE AS EffectiveEndDate,
                PEO.PERSON_ID AS PersonId,
                ASG.ASSIGNMENT_ID AS AssignmentId,
                ASG.LEGAL_ENTITY_ID AS LegalEntityId,
                ASG.ACTION_CODE AS ActionCode,
                ASG.ASS_ATTRIBUTE19 AS EstablishmentFlex,
                ASG.ESTABLISHMENT_ID AS EstablishmentId,
                ASG.ASSIGNMENT_TYPE AS AssignmentType,
                ASG.ASSIGNMENT_NUMBER AS AssignmentNumber
FROM PER_ALL_ASSIGNMENTS_M ASG -- Param used as Context do Effective Dates --
INNER JOIN ASSIGN_PARAM ASP ON (1 = 1) -- Person Informations --
INNER JOIN PER_ALL_PEOPLE_F PEO ON (PEO.PERSON_ID = ASG.PERSON_ID
                                    AND ASG.EFFECTIVE_END_DATE BETWEEN PEO.EFFECTIVE_START_DATE AND PEO.EFFECTIVE_END_DATE)
INNER JOIN PER_PERSONS PSO ON (PSO.PERSON_ID = ASG.PERSON_ID)
LEFT JOIN PER_PERSON_NAMES_F NAM ON (NAM.PERSON_ID = ASG.PERSON_ID
                                     AND NAM.NAME_TYPE = 'BR'
                                     AND ASG.EFFECTIVE_END_DATE BETWEEN NAM.EFFECTIVE_START_DATE AND NAM.EFFECTIVE_END_DATE)
LEFT JOIN PER_PEOPLE_LEGISLATIVE_F PEL ON (PEL.PERSON_ID = ASG.PERSON_ID
                                           AND ASG.EFFECTIVE_END_DATE BETWEEN PEL.EFFECTIVE_START_DATE AND PEL.EFFECTIVE_END_DATE)
LEFT JOIN PER_ADDRESSES_F ADR ON (ADR.ADDRESS_ID = PEO.MAILING_ADDRESS_ID
                                  AND ASG.EFFECTIVE_END_DATE BETWEEN ADR.EFFECTIVE_START_DATE AND ADR.EFFECTIVE_END_DATE)
LEFT JOIN PER_PHONES PPH ON (PPH.PHONE_ID = PEO.PRIMARY_PHONE_ID) -- AND PPH.PHONE_TYPE = 'HM'

LEFT JOIN PER_EMAIL_ADDRESSES PRM ON (PRM.EMAIL_ADDRESS_ID = PEO.PRIMARY_EMAIL_ID) -- End Person Informations --
 -- Person Documents --
LEFT JOIN PER_NATIONAL_IDENTIFIERS CPF ON (CPF.PERSON_ID = ASG.PERSON_ID
                                           AND CPF.NATIONAL_IDENTIFIER_TYPE = 'CPF')
LEFT JOIN PER_NATIONAL_IDENTIFIERS RG ON (RG.PERSON_ID = ASG.PERSON_ID
                                          AND RG.NATIONAL_IDENTIFIER_TYPE = 'RG')
LEFT JOIN PER_NATIONAL_IDENTIFIERS TET ON (TET.PERSON_ID = ASG.PERSON_ID
                                           AND TET.NATIONAL_IDENTIFIER_TYPE = 'LACLS_BR_HCM_TIT')
LEFT JOIN PER_NATIONAL_IDENTIFIERS RNE ON (RNE.PERSON_ID = ASG.PERSON_ID
                                           AND RNE.NATIONAL_IDENTIFIER_TYPE = 'ORA_HRX_RNE')
LEFT JOIN PER_DRIVERS_LICENSES DVR ON (DVR.PERSON_ID = ASG.PERSON_ID
                                       AND DVR.DATE_FROM =
                                         (SELECT MAX(DVR2.DATE_FROM)
                                          FROM PER_DRIVERS_LICENSES DVR2
                                          WHERE DVR.PERSON_ID = DVR2.PERSON_ID
                                            AND DVR2.DATE_FROM <= ASG.EFFECTIVE_END_DATE)) -- End Person Documents --
 -- Person Contact Information --
LEFT JOIN PER_CONTACT_RELSHIPS_F REL ON (REL.PERSON_ID = ASG.PERSON_ID
                                         AND REL.CONTACT_TYPE IN ('1',
                                                                  'IN_MR')
                                         AND ASG.EFFECTIVE_END_DATE BETWEEN REL.EFFECTIVE_START_DATE AND REL.EFFECTIVE_END_DATE)
LEFT JOIN PER_PERSON_NAMES_F NAM2 ON (NAM2.PERSON_ID = REL.CONTACT_PERSON_ID
                                      AND NAM2.NAME_TYPE = 'BR'
                                      AND ASG.EFFECTIVE_END_DATE BETWEEN NAM2.EFFECTIVE_START_DATE AND NAM2.EFFECTIVE_END_DATE) -- End Person Contact Information --
 -- Person Work Relationship Informations --
LEFT JOIN PER_PERIODS_OF_SERVICE SEV ON (SEV.PERIOD_OF_SERVICE_ID = ASG.PERIOD_OF_SERVICE_ID) -- End Person Work Relationship Informations --
 -- Assignments Extra Info
LEFT JOIN PER_ASSIGNMENT_EXTRA_INFO_M AEI ON (AEI.ASSIGNMENT_ID = ASG.ASSIGNMENT_ID
                                              AND AEI.INFORMATION_TYPE = 'LACLS_BR_HCM_ADD_PERSON'
                                              AND ASG.EFFECTIVE_END_DATE BETWEEN AEI.EFFECTIVE_START_DATE AND AEI.EFFECTIVE_END_DATE) -- End
 -- Disabilities Information --
LEFT JOIN PER_DISABILITIES_F DIS ON (DIS.PERSON_ID = ASG.PERSON_ID --AND DIS.STATUS = 'A'

                                     AND DIS.EFFECTIVE_START_DATE =
                                       (SELECT MAX(DIS2.EFFECTIVE_START_DATE)
                                        FROM PER_DISABILITIES_F DIS2
                                        WHERE DIS.PERSON_ID = DIS2.PERSON_ID
                                          AND DIS2.EFFECTIVE_START_DATE <= ASG.EFFECTIVE_END_DATE)
                                     AND DIS.LAST_UPDATE_DATE =
                                       (SELECT MAX(DIS3.LAST_UPDATE_DATE)
                                        FROM PER_DISABILITIES_F DIS3
                                        WHERE DIS.PERSON_ID = DIS3.PERSON_ID
                                          AND DIS.EFFECTIVE_START_DATE = DIS3.EFFECTIVE_START_DATE
                                          AND DIS3.EFFECTIVE_START_DATE <= ASG.EFFECTIVE_END_DATE)) -- End Disabilities Information --

WHERE ASG.ACTION_CODE NOT IN ('GLB_TRANSFER',
                              'TRANSFER') --ASG.ASSIGNMENT_STATUS_TYPE = 'ACTIVE'
AND ( -- Future or Current Update
 (:P_AsgNumber IS NULL
  AND TO_CHAR(ASG.EFFECTIVE_END_DATE, 'YYYY-MM-DD') = '4712-12-31'
  AND GREATEST(ASG.LAST_UPDATE_DATE, PEO.LAST_UPDATE_DATE, PSO.LAST_UPDATE_DATE, NVL(NAM.LAST_UPDATE_DATE, ASG.LAST_UPDATE_DATE), NVL(PEL.LAST_UPDATE_DATE, ASG.LAST_UPDATE_DATE), NVL(ADR.LAST_UPDATE_DATE, ASG.LAST_UPDATE_DATE),NVL(PPH.LAST_UPDATE_DATE, ASG.LAST_UPDATE_DATE), NVL(PRM.LAST_UPDATE_DATE, ASG.LAST_UPDATE_DATE), NVL(CPF.LAST_UPDATE_DATE, ASG.LAST_UPDATE_DATE), NVL(RG.LAST_UPDATE_DATE, ASG.LAST_UPDATE_DATE), NVL(TET.LAST_UPDATE_DATE, ASG.LAST_UPDATE_DATE), NVL(SEV.LAST_UPDATE_DATE, ASG.LAST_UPDATE_DATE), NVL(DIS.LAST_UPDATE_DATE, ASG.LAST_UPDATE_DATE), NVL(REL.LAST_UPDATE_DATE, ASG.LAST_UPDATE_DATE), NVL(NAM2.LAST_UPDATE_DATE, ASG.LAST_UPDATE_DATE), NVL(DVR.LAST_UPDATE_DATE, ASG.LAST_UPDATE_DATE)) > :P_UpdateDate) -- Polling Date To Query Just Last Updated Records
 --OR
 -- Correction, Maybe this need to be removed
 --(:P_AsgNumber IS NULL
 --AND ASP.EXTRACTION_DATE BETWEEN ASG.EFFECTIVE_START_DATE AND ASG.EFFECTIVE_END_DATE
 --AND GREATEST(ASG.LAST_UPDATE_DATE, PEO.LAST_UPDATE_DATE, PSO.LAST_UPDATE_DATE, NVL(NAM.LAST_UPDATE_DATE, ASG.LAST_UPDATE_DATE), NVL(PEL.LAST_UPDATE_DATE, ASG.LAST_UPDATE_DATE), NVL(ADR.LAST_UPDATE_DATE, ASG.LAST_UPDATE_DATE),NVL(PPH.LAST_UPDATE_DATE, ASG.LAST_UPDATE_DATE), NVL(PRM.LAST_UPDATE_DATE, ASG.LAST_UPDATE_DATE), NVL(CPF.LAST_UPDATE_DATE, ASG.LAST_UPDATE_DATE), NVL(RG.LAST_UPDATE_DATE, ASG.LAST_UPDATE_DATE), NVL(TET.LAST_UPDATE_DATE, ASG.LAST_UPDATE_DATE), NVL(SEV.LAST_UPDATE_DATE, ASG.LAST_UPDATE_DATE), NVL(DIS.LAST_UPDATE_DATE, ASG.LAST_UPDATE_DATE)) > :P_UpdateDate)

     OR -- Reprocess
 (ASG.ASSIGNMENT_NUMBER = :P_AsgNumber
  AND ASP.EXTRACTION_DATE BETWEEN ASG.EFFECTIVE_START_DATE AND ASG.EFFECTIVE_END_DATE) )
  AND ((REGEXP_LIKE(ASG.ASSIGNMENT_NUMBER, '^[0-9]+$')
        AND ASG.ASSIGNMENT_TYPE IN ('E'))
       OR (ASG.ASSIGNMENT_TYPE IN ('P')
           AND ASG.ASSIGNMENT_STATUS_TYPE = 'ACTIVE'))
  AND ( ASG.LAST_UPDATED_BY != 'FUSION_APPS_HCM_ESS_LOADER_APPID' /*
	AND PEO.LAST_UPDATED_BY != 'FUSION_APPS_HCM_ESS_LOADER_APPID'
	AND PSO.LAST_UPDATED_BY != 'FUSION_APPS_HCM_ESS_LOADER_APPID'
	AND NVL(NAM.LAST_UPDATED_BY, ASG.LAST_UPDATED_BY) != 'FUSION_APPS_HCM_ESS_LOADER_APPID'
	AND NVL(PEL.LAST_UPDATED_BY, ASG.LAST_UPDATED_BY) != 'FUSION_APPS_HCM_ESS_LOADER_APPID'
	AND NVL(ADR.LAST_UPDATED_BY, ASG.LAST_UPDATED_BY) != 'FUSION_APPS_HCM_ESS_LOADER_APPID'
	AND NVL(PPH.LAST_UPDATED_BY, ASG.LAST_UPDATED_BY) != 'FUSION_APPS_HCM_ESS_LOADER_APPID'
	AND NVL(PRM.LAST_UPDATED_BY, ASG.LAST_UPDATED_BY) != 'FUSION_APPS_HCM_ESS_LOADER_APPID'
	AND NVL(CPF.LAST_UPDATED_BY, ASG.LAST_UPDATED_BY) != 'FUSION_APPS_HCM_ESS_LOADER_APPID'
	AND NVL(RG.LAST_UPDATED_BY, ASG.LAST_UPDATED_BY) != 'FUSION_APPS_HCM_ESS_LOADER_APPID'
	AND NVL(TET.LAST_UPDATED_BY, ASG.LAST_UPDATED_BY) != 'FUSION_APPS_HCM_ESS_LOADER_APPID'
	AND NVL(SEV.LAST_UPDATED_BY, ASG.LAST_UPDATED_BY) != 'FUSION_APPS_HCM_ESS_LOADER_APPID'
	AND NVL(DIS.LAST_UPDATED_BY, ASG.LAST_UPDATED_BY) != 'FUSION_APPS_HCM_ESS_LOADER_APPID'
	*/ )
ORDER BY GREATEST(ASG.LAST_UPDATE_DATE, PEO.LAST_UPDATE_DATE, PSO.LAST_UPDATE_DATE, NVL(NAM.LAST_UPDATE_DATE, ASG.LAST_UPDATE_DATE), NVL(PEL.LAST_UPDATE_DATE, ASG.LAST_UPDATE_DATE), NVL(ADR.LAST_UPDATE_DATE, ASG.LAST_UPDATE_DATE),NVL(PPH.LAST_UPDATE_DATE, ASG.LAST_UPDATE_DATE), NVL(PRM.LAST_UPDATE_DATE, ASG.LAST_UPDATE_DATE), NVL(CPF.LAST_UPDATE_DATE, ASG.LAST_UPDATE_DATE), NVL(RG.LAST_UPDATE_DATE, ASG.LAST_UPDATE_DATE), NVL(TET.LAST_UPDATE_DATE, ASG.LAST_UPDATE_DATE), NVL(SEV.LAST_UPDATE_DATE, ASG.LAST_UPDATE_DATE), NVL(DIS.LAST_UPDATE_DATE, ASG.LAST_UPDATE_DATE)) ASC
OFFSET NVL(:P_Page * 4000, 0) ROWS FETCH NEXT 4000 ROWS ONLY -- Employment Information
 --
-- Vinicius L Cabral (Peloton) >  Grupo Matheus > RSData
-- Update Date: 2023-11-24
-- Inclusão e movimentação Empregado
-- Doc Reference:
--
 WITH ASSIGN_PARAM AS ( -- If you are testing use the line below

                       SELECT CASE
                                  WHEN :P_AsgNumber IS NULL THEN SYSDATE
                                  ELSE NVL(TO_DATE(TO_CHAR(:P_UpdateDate, 'YYYY-MM-DD'), 'YYYY-MM-DD'), SYSDATE)
                              END AS EXTRACTION_DATE
                       FROM DUAL )
SELECT ORG.LEGAL_ENTITY_ID AS LegalEntityId,
       ORG.ORGANIZATION_ID AS LegalEntityOrganizationId,
       ORG.NAME AS LegalEntityName,
       ORG.CLASSIFICATION_CODE AS LegalEntityClassificationCode,
       ORG.ORGANIZATION_CODE AS LegalEntityOrgCode,
       '' AS codIntegracaoEmpresa,
       ORGE.ESTABLISHMENT_ID AS EstabId,
       ORGE.ORGANIZATION_ID AS EstabOrganizationId,
       ORGE.NAME AS EstabName,
       ORGE.CLASSIFICATION_CODE AS EstabClassificationCode,
       ORGE.ORGANIZATION_CODE AS EstabOrgCode,
       REG.REGISTRATION_NUMBER AS nrCNPJEmpresaMatriz,
       REG.REGISTERED_NAME AS razaoSocialEmpresaMatriz,
       REE.REGISTRATION_NUMBER AS nrCNPJEmpresa,
       REE.REGISTRATION_NUMBER AS EstablishmentFlex,
       REE.REGISTERED_NAME AS razaoSocialEmpresa,
       '' AS denominacaoEmpresa,
       '' AS idEmpresa,
       '' AS ambienteTerceiro
FROM HR_ORGANIZATION_V ORG -- Param used as Context do Effective Dates --
INNER JOIN ASSIGN_PARAM ASP ON (1 = 1) -- Establishment for Legal Entity
INNER JOIN XLE_ETB_PROFILES EP ON (EP.LEGAL_ENTITY_ID = ORG.LEGAL_ENTITY_ID
                                   AND ASP.EXTRACTION_DATE BETWEEN NVL(EP.EFFECTIVE_FROM, TO_DATE('1951-01-01','YYYY-MM-DD')) AND NVL(EP.EFFECTIVE_TO, TO_DATE('4712-12-31','YYYY-MM-DD'))) -- Legal Entity Info and Registration
INNER JOIN HR_ORGANIZATION_V ORGE ON (ORGE.ESTABLISHMENT_ID = EP.ESTABLISHMENT_ID
                                      AND ORGE.STATUS = 'A'
                                      AND ORGE.CLASSIFICATION_CODE = 'HCM_REPORTING_ESTABLISHMENT'
                                      AND ASP.EXTRACTION_DATE BETWEEN ORGE.EFFECTIVE_START_DATE AND ORGE.EFFECTIVE_END_DATE)
LEFT JOIN XLE_REGISTRATIONS REG ON (REG.SOURCE_ID = ORG.LEGAL_ENTITY_ID
                                    AND REG.SOURCE_TABLE = 'XLE_ENTITY_PROFILES') -- Establishment Registration
LEFT JOIN XLE_REGISTRATIONS REE ON (REE.SOURCE_ID = EP.ESTABLISHMENT_ID
                                    AND REE.SOURCE_TABLE = 'XLE_ETB_PROFILES')
WHERE 1 = 1
  AND ASP.EXTRACTION_DATE BETWEEN ORG.EFFECTIVE_START_DATE AND ORG.EFFECTIVE_END_DATE
  AND ORG.STATUS = 'A'
  AND ORG.CLASSIFICATION_CODE = 'HCM_LEMP'
  AND ROWNUM = 1 -- Job History
 --
-- Vinicius L Cabral (Peloton) >  Grupo Matheus > RSData
-- Update Date: 2023-11-24
-- Inclusão e movimentação Empregado
-- Doc Reference:
--
 WITH ASSIGN_PARAM AS ( -- If you are testing use the line below

                       SELECT CASE WHEN :P_AsgNumber IS NULL THEN SYSDATE ELSE NVL(TO_DATE(TO_CHAR(:P_UpdateDate, 'YYYY-MM-DD'), 'YYYY-MM-DD'), SYSDATE) END AS EXTRACTION_DATE
                       FROM DUAL )
  SELECT *
  FROM
    ( SELECT *
     FROM
       ( SELECT DISTINCT ASG.PERSON_ID AS PersonId,
                         ASG.ASSIGNMENT_ID AS AssignmentId,
                         ASG.EFFECTIVE_START_DATE AS EffectiveStartDate,
                         ASG.EFFECTIVE_END_DATE AS EffectiveEndDate,
                         '' AS tpMovimentacao,
                         TO_CHAR(ASG.EFFECTIVE_START_DATE, 'DD/MM/YYYY') AS dtInicio,
                         CASE WHEN TO_CHAR(ASG.EFFECTIVE_END_DATE, 'DD/MM/YYYY') = '31/12/4712' THEN '' ELSE TO_CHAR(ASG.EFFECTIVE_END_DATE, 'DD/MM/YYYY') END AS dtSaida,
                                                                                                                                                                  OUN.INTERNAL_ADDRESS_LINE AS cdSetor,
                                                                                                                                                                  SEO.NAME AS nomeSetor,
                                                                                                                                                                  '' AS cdSetorDesenvolvido,
                                                                                                                                                                  '' AS nomeSetorDesenvolvido,
                                                                                                                                                                  JOB.JOB_CODE AS cdCargo,
                                                                                                                                                                  JOT.NAME AS nomeCargo,
                                                                                                                                                                  '' AS cdCargoDesenvolvido,
                                                                                                                                                                  '' AS cargoDesenvolvido,
                                                                                                                                                                  JLG.INFORMATION1 AS cargoCBO,
                                                                                                                                                                  '' AS descSumariaCargo,
                                                                                                                                                                  '' AS descDetalhadaCargo,
                                                                                                                                                                  POS.POSITION_CODE AS cdPosicaoTrabalho,
                                                                                                                                                                  POS.NAME AS nomePosicaoTrabalho,
                                                                                                                                                                  '' AS descSumariaPosicaoTrabalho,
                                                                                                                                                                  '' AS descDetalhadaPosicaoTrabalho,
                                                                                                                                                                  ASG.LAST_UPDATE_DATE AS AsgUpdateDate,
                                                                                                                                                                  TO_CHAR(ASG.EFFECTIVE_START_DATE, 'YYYY-MM-DD') AS EffectiveDate,
                                                                                                                                                                  1 AS Tag
        FROM PER_ALL_ASSIGNMENTS_M ASG -- Param used as Context do Effective Dates --

        INNER JOIN ASSIGN_PARAM ASP ON (1 = 1) -- Job Information --

        INNER JOIN PER_JOBS_F JOB ON (JOB.JOB_ID = ASG.JOB_ID
                                      AND ASG.EFFECTIVE_END_DATE BETWEEN JOB.EFFECTIVE_START_DATE AND JOB.EFFECTIVE_END_DATE)
        LEFT JOIN PER_JOBS_F_TL JOT ON (JOT.JOB_ID = ASG.JOB_ID
                                        AND JOT.LANGUAGE = 'PTB'
                                        AND ASG.EFFECTIVE_END_DATE BETWEEN JOT.EFFECTIVE_START_DATE AND JOT.EFFECTIVE_END_DATE)
        LEFT JOIN PER_JOB_LEG_F JLG ON (JLG.JOB_ID = ASG.JOB_ID
                                        AND JLG.LEGISLATION_CODE = 'BR'
                                        AND ASG.EFFECTIVE_END_DATE BETWEEN JLG.EFFECTIVE_START_DATE AND JLG.EFFECTIVE_END_DATE)
        LEFT JOIN HR_ORGANIZATION_V SEO ON (SEO.ORGANIZATION_ID = ASG.ORGANIZATION_ID
                                            AND SEO.STATUS = 'A'
                                            AND ASG.EFFECTIVE_END_DATE BETWEEN SEO.EFFECTIVE_START_DATE AND SEO.EFFECTIVE_END_DATE)
        LEFT JOIN HR_ALL_ORGANIZATION_UNITS_F OUN ON (OUN.ORGANIZATION_ID = SEO.ORGANIZATION_ID
                                                      AND ASG.EFFECTIVE_END_DATE BETWEEN OUN.EFFECTIVE_START_DATE AND OUN.EFFECTIVE_END_DATE)
        LEFT JOIN HR_ALL_POSITIONS_F_VL POS ON (POS.POSITION_ID = ASG.POSITION_ID
                                                AND ASG.EFFECTIVE_END_DATE BETWEEN POS.EFFECTIVE_START_DATE AND POS.EFFECTIVE_END_DATE) -- End Job Information --

        WHERE 1 = 1 --AND ROWNUM <= 10
 --AND ASG.ACTION_CODE NOT IN ('GLB_TRANSFER', 'TRANSFER')

          AND ASG.ASSIGNMENT_STATUS_TYPE = 'ACTIVE'
          AND ASG.EFFECTIVE_LATEST_CHANGE = 'Y' --AND ((REGEXP_LIKE(ASG.ASSIGNMENT_NUMBER, '^[0-9]+$') AND ASG.ASSIGNMENT_TYPE IN ('E')) OR (ASG.ASSIGNMENT_TYPE IN ('P') AND ASG.ASSIGNMENT_STATUS_TYPE = 'ACTIVE'))

          AND ((ASG.ASSIGNMENT_TYPE IN ('E'))
               OR (ASG.ASSIGNMENT_TYPE IN ('P')
                   AND ASG.ASSIGNMENT_STATUS_TYPE = 'ACTIVE'))
        ORDER BY ASG.EFFECTIVE_START_DATE DESC )
     UNION ALL SELECT *
     FROM
       ( SELECT DISTINCT ASG.PERSON_ID AS PersonId,
                         ASG.ASSIGNMENT_ID AS AssignmentId,
                         ASG.EFFECTIVE_START_DATE AS EffectiveStartDate,
                         ASG.EFFECTIVE_END_DATE AS EffectiveEndDate,
                         CASE WHEN ASG.AUDIT_ACTION_TYPE_ = 'DELETE' THEN 'E' ELSE '' END AS tpMovimentacao,
                                                                                             TO_CHAR(ASG.EFFECTIVE_START_DATE, 'DD/MM/YYYY') AS dtInicio,
                                                                                             CASE WHEN TO_CHAR(ASG.EFFECTIVE_END_DATE, 'DD/MM/YYYY') = '31/12/4712' THEN '' ELSE TO_CHAR(ASG.EFFECTIVE_END_DATE, 'DD/MM/YYYY') END AS dtSaida,
OUN.INTERNAL_ADDRESS_LINE AS cdSetor,
SEO.NAME AS nomeSetor,
'' AS cdSetorDesenvolvido,
'' AS nomeSetorDesenvolvido,
JOB.JOB_CODE AS cdCargo,
JOT.NAME AS nomeCargo,
'' AS cdCargoDesenvolvido,
'' AS cargoDesenvolvido,
JLG.INFORMATION1 AS cargoCBO,
'' AS descSumariaCargo,
'' AS descDetalhadaCargo,
POS.POSITION_CODE AS cdPosicaoTrabalho,
POS.NAME AS nomePosicaoTrabalho,
'' AS descSumariaPosicaoTrabalho,
'' AS descDetalhadaPosicaoTrabalho,
ASG.LAST_UPDATE_DATE AS AsgUpdateDate,
TO_CHAR(ASG.EFFECTIVE_START_DATE, 'YYYY-MM-DD') AS EffectiveDate,
0 AS Tag
        FROM PER_ALL_ASSIGNMENTS_M_ ASG -- Param used as Context do Effective Dates --

        INNER JOIN ASSIGN_PARAM ASP ON (1 = 1) -- Job Information --

        INNER JOIN PER_JOBS_F JOB ON (JOB.JOB_ID = ASG.JOB_ID
                                      AND ASG.EFFECTIVE_END_DATE BETWEEN JOB.EFFECTIVE_START_DATE AND JOB.EFFECTIVE_END_DATE)
        LEFT JOIN PER_JOBS_F_TL JOT ON (JOT.JOB_ID = ASG.JOB_ID
                                        AND JOT.LANGUAGE = 'PTB'
                                        AND ASG.EFFECTIVE_END_DATE BETWEEN JOT.EFFECTIVE_START_DATE AND JOT.EFFECTIVE_END_DATE)
        LEFT JOIN PER_JOB_LEG_F JLG ON (JLG.JOB_ID = ASG.JOB_ID
                                        AND JLG.LEGISLATION_CODE = 'BR'
                                        AND ASG.EFFECTIVE_END_DATE BETWEEN JLG.EFFECTIVE_START_DATE AND JLG.EFFECTIVE_END_DATE)
        LEFT JOIN HR_ORGANIZATION_V SEO ON (SEO.ORGANIZATION_ID = ASG.ORGANIZATION_ID
                                            AND SEO.STATUS = 'A'
                                            AND ASG.EFFECTIVE_END_DATE BETWEEN SEO.EFFECTIVE_START_DATE AND SEO.EFFECTIVE_END_DATE)
        LEFT JOIN HR_ALL_ORGANIZATION_UNITS_F OUN ON (OUN.ORGANIZATION_ID = SEO.ORGANIZATION_ID
                                                      AND ASG.EFFECTIVE_END_DATE BETWEEN OUN.EFFECTIVE_START_DATE AND OUN.EFFECTIVE_END_DATE)
        LEFT JOIN HR_ALL_POSITIONS_F_VL POS ON (POS.POSITION_ID = ASG.POSITION_ID
                                                AND ASG.EFFECTIVE_END_DATE BETWEEN POS.EFFECTIVE_START_DATE AND POS.EFFECTIVE_END_DATE) -- End Job Information --

WHERE 1 = 1 --AND ROWNUM <= 10

AND ASG.AUDIT_ACTION_TYPE_ = 'DELETE' --AND ASG.ACTION_CODE NOT IN ('GLB_TRANSFER', 'TRANSFER')

AND ASG.ASSIGNMENT_STATUS_TYPE = 'ACTIVE'
AND ASG.LAST_UPDATE_DATE > :P_UpdateDate --AND ((REGEXP_LIKE(ASG.ASSIGNMENT_NUMBER, '^[0-9]+$') AND ASG.ASSIGNMENT_TYPE IN ('E')) OR (ASG.ASSIGNMENT_TYPE IN ('P') AND ASG.ASSIGNMENT_STATUS_TYPE = 'ACTIVE'))

AND ((ASG.ASSIGNMENT_TYPE IN ('E'))
     OR (ASG.ASSIGNMENT_TYPE IN ('P')
         AND ASG.ASSIGNMENT_STATUS_TYPE = 'ACTIVE'))
        ORDER BY ASG.EFFECTIVE_START_DATE DESC ) ) WHERE ROWNUM <= 5
ORDER BY Tag ASC
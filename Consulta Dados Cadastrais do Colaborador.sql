SELECT '1' AS "Tipo",
       '' AS "Unidade Marítima",
       POS.ATTRIBUTE1 AS "CNPJ/CPF/CEI/CAEPF",
       pern.full_name AS "Nome",
       'BRA' AS "Nacionalidade",
       to_char(perv.date_of_birth, 'DD/MM/YYYY') AS "Nascimento",
       substr(
                (SELECT FLVG.MEANING
                 FROM PER_ALL_PEOPLE_f PAPF, PER_PEOPLE_LEGISLATIVE_F PPLF, FND_LOOKUP_VALUES FLVG
                 WHERE PAPF.PERSON_ID = PPLF.PERSON_ID
                   AND PPLF.LEGISLATION_CODE = 'BR'
                   AND FLVG.LANGUAGE = 'PTB'
                   AND papf.person_id = asg.person_id
                   AND TRUNC (SYSDATE) BETWEEN PPLF.EFFECTIVE_START_DATE AND PPLF.EFFECTIVE_END_DATE
                   AND TRUNC (SYSDATE) BETWEEN PAPF.EFFECTIVE_START_DATE AND PAPF.EFFECTIVE_END_DATE
                   AND PPLF.SEX = FLVG.LOOKUP_CODE
                   AND FLVG.LOOKUP_TYPE = 'SEX'), 1, 1) AS "Sexo",
       PEL.PER_INFORMATION1 AS "CTPS",
       PEL.PER_INFORMATION2 AS "Série",
       TO_CHAR(PEL.PER_INFORMATION_DATE1, 'DD/MM/YYYY') AS "DT Emissão",
       PEL.PER_INFORMATION3 AS "UF Emissão",
       SUBSTR(regexp_replace(RG.NATIONAL_IDENTIFIER_NUMBER,'\W'), 0, 15) AS "Identidade",
       RG.PLACE_OF_ISSUE AS "Órgão Exp.",
       TO_CHAR(RG.ISSUE_DATE, 'DD/MM/YYYY') AS "DT Emissão RG",

  (SELECT GEO.GEOGRAPHY_NAME
   FROM HZ_GEOGRAPHIES GEO
   WHERE GEO.GEOGRAPHY_CODE = RG.ATTRIBUTE1
     AND ASG.EFFECTIVE_END_DATE BETWEEN GEO.START_DATE AND GEO.END_DATE
     AND ROWNUM = 1) AS "UF Emissão RG",
       PIS.NATIONAL_IDENTIFIER_NUMBER AS "NIT (PIS/PASEP)",
       regexp_replace(CPF.NATIONAL_IDENTIFIER_NUMBER,'\W') AS "CPF",
       '' AS "RNE",
       asg.assignment_number AS "Matrícula",
       '' AS "Matrícula RH",
       '2' AS "Vínculo",
       'NA' AS "BR/PDH",
       'NA' AS "Reg. Revez",
       TO_CHAR(SEV.DATE_START, 'DD/MM/YYYY') AS "Admissão",
       '' AS "Demissão",
       '' AS "Observação",
       '' AS "Email",
       (CASE
            WHEN ADR.ADDRESS_LINE_1 IS NOT NULL THEN (ADR.ADDL_ADDRESS_ATTRIBUTE3 || ' ' || ADR.ADDRESS_LINE_1 || ', ' || ADR.ADDRESS_LINE_2 || ' ' || ADR.ADDRESS_LINE_3)
            ELSE NULL
        END) AS "Endereço",
       ADR.TOWN_OR_CITY AS "Cidade",
       ADR.ADDRESS_LINE_4 AS "Bairro",
       ADR.REGION_2 AS "Estado",
       'BRA' AS "País",
       ADR.POSTAL_CODE AS "CEP",
       '' AS "Telefone",

  (SELECT PPH.AREA_CODE || PPH.PHONE_NUMBER
   FROM PER_PHONES PPH
   WHERE PPH.PHONE_ID = PEO.PRIMARY_PHONE_ID) AS "Celular",
       '' AS "Remuneração Mensal",

  (SELECT NAM2.FULL_NAME
   FROM PER_PERSON_NAMES_F NAM2,
                           PER_CONTACT_RELSHIPS_F REL
   WHERE NAM2.PERSON_ID = REL.CONTACT_PERSON_ID
     AND NAM2.NAME_TYPE = 'BR'
     AND REL.PERSON_ID = ASG.PERSON_ID
     AND REL.CONTACT_TYPE IN ('1',
                              'IN_MR')
     AND ASG.EFFECTIVE_END_DATE BETWEEN NAM2.EFFECTIVE_START_DATE AND NAM2.EFFECTIVE_END_DATE
     AND ASG.EFFECTIVE_END_DATE BETWEEN REL.EFFECTIVE_START_DATE AND REL.EFFECTIVE_END_DATE) AS "Nome da Mãe",
       '' AS "Filiação à Previdência Social",
       (CASE
            WHEN PEL.MARITAL_STATUS = 'S' THEN '1'
            WHEN PEL.MARITAL_STATUS = 'M' THEN '2'
            WHEN PEL.MARITAL_STATUS = 'W' THEN '3'
            WHEN PEL.MARITAL_STATUS = 'D' THEN '4'
            ELSE PEL.MARITAL_STATUS
        END) AS "Estado Civil",
       '2' AS "Aposentado",

  (SELECT TET.NATIONAL_IDENTIFIER_NUMBER
   FROM PER_NATIONAL_IDENTIFIERS TET
   WHERE TET.PERSON_ID = ASG.PERSON_ID
     AND TET.NATIONAL_IDENTIFIER_TYPE = 'LACLS_BR_HCM_TIT') AS "Titulo Eleitor",

  (SELECT DVR.LICENSE_NUMBER
   FROM PER_DRIVERS_LICENSES DVR
   WHERE DVR.PERSON_ID = ASG.PERSON_ID
     AND DVR.DATE_FROM =
       (SELECT MAX(DVR2.DATE_FROM)
        FROM PER_DRIVERS_LICENSES DVR2
        WHERE DVR.PERSON_ID = DVR2.PERSON_ID
          AND DVR2.DATE_FROM <= ASG.EFFECTIVE_END_DATE)) AS "CNH",

  (SELECT TO_CHAR(DVR.DATE_TO, 'DD/MM/YYYY')
   FROM PER_DRIVERS_LICENSES DVR
   WHERE DVR.PERSON_ID = ASG.PERSON_ID
     AND DVR.DATE_FROM =
       (SELECT MAX(DVR2.DATE_FROM)
        FROM PER_DRIVERS_LICENSES DVR2
        WHERE DVR.PERSON_ID = DVR2.PERSON_ID
          AND DVR2.DATE_FROM <= ASG.EFFECTIVE_END_DATE)) AS "Validade CNH",
       to_char(asg.effective_start_date, 'DD/MM/YYYY') AS "Inicio",
       --to_char(asg.effective_end_date, 'DD/MM/YYYY') as "Fim",

       '' AS "Fim",

  (SELECT OUN.INTERNAL_ADDRESS_LINE
   FROM HR_ALL_ORGANIZATION_UNITS_F OUN
   WHERE OUN.ORGANIZATION_ID = ASG.ORGANIZATION_ID
     AND ASG.EFFECTIVE_END_DATE BETWEEN OUN.EFFECTIVE_START_DATE AND OUN.EFFECTIVE_END_DATE) AS "Código Setor",

  (SELECT SEO.NAME
   FROM HR_ORGANIZATION_V SEO
   WHERE SEO.ORGANIZATION_ID = ASG.ORGANIZATION_ID
     AND SEO.STATUS = 'A'
     AND ASG.EFFECTIVE_END_DATE BETWEEN SEO.EFFECTIVE_START_DATE AND SEO.EFFECTIVE_END_DATE) AS "Setor",
       '' AS "Cod Setor Desenvolvido",
       '' AS "Setor Desenvolvido",
       '' AS "Local GHE",
       '' AS "Código GHE",
       '' AS "GHE",

  (SELECT JOB.JOB_CODE
   FROM PER_JOBS_F JOB
   WHERE JOB.JOB_ID = ASG.JOB_ID
     AND ASG.EFFECTIVE_END_DATE BETWEEN JOB.EFFECTIVE_START_DATE AND JOB.EFFECTIVE_END_DATE) AS "Código Cargo",

  (SELECT JOT.NAME
   FROM PER_JOBS_F_TL JOT
   WHERE JOT.JOB_ID = ASG.JOB_ID
     AND JOT.LANGUAGE = 'PTB'
     AND ASG.EFFECTIVE_END_DATE BETWEEN JOT.EFFECTIVE_START_DATE AND JOT.EFFECTIVE_END_DATE) AS "Cargo",
       '' AS "Cod Cargo Desenvolvido",
       '' AS "Cargo Deselvolvido",
       '' AS "CBO",
       '' AS "Descrição Sumária do Cargo",
       '' AS "Descrição Detalhada do Cargo",
       POS.POSITION_CODE AS "Código Posição Trabalho",
       POS.NAME AS "Posição Trabalho",
       '' AS "Categoria do Trabalhador",
       '' AS "Código Cartão/Crachá/RFID",
       '' AS "Turno",
       '' AS "Turno Jornada",
       '' AS "Grupo Sanguíneo",
       '' AS "Deficiência",
       '' AS "Código Integração Empresa",
       '' AS "Descrição Ambiente",
       '' AS "Código Integração Empregado",
       '' AS "Data da Transferência",
       '' AS "TIPO unidade ORIGEM",
       '' AS "Unidade Marítima de Origem",
       '' AS "CNPJ/CPF/CEI/CAEPF Origem",
       '' AS "Código Integração Empresa(1)",
       '2' AS "Área"
FROM PER_ALL_ASSIGNMENTS_M ASG
INNER JOIN PER_PERSON_NAMES_F pern ON (asg.person_id = pern.person_id
                                       AND pern.name_type = 'GLOBAL'
                                       AND trunc(sysdate) BETWEEN pern.effective_start_date AND pern.effective_end_date)
INNER JOIN PER_PERSONS_V perv ON (asg.person_id = perv.person_id)
LEFT JOIN PER_PEOPLE_LEGISLATIVE_F PEL ON (PEL.PERSON_ID = ASG.PERSON_ID
                                           AND ASG.EFFECTIVE_END_DATE BETWEEN PEL.EFFECTIVE_START_DATE AND PEL.EFFECTIVE_END_DATE)
LEFT JOIN PER_NATIONAL_IDENTIFIERS RG ON (RG.PERSON_ID = ASG.PERSON_ID
                                          AND RG.NATIONAL_IDENTIFIER_TYPE = 'RG')
LEFT JOIN PER_NATIONAL_IDENTIFIERS CPF ON (CPF.PERSON_ID = ASG.PERSON_ID
                                           AND CPF.NATIONAL_IDENTIFIER_TYPE = 'CPF')
LEFT JOIN PER_NATIONAL_IDENTIFIERS PIS ON (PIS.PERSON_ID = ASG.PERSON_ID
                                           AND PIS.NATIONAL_IDENTIFIER_TYPE = 'PIS')
LEFT JOIN PER_PERIODS_OF_SERVICE SEV ON (SEV.PERIOD_OF_SERVICE_ID = ASG.PERIOD_OF_SERVICE_ID)
LEFT JOIN PER_ALL_PEOPLE_F PEO ON (PEO.PERSON_ID = ASG.PERSON_ID
                                   AND ASG.EFFECTIVE_END_DATE BETWEEN PEO.EFFECTIVE_START_DATE AND PEO.EFFECTIVE_END_DATE)
LEFT JOIN PER_ADDRESSES_F ADR ON (ADR.ADDRESS_ID = PEO.MAILING_ADDRESS_ID
                                  AND ASG.EFFECTIVE_END_DATE BETWEEN ADR.EFFECTIVE_START_DATE AND ADR.EFFECTIVE_END_DATE)
LEFT JOIN HR_ALL_POSITIONS_F_VL POS ON (POS.POSITION_ID = ASG.POSITION_ID
                                        AND ASG.EFFECTIVE_END_DATE BETWEEN POS.EFFECTIVE_START_DATE AND POS.EFFECTIVE_END_DATE)
WHERE asg.assignment_type = 'E'
  AND trunc(sysdate) BETWEEN asg.effective_start_date AND asg.effective_end_date
  AND asg.assignment_status_type <> 'INACTIVE'
    AND POS.ATTRIBUTE1 IS NULL
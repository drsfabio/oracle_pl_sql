--
-- Vinicius L Cabral (Peloton) > Grupo Matheus > Senior
-- Data da Última Atualização: 2025-06-23 (Hoje)
-- Relatório: Movimentação (Foco em Transferências e outros movimentos)
-- Referência de Documento:
--

WITH ASSIGN_PARAM AS (
    SELECT
        -- Define a data de extração fixa para '2025-06-01'.
        -- Isso cria um "instantâneo" (snapshot) dos dados nessa data específica.
        NVL(TO_DATE(TO_CHAR('2025-06-04T00:00:00.000', 'YYYY-MM-DD'), 'YYYY-MM-DD'), TRUNC(SYSDATE)) AS EXTRACTION_DATE
    FROM DUAL
)
SELECT *
FROM (
    SELECT DISTINCT
        'I' AS "TipOpe",
        -- numEmp: Empresa da atribuição ANTERIOR (para GLB_TRANSFER) ou ATUAL (para outros movimentos)
        CASE
            WHEN ASG.ACTION_CODE = 'GLB_TRANSFER' THEN SUBSTR(ANT.ASSIGNMENT_NUMBER, 1, 3)
            ELSE SUBSTR(ASG.ASSIGNMENT_NUMBER, 1, 3)
        END AS "numEmp",
        -- tipCol: Tipo de Colaborador (1 para Empregado, 2 para Outros)
        CASE WHEN ASG.ASSIGNMENT_TYPE = 'E' THEN '1' ELSE '2' END AS "tipCol",
        -- numCad: Matrícula da atribuição ANTERIOR (para GLB_TRANSFER) ou ATUAL (para outros movimentos)
        CASE
            WHEN ASG.ACTION_CODE = 'GLB_TRANSFER' THEN SUBSTR(ANT.ASSIGNMENT_NUMBER, 4, 50)
            ELSE SUBSTR(ASG.ASSIGNMENT_NUMBER, 4, 50)
        END AS "numCad",
        TO_CHAR(ASG.EFFECTIVE_START_DATE, 'DD/MM/YYYY') AS "DatAlt",
        ASG.ACTION_CODE AS "Motivo",
        -- NumEmpNova: Empresa da NOVA atribuição (ASG atual) se for GLB_TRANSFER, senão vazio
        CASE
            WHEN ASG.ACTION_CODE = 'GLB_TRANSFER' THEN SUBSTR(ASG.ASSIGNMENT_NUMBER, 1, 3)
            ELSE ''
        END AS "NumEmpNova",
        -- NumCadNova: Matrícula da NOVA atribuição (ASG atual) se for GLB_TRANSFER, senão vazio
        CASE
            WHEN ASG.ACTION_CODE = 'GLB_TRANSFER' THEN SUBSTR(ASG.ASSIGNMENT_NUMBER, 4, 50)
            ELSE ''
        END AS "NumCadNova",
        POS.POSITION_CODE AS "posTra",
        JOB.JOB_CODE AS "codCar",
        POS.ATTRIBUTE4 AS "codEsc",
        ORG_RIF.ORG_INFORMATION1 AS "codFil",
        REGEXP_REPLACE(ORG_LOC.INTERNAL_ADDRESS_LINE,'\D') AS "numLoc",
        FLX_VAL.FLEX_VALUE AS "codCcu",
        ORG_SID.INTERNAL_ADDRESS_LINE AS "codSin",
        SAL.SALARY_AMOUNT AS "valSal",
        ASG.PARENT_ASSIGNMENT_ID AS "ParentAssignment",
        ASG.ASSIGNMENT_ID AS "Assignment",
        ASG.PERSON_ID AS "PersonId",
        ASG.ASSIGNMENT_NUMBER AS "AssignmentNumber",
        ASG.LAST_UPDATED_BY AS "LatestUpdatedBy",
        SAL.SALARY_BASIS_CODE AS "tipSal",
        (ASG.ASSIGNMENT_NUMBER || TO_CHAR(ASG.EFFECTIVE_START_DATE, 'DDMMYYYY') || TO_CHAR(ASG.LAST_UPDATE_DATE, 'DDMMYYYY') || TO_CHAR(SYSDATE, 'DDMMYYYY')) AS "flowInstanceID",
        'Movimentacao' AS "flowName",
        -- DefFis: Indicador de Deficiência Física
        CASE PDF.CATEGORY
            WHEN 'ORA_HRX_MOTOR_D' THEN 'S'
            WHEN 'SA_HEA_IMP' THEN 'S'
            WHEN 'SA_VIS_IMP' THEN 'S'
            WHEN 'ORA_HRX_MENTAL_D' THEN 'S'
            WHEN 'SA_INT_DIS' THEN 'S'
            ELSE 'N'
        END AS "DefFis",
        -- CodDef: Código da Deficiência
        CASE PDF.CATEGORY
            WHEN 'ORA_HRX_MOTOR_D' THEN 1
            WHEN 'SA_HEA_IMP' THEN 2
            WHEN 'SA_VIS_IMP' THEN 3
            WHEN 'ORA_HRX_MENTAL_D' THEN 4
            WHEN 'SA_INT_DIS' THEN 6
        END AS "CodDef",
        PDF.ATTRIBUTE1 AS "CotDef",
        -- BenRea: Benefício Reabilitação (para categoria '5' de deficiência)
        CASE
            WHEN PDF.CATEGORY IS NOT NULL THEN
                CASE PDF.CATEGORY
                    WHEN '5' THEN 'S'
                    ELSE 'N'
                END
            ELSE NULL
        END AS BenRea,
        ASG.EFFECTIVE_END_DATE,
        GREATEST(ASG.LAST_UPDATE_DATE, NVL(SAL.LAST_UPDATE_DATE, ASG.LAST_UPDATE_DATE)) AS "UpdateDate",
        PAPF.PERSON_NUMBER,
        ASG.CREATED_BY
    FROM
        PER_ALL_ASSIGNMENTS_M ASG

        -- Parâmetro usado como Contexto para Datas Efetivas
        INNER JOIN ASSIGN_PARAM AP ON 1 = 1

        -- Informações de Posição
        LEFT JOIN HR_ALL_POSITIONS_F POS ON POS.POSITION_ID = ASG.POSITION_ID
            AND AP.EXTRACTION_DATE BETWEEN POS.EFFECTIVE_START_DATE AND POS.EFFECTIVE_END_DATE -- Filtra Posição na data de extração

        LEFT JOIN PER_JOBS_F JOB ON JOB.JOB_ID = POS.JOB_ID
            AND AP.EXTRACTION_DATE BETWEEN JOB.EFFECTIVE_START_DATE AND JOB.EFFECTIVE_END_DATE -- Filtra Cargo na data de extração

        LEFT JOIN HR_ORGANIZATION_V ORG_SID ON ORG_SID.ORGANIZATION_ID = POS.UNION_ID
            AND ORG_SID.STATUS = 'A'
            AND ORG_SID.CLASSIFICATION_CODE = 'ORA_PER_UNION'
            AND AP.EXTRACTION_DATE BETWEEN ORG_SID.EFFECTIVE_START_DATE AND ORG_SID.EFFECTIVE_END_DATE -- Filtra Sindicato na data de extração

        LEFT JOIN HR_ORGANIZATION_V ORG_LOC ON ORG_LOC.ORGANIZATION_ID = POS.ORGANIZATION_ID
            AND ORG_LOC.CLASSIFICATION_CODE = 'DEPARTMENT'
            AND AP.EXTRACTION_DATE BETWEEN ORG_LOC.EFFECTIVE_START_DATE AND ORG_LOC.EFFECTIVE_END_DATE -- Filtra Local/Departamento na data de extração

        LEFT JOIN FND_FLEX_VALUES FLX_VAL ON FLX_VAL.FLEX_VALUE_ID = POS.COST_CENTER

        -- Estabelecimento de Relatório
        LEFT JOIN XLE_REGISTRATIONS_V RE ON RE.REGISTRATION_NUMBER = ASG.ASS_ATTRIBUTE19
            AND RE.LEGAL_ENTITY_ID IS NULL
            AND AP.EXTRACTION_DATE BETWEEN NVL(RE.EFFECTIVE_FROM, TO_DATE('1951-01-01','YYYY-MM-DD')) AND NVL(RE.EFFECTIVE_TO, TO_DATE('4712-12-31','YYYY-MM-DD')) -- Filtra Registro Legal na data de extração

        LEFT JOIN HR_ORGANIZATION_V EST ON EST.ESTABLISHMENT_ID = RE.ESTABLISHMENT_ID
            AND EST.STATUS = 'A'
            AND EST.CLASSIFICATION_CODE = 'HCM_REPORTING_ESTABLISHMENT'
            AND AP.EXTRACTION_DATE BETWEEN EST.EFFECTIVE_START_DATE AND EST.EFFECTIVE_END_DATE -- Filtra Estabelecimento na data de extração

        LEFT JOIN HR_ORGANIZATION_INFORMATION_F ORG_RIF ON ORG_RIF.ORG_INFORMATION_CONTEXT IN ('GM_EFF_ORG_FILIAL_DL', 'LACLS_BR_HCM_LRU_CODE')
            AND ORG_RIF.ORGANIZATION_ID = EST.ORGANIZATION_ID
            AND AP.EXTRACTION_DATE BETWEEN ORG_RIF.EFFECTIVE_START_DATE AND ORG_RIF.EFFECTIVE_END_DATE -- Filtra Info de Organização na data de extração

        -- Compensação (Salário)
        LEFT JOIN CMP_SALARY SAL ON SAL.ASSIGNMENT_ID = ASG.ASSIGNMENT_ID
            -- A subquery para SAL.DATE_FROM precisa considerar a data de extração
            AND SAL.DATE_FROM = (SELECT MAX(SAL2.DATE_FROM)
                                 FROM CMP_SALARY SAL2
                                 WHERE SAL2.ASSIGNMENT_ID = ASG.ASSIGNMENT_ID
                                   AND AP.EXTRACTION_DATE BETWEEN SAL2.DATE_FROM AND SAL2.DATE_TO) -- Adiciona filtro de data na subquery de salário

        -- Atribuição Anterior (para GLB_TRANSFER)
        LEFT JOIN PER_ALL_ASSIGNMENTS_M ANT ON ASG.PERSON_ID = ANT.PERSON_ID
            AND ANT.ASSIGNMENT_TYPE IN ('E')
            -- Lógica complexa para a atribuição anterior, mantida conforme sua original
            AND (
                (ASG.PARENT_ASSIGNMENT_ID = ANT.ASSIGNMENT_ID AND ASG.CREATED_BY NOT IN ('FUSION_APPS_HCM_ESS_LOADER_APPID'))
                OR
                (ASG.CREATED_BY = 'FUSION_APPS_HCM_ESS_LOADER_APPID' AND ASG.EFFECTIVE_START_DATE = ANT.EFFECTIVE_START_DATE AND ASG.ASSIGNMENT_ID <> ANT.ASSIGNMENT_ID)
            )
            -- IMPORTANTE: Garante que a atribuição anterior (ANT) também estava efetiva na data DE ENCERRAMENTO da ASG atual - 1 dia (para representar a transição)
            -- OU, se for um instantâneo puro, pode ser a AP.EXTRACTION_DATE
            -- Se a lógica é "a atribuição imediatamente anterior à Data de Início Efetiva da ASG atual", o filtro abaixo é o mais comum.
            AND (ASG.EFFECTIVE_START_DATE - 1) BETWEEN ANT.EFFECTIVE_START_DATE AND ANT.EFFECTIVE_END_DATE


        -- Deficiências
        LEFT JOIN PER_DISABILITIES_F PDF ON ASG.PERSON_ID = PDF.PERSON_ID
            AND AP.EXTRACTION_DATE BETWEEN PDF.EFFECTIVE_START_DATE AND COALESCE(PDF.EFFECTIVE_END_DATE, TO_DATE('4712-12-31','YYYY-MM-DD')) -- Filtra Deficiências na data de extração
            AND PDF.CATEGORY IN ('ORA_HRX_MOTOR_D', 'SA_HEA_IMP', 'SA_VIS_IMP', 'ORA_HRX_MENTAL_D', 'SA_INT_DIS', '5')

        -- Informações de Pessoa (PAPF é essencial e também deve ser filtrado pela EXTRACTION_DATE)
        INNER JOIN PER_ALL_PEOPLE_F PAPF ON ASG.PERSON_ID = PAPF.PERSON_ID
            AND AP.EXTRACTION_DATE BETWEEN PAPF.EFFECTIVE_START_DATE AND PAPF.EFFECTIVE_END_DATE -- Filtra Pessoa na data de extração

    WHERE 1 = 1
        AND ASG.ACTION_CODE NOT IN ('HIRE', 'REHIRE')
        AND ASG.ACTION_CODE = 'GLB_TRANSFER' -- Seu filtro ativo para 'GLB_TRANSFER'
        -- AND ASG.EFFECTIVE_LATEST_CHANGE = 'Y' -- Linha original comentada, mantida assim
        AND ASG.ASSIGNMENT_TYPE IN ('E')
        AND REGEXP_LIKE(ASG.ASSIGNMENT_NUMBER, '^[0-9]+$')
        AND ASG.ASSIGNMENT_STATUS_TYPE = 'ACTIVE' -- Assume que 'ACTIVE' é um status válido na data de extração
        -- A lógica para GLB_TRANSFER e PARENT_ASSIGNMENT_ID
        AND (
            (ASG.ACTION_CODE = 'GLB_TRANSFER' AND (ASG.PARENT_ASSIGNMENT_ID IS NOT NULL OR ASG.CREATED_BY = 'FUSION_APPS_HCM_ESS_LOADER_APPID'))
            OR
            (ASG.ACTION_CODE NOT IN 'GLB_TRANSFER')
        )
        -- FILTRO PRINCIPAL: Garante que a atribuição (ASG) esteja efetiva na data de extração
        AND AP.EXTRACTION_DATE BETWEEN ASG.EFFECTIVE_START_DATE AND ASG.EFFECTIVE_END_DATE
        AND (
            -- Lógica de Polling / Reprocessamento
            (:P_AsgNumber IS NULL
            -- **Refatorado**: Agora usa AP.EXTRACTION_DATE para a comparação de atualização.
            AND GREATEST(ASG.LAST_UPDATE_DATE, NVL(SAL.LAST_UPDATE_DATE, ASG.LAST_UPDATE_DATE)) > AP.EXTRACTION_DATE)
            OR
            -- Reprocessa um Assignment Number específico
            (ASG.ASSIGNMENT_NUMBER = :P_AsgNumber
            AND AP.EXTRACTION_DATE BETWEEN ASG.EFFECTIVE_START_DATE AND ASG.EFFECTIVE_END_DATE) -- A condição de data já está no filtro principal da ASG
        )

    UNION ALL

    -- SEGUNDA PARTE DA UNION ALL (Registros de Auditoria/Deletados)
    SELECT
        NULL AS "codCar",
        NULL AS "codCcu",
        NULL AS "codEsc",
        NULL AS "codFil",
        NULL AS "codSin",
        TO_CHAR(SVC.DATE_START, 'DD/MM/YYYY') AS "datAdm",
        TO_CHAR(PER.DATE_OF_BIRTH, 'DD/MM/YYYY') AS "datNas",
        NULL AS "emaCom",
        NULL AS "emaPar",
        NULL AS "estCiv",
        (ASG_AUD.ASSIGNMENT_NUMBER || TO_CHAR(SVC.DATE_START, 'DDMMYYYY') || TO_CHAR(ASG_AUD.LAST_UPDATE_DATE, 'DDMMYYYY') || TO_CHAR(SYSDATE, 'DDMMYYYY')) AS "flowInstanceID",
        'Movimentacao' AS "flowName", -- Alterado de 'Hire' para 'Movimentacao' para consistência
        NAM.FULL_NAME AS "nomFun",
        SUBSTR(ASG_AUD.ASSIGNMENT_NUMBER, 4, 50) AS "numCad",
        REGEXP_REPLACE(NI_CPF.NATIONAL_IDENTIFIER_NUMBER,'\W') AS "numCpf",
        NULL AS "numCra",
        SUBSTR(ASG_AUD.ASSIGNMENT_NUMBER, 1, 3) AS "numEmp",
        NULL AS "numLoc",
        NULL AS "numPis",
        NULL AS "posTra",
        CASE WHEN ASG_AUD.ASSIGNMENT_TYPE = 'E' THEN '1' ELSE '2' END AS "tipCol",
        '1' AS "tipCon",
        'E' AS "tipOpe",
        NULL AS "tipSal",
        NULL AS "tipSex",
        NULL AS "valSal",
        NULL AS "ApuPon",
        NULL AS "ParPfa",
        NULL AS "AjuPon",
        ASG_AUD.ASSIGNMENT_ID AS "AssignmentId",
        ASG_AUD.PERSON_ID AS "PersonId",
        ASG_AUD.EFFECTIVE_START_DATE AS "EffectiveStartDate",
        PEO.PERSON_NUMBER AS "PersonNumber",
        ASG_AUD.ASSIGNMENT_NUMBER AS "AssignmentNumber",
        NULL AS "DepartmentId",
        ASG_AUD.LAST_UPDATE_DATE AS "UpdateDate",
        NULL AS "CatEso",
        NULL AS "DefFis",
        NULL AS "CodDef",
        NULL AS "CotDef"
    FROM
        PER_ALL_ASSIGNMENTS_M_ ASG_AUD -- Tabela de auditoria/histórico
    INNER JOIN ASSIGN_PARAM AP ON 1 = 1
    -- Informações da Pessoa
    INNER JOIN PER_PERSONS PER ON PER.PERSON_ID = ASG_AUD.PERSON_ID
    INNER JOIN PER_ALL_PEOPLE_F PEO ON PEO.PERSON_ID = ASG_AUD.PERSON_ID
        AND AP.EXTRACTION_DATE BETWEEN PEO.EFFECTIVE_START_DATE AND PEO.EFFECTIVE_END_DATE -- Filtra Pessoa na data de extração
    LEFT JOIN PER_PEOPLE_LEGISLATIVE_F LEGC ON LEGC.PERSON_ID = ASG_AUD.PERSON_ID
        AND AP.EXTRACTION_DATE BETWEEN LEGC.EFFECTIVE_START_DATE AND LEGC.EFFECTIVE_END_DATE -- Filtra Dados Legislativos na data de extração
    LEFT JOIN PER_PERSON_NAMES_F NAM ON NAM.PERSON_ID = ASG_AUD.PERSON_ID
        AND NAM.NAME_TYPE = 'BR'
        AND AP.EXTRACTION_DATE BETWEEN NAM.EFFECTIVE_START_DATE AND NAM.EFFECTIVE_END_DATE -- Filtra Nome na data de extração
    -- Documentos da Pessoa
    LEFT JOIN PER_NATIONAL_IDENTIFIERS NI_CPF ON NI_CPF.PERSON_ID = ASG_AUD.PERSON_ID
        AND NI_CPF.NATIONAL_IDENTIFIER_TYPE = 'CPF'
    -- Informações de Relacionamento de Trabalho
    LEFT JOIN PER_PERIODS_OF_SERVICE SVC ON SVC.PERIOD_OF_SERVICE_ID = ASG_AUD.PERIOD_OF_SERVICE_ID
    WHERE 1 = 1
        AND ASG_AUD.ACTION_CODE IN ('HIRE','REHIRE') -- Mantido como na sua original, mas para Movimentação, talvez seja 'TERM' ou 'TRANSFER'?
        AND ASG_AUD.ASSIGNMENT_TYPE IN ('E')
        AND REGEXP_LIKE(ASG_AUD.ASSIGNMENT_NUMBER, '^[0-9]+$')
        AND ASG_AUD.AUDIT_ACTION_TYPE_ = 'DELETE' -- Filtro específico para registros deletados/auditoria
        AND (
            -- Lógica de Polling / Reprocessamento
            (:P_AsgNumber IS NULL
            -- **Refatorado**: Agora usa AP.EXTRACTION_DATE para a comparação de atualização.
            AND ASG_AUD.LAST_UPDATE_DATE > AP.EXTRACTION_DATE)
            OR
            -- Reprocessa um Assignment Number específico
            (ASG_AUD.ASSIGNMENT_NUMBER = :P_AsgNumber
            AND AP.EXTRACTION_DATE BETWEEN ASG_AUD.EFFECTIVE_START_DATE AND ASG_AUD.EFFECTIVE_END_DATE) -- A condição de data já está no filtro principal da ASG_AUD
        )
) LOV
--OFFSET NVL(:P_Page * 4000, 0) ROWS FETCH NEXT 4000 ROWS ONLY
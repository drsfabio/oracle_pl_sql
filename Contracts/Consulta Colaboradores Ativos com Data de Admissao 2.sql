WITH DADOS_EMPREGADOS AS (
    -- CTE para buscar e organizar os dados brutos dos empregados
    SELECT
        -- IDs e Códigos Principais
        ni.national_identifier_number         AS cpf,
        pessoa.person_number                      AS numero_pessoa,
        contrato.assignment_number            AS numero_contrato,
        SUBSTR(contrato.assignment_number, 1, 3) AS cd_empresa,
        SUBSTR(contrato.assignment_number, 4) AS matricula,
        
        -- Nomes e Descrições
        nome_pessoa.full_name                 AS nome_colaborador,
        empresa_legal.name                    AS nome_empresa_legal,
        unidade_negocio.name                  AS nome_unidade_negocio,
        acao_tl.action_name                   AS ds_acao,
        motivo_tl.action_reason               AS ds_motivo,
        status_tl.user_status                 AS ds_status_contrato,
        tipo_pessoa.system_person_type        AS cd_tipo_pessoa,
        tipo_usuario_tl.user_person_type      AS ds_tipo_usuario,
        
        -- Datas
        CASE
            WHEN serd.entry_date IS NULL THEN contrato.effective_start_date
            ELSE serd.entry_date
        END                                   AS dt_admissao,
        contrato.effective_start_date         AS dt_movimentacao,
        contrato.effective_end_date           AS dt_final_efetiva,
        pp.actual_termination_date            AS dt_desligamento,
        contrato.creation_date - INTERVAL '3' HOUR AS dt_criacao_contrato,

        -- Filial
        rif.org_information1                  AS cd_filial,
        est.name                              AS nome_filial,
        
        -- Desligamento
        motivo_deslig_tl.meaning              AS ds_motivo_desligamento,
        
        -- Departamento, Cargo e Posição
        depto.internal_address_line           AS cd_departamento,
        depto.name                            AS nome_departamento,
        cargo_base.job_code                   AS cd_cargo,
        cargo_tl.name                         AS nome_cargo,
        posicao.position_code                 AS cd_posicao,
        posicao_tl.name                       AS nome_posicao,
        
        -- Sindicato, Salário e Deficiência
        sindicato.internal_address_line       AS cd_sindicato,
        sindicato.name                        AS nome_sindicato,
        salario.salary_amount                 AS vl_salario,
        def.disability_id                     AS cd_deficiencia,

        -- Função ROW_NUMBER para identificar o registro mais recente de cada contrato
        ROW_NUMBER() OVER(
            PARTITION BY contrato.assignment_id 
            ORDER BY contrato.effective_start_date DESC, contrato.effective_sequence DESC
        ) AS rn

    FROM per_all_assignments_m                 contrato
    LEFT JOIN per_all_people_f                 pessoa             ON pessoa.person_id = contrato.person_id
    LEFT JOIN per_person_names_f               nome_pessoa        ON nome_pessoa.person_id = pessoa.person_id AND nome_pessoa.name_type = 'BR'
    LEFT JOIN per_national_identifiers         ni                 ON ni.person_id = pessoa.person_id AND ni.national_identifier_type = 'CPF'
    LEFT JOIN per_periods_of_service           pp                 ON pp.period_of_service_id = contrato.period_of_service_id
    
    -- Joins para Status, Tipo de Pessoa e Usuário
    LEFT JOIN per_person_type_usages_m         tipo_pessoa        ON tipo_pessoa.person_id = contrato.person_id AND tipo_pessoa.system_person_type IN ('CWK', 'EMP', 'NONW')
    LEFT JOIN per_person_types_tl              tipo_usuario_tl    ON tipo_usuario_tl.person_type_id = tipo_pessoa.person_type_id AND tipo_usuario_tl.language = USERENV('LANG')
    LEFT JOIN per_assignment_status_types_tl   status_tl          ON status_tl.assignment_status_type_id = contrato.assignment_status_type_id AND status_tl.language = USERENV('LANG')
    
    -- Joins para Organizações (Empresa, Unidade, Depto, Sindicato)
    LEFT JOIN hr_organization_v                empresa_legal      ON empresa_legal.organization_id = contrato.legal_entity_id AND empresa_legal.classification_code = 'HCM_LEMP' AND empresa_legal.status = 'A'
    LEFT JOIN hr_organization_v                unidade_negocio    ON unidade_negocio.organization_id = contrato.business_unit_id AND unidade_negocio.classification_code = 'FUN_BUSINESS_UNIT' AND unidade_negocio.status = 'A'
    LEFT JOIN hr_organization_v                depto              ON depto.organization_id = contrato.organization_id AND depto.classification_code = 'DEPARTMENT' AND depto.status = 'A'
    LEFT JOIN hr_organization_v                sindicato          ON sindicato.organization_id = contrato.union_id AND sindicato.classification_code = 'ORA_PER_UNION' AND sindicato.status = 'A'

    -- Joins para Cargo (Job) e Posição (Position)
    LEFT JOIN per_jobs_f                       cargo_base         ON cargo_base.job_id = contrato.job_id
    LEFT JOIN per_jobs_f_tl                    cargo_tl           ON cargo_tl.job_id = cargo_base.job_id AND cargo_tl.language = USERENV('LANG')
    LEFT JOIN hr_all_positions_f               posicao            ON posicao.position_id = contrato.position_id
    LEFT JOIN hr_all_positions_f_tl            posicao_tl         ON posicao_tl.position_id = posicao.position_id AND posicao_tl.language = USERENV('LANG')

    -- Joins para Ações e Motivos do Contrato
    LEFT JOIN per_action_occurrences           acao_ocorrencia    ON acao_ocorrencia.action_occurrence_id = contrato.action_occurrence_id
    LEFT JOIN per_actions_b                    acao_b             ON acao_b.action_id = acao_ocorrencia.action_id
    LEFT JOIN per_actions_tl                   acao_tl            ON acao_tl.action_id = acao_b.action_id AND acao_tl.language = USERENV('LANG')
    LEFT JOIN per_action_reasons_b             motivo_b           ON motivo_b.action_reason_id = acao_ocorrencia.action_reason_id
    LEFT JOIN per_action_reasons_tl            motivo_tl          ON motivo_tl.action_reason_id = motivo_b.action_reason_id AND motivo_tl.language = USERENV('LANG')

    -- Joins para Motivo de Desligamento
    LEFT JOIN per_periods_of_service           pt_deslig          ON pt_deslig.period_of_service_id = contrato.period_of_service_id AND pt_deslig.attribute_category = 'LACLS_BR_HCM_INFO_TERM'
    LEFT JOIN fnd_lookup_values_tl             motivo_deslig_tl   ON motivo_deslig_tl.lookup_code = pt_deslig.attribute2 AND motivo_deslig_tl.lookup_type = 'LACLS_BR_HCM_REA_PAY_TERM' AND motivo_deslig_tl.language = USERENV('LANG')
    
    -- Joins para Salário, Deficiência e Senioridade
    LEFT JOIN cmp_salary                       salario            ON salario.assignment_id = contrato.assignment_id
    LEFT JOIN per_disabilities_f               def                ON def.person_id = pessoa.person_id
    LEFT JOIN per_seniority_dates_f            serd               ON serd.person_id = pessoa.person_id AND serd.level_code = 'ORA_P' AND serd.seniority_date_code IN ('LACLS_BR_HCM_SD_E', 'ORA_PER_MIGR_ESD_P')
    
    -- Joins para Filial (um pouco mais complexo)
    LEFT JOIN xle_registrations_v              re                 ON re.registration_number = contrato.ass_attribute19 AND re.legal_entity_id IS NULL
    LEFT JOIN hr_organization_v                est                ON est.establishment_id = re.establishment_id AND est.status = 'A' AND est.classification_code = 'HCM_REPORTING_ESTABLISHMENT'
    LEFT JOIN hr_organization_information_f    rif                ON rif.organization_id = est.organization_id AND rif.org_information_context = 'LACLS_BR_HCM_LRU_CODE'

    WHERE 
        contrato.assignment_type = 'E'
        AND status_tl.assignment_status_type_id = 1 -- 'Ativo - Elegível para Folha de Pagamento'
        --AND contrato.assignment_number = '0041949' -- Filtro de teste
        
        -- Otimização: Comparar datas diretamente ao invés de converter para texto
        -- A data '4712-12-31' é frequentemente usada em sistemas Oracle para representar "até o fim dos tempos" ou "registro ativo"
        AND contrato.effective_end_date        = TO_DATE('4712-12-31', 'YYYY-MM-DD')
        AND pessoa.effective_end_date          = TO_DATE('4712-12-31', 'YYYY-MM-DD')
        AND nome_pessoa.effective_end_date     = TO_DATE('4712-12-31', 'YYYY-MM-DD')
        AND tipo_pessoa.effective_end_date     = TO_DATE('4712-12-31', 'YYYY-MM-DD')
        AND cargo_base.effective_end_date      = TO_DATE('4712-12-31', 'YYYY-MM-DD')
        AND cargo_tl.effective_end_date        = TO_DATE('4712-12-31', 'YYYY-MM-DD')
        AND posicao.effective_end_date         = TO_DATE('4712-12-31', 'YYYY-MM-DD')
        AND posicao_tl.effective_end_date      = TO_DATE('4712-12-31', 'YYYY-MM-DD')
        AND def.effective_end_date             = TO_DATE('4712-12-31', 'YYYY-MM-DD')
        AND salario.date_to                    = TO_DATE('4712-12-31', 'YYYY-MM-DD')
        
        -- Condições de data para joins complexos movidas para a cláusula WHERE para maior clareza
        AND contrato.effective_end_date BETWEEN NVL(re.effective_from, TO_DATE('1951-01-01', 'YYYY-MM-DD')) AND NVL(re.effective_to, TO_DATE('4712-12-31', 'YYYY-MM-DD'))
        AND contrato.effective_end_date BETWEEN est.effective_start_date AND est.effective_end_date
        AND contrato.effective_end_date BETWEEN rif.effective_start_date AND rif.effective_end_date
)
SELECT
    -- Seleciona todas as colunas da CTE, exceto a coluna de controle 'rn'
    cpf,
    numero_pessoa,
    numero_contrato,
    cd_empresa,
    matricula,
    nome_colaborador,
    nome_empresa_legal,
    nome_unidade_negocio,
    ds_acao,
    ds_motivo,
    ds_status_contrato,
    cd_tipo_pessoa,
    ds_tipo_usuario,
    TO_CHAR(dt_admissao, 'DD/MM/YYYY') AS dt_admissao,
    TO_CHAR(dt_movimentacao, 'DD/MM/YYYY') AS dt_movimentacao,
    TO_CHAR(dt_final_efetiva, 'DD/MM/YYYY') AS dt_final_efetiva,
    TO_CHAR(dt_desligamento, 'DD/MM/YYYY') AS dt_desligamento,
    TO_CHAR(dt_criacao_contrato, 'DD/MM/YYYY HH24:MI:SS') AS dt_criacao_contrato,
    cd_filial,
    nome_filial,
    ds_motivo_desligamento,
    cd_departamento,
    nome_departamento,
    cd_cargo,
    nome_cargo,
    cd_posicao,
    nome_posicao,
    cd_sindicato,
    nome_sindicato,
    vl_salario,
    cd_deficiencia
FROM DADOS_EMPREGADOS
ORDER BY
    dt_movimentacao DESC,
    TO_NUMBER(numero_pessoa);
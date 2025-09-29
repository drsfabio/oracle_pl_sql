-- UGS

SELECT
    to_char(MAX(creation_date), 'YYYY-MM-DD HH24:MI:SS') param_date
FROM
    lacls.lacls_br_hcm_load_execution
WHERE
        parent_tracking_id = (
            SELECT
                parent_tracking_id
            FROM
                lacls.lacls_br_hcm_load_execution
            WHERE
                actual_file_name = 'Colaboradores_20241212123335065.csv'
        )
    AND entity_id = 90
    AND status_id = 600;
    
    
--SELECT * FROM lacls.lacls_br_hcm_collaborator_in WHERE assignment_id = '300000148566064'
SELECT LEG_SEX_CODE FROM lacls.lacls_br_hcm_collaborator_in WHERE assignment_id = '300000148566064'

-- Conteudo do Arquivo
SELECT * FROM lacls.lacls_br_hcm_collaborator_out WHERE line_content1 LIKE '%300000148566064%'

SELECT * FROM lacls.lacls_br_hcm_load_execution WHERE actual_file_name = 'PessoaComDeficiencia_20250729120912.csv';
                
-- Dissídio Coletivo Inbound 00267936
SELECT * FROM lacls.lacls_br_hcm_wage_agrmnt_inb WHERE payroll LIKE '%00267936%'

--
SELECT
    *
FROM
    lacls.lacls_br_hcm_wage_agrmnt_inb t
WHERE
        nvl(t.line_extract, 'N') = 'Y'
    AND nvl(t.line_transform, 'N') = 'Y'
    AND nvl(t.line_load, 'N') = 'N'
    AND NOT EXISTS (
        SELECT
            NULL
        FROM
            lacls.lacls_br_hcm_wage_agrmnt_inb x
        WHERE
                t.batch_id = x.batch_id
            AND nvl(x.line_load, 'N') = 'Y'
    )
    AND t.file_name = 'DissidioColetivo_20241119095843860.csv'


SELECT
    *
FROM
    lacls.lacls_br_hcm_log_error_inb
WHERE
    file_name = 'DissidioColetivo_20241119095843860.csv'

-- 
SELECT
    *
FROM
    lacls.lacls_br_hcm_reasons
WHERE action_payroll_reason LIKE '%42%'

SELECT
    *
FROM
    all_source
where OWNER = 'LACLS'


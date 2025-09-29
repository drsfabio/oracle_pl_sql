select * 
from lacls.lacls_br_hcm_collaborator_in
where asgn_assignment_number like '%235902%'
order by last_update_date desc;

SELECT *
FROM
    lacls.lacls_br_hcm_collaborator_out
WHERE line_content1 LIKE '%E3175-3%';

--- Relaciona para encontrar o arquivo de colaborador
select 
c.ETH_ETHNICITY_DESCR, c.*, b.*
from lacls.lacls_br_hcm_collaborator_in c
left join lacls.lacls_br_hcm_collaborator_out b on c.HASH_ID = b.HASH_CODE_INBOUND
where c.asgn_assignment_number = '00417836';

SELECT *
FROM
    lacls_br_hcm_load_execution
WHERE actual_file_name = 'Transferencias_202518135033214.csv'; 

select * from lacls_br_hcm_load_execution where parent_tracking_id = 'rKgX2d9bEe-cibVfKF4asA' and entity_id = 90 order by execution_id;

select * from lacls_br_hcm_entities;

select * from lacls_br_hcm_collaborator_out where file_name = 'Colaboradores_20250203150310.csv';

select * from lacls_br_hcm_load_execution where actual_file_name LIKE 'Transferencias_202518135033214%';

002167867
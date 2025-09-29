SELECT *
FROM
    lacls.lacls_br_hcm_wkr_union_inb
WHERE PAYROLL LIKE '%002128615%';

SELECT *
FROM
    lacls.lacls_br_hcm_wage_agrmnt_inb
WHERE
PAYROLL LIKE '%002128615%';

SELECT *
FROM
    lacls.lacls_br_hcm_alimony_out;
    
SELECT
   *
FROM
    lacls.lacls_br_hcm_log_audit;
    
SELECT *
FROM
    lacls.lacls_br_hcm_load_execution
WHERE message LIKE '%Pensionistas%';
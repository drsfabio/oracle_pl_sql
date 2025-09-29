SELECT *
FROM
    lacls.lacls_br_hcm_wage_agrmnt_inb
--where assignmentnumber = '002167867';
order by last_update_date asc;

SELECT *
FROM
    lacls_br_hcm_trans_term_out
WHERE line_content1 LIKE '%%';


SELECT *
FROM
    lacls_br_hcm_trans_salary_in
WHERE 1=1
AND ROWNUM < 10;


SELECT
    *
FROM
    lacls_br_hcm_wage_agrmnt_inb
WHERE 1 = 1
AND ROWNUM < 10;
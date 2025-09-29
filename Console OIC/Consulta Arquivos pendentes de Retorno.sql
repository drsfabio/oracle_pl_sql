SELECT
    a.execution_id,
    a.actual_file_name,
    a.status_id,
    b.status_name,
    COUNT(*) AS rows_number
FROM
    lacls_br_hcm_load_execution a
    INNER JOIN lacls_br_hcm_exec_status      b ON b.status_id = a.status_id
    LEFT JOIN lacls_br_hcm_collaborator_out c ON c.file_name = a.actual_file_name
WHERE
    a.status_id = 1200
    AND a.creation_date >= TO_DATE('25-07-29', 'yy-mm-dd')
GROUP BY
    a.execution_id,
    a.actual_file_name,
    a.status_id,
    b.status_name;

SELECT
    colaborator_id,
    line_content1,
    line_content2,
    line_content3,
    line_content4,
    line_content5,
    line_content6,
    line_content7,
    line_content8,
    line_content9,
    line_content10,
    hash_code,
    last_update_hash_code,
    hash_code_inbound,
    hash_code_out_control,
    layout_id,
    read,
    file_name
FROM
    lacls_br_hcm_collaborator_out
WHERE
    file_name = 'GestorColaborador_20250729144848.csv';


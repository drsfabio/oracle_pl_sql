DECLARE
    x_return_status VARCHAR2(2000);
    x_msg_error     VARCHAR2(2000);
BEGIN
    lacls_br_hcm_partner_backend.check_executions(
                                                 'AnLLHhRyEfCcvSem-wIPVA', -- tracking_id
                                                 x_return_status,
                                                 x_msg_error
    );
    dbms_output.put_line('x_return_status: ' || x_return_status);
    dbms_output.put_line('x_msg_error: ' || x_msg_error);
END;
/

--Ala3mxRyEfCcvSem-wIPVA
--AnLLHhRyEfCcvSem-wIPVA

select * from lacls_br_hcm_load_execution where execution_id = 3747907;

select count(1), to_date(substr(line_content1, 0, instr(line_content1, ';')-8), 'yyyy/mm/dd') xx--, a.*--count(1), to_date(substr(line_content1, 0, instr(line_content1, ';')-1), 'yyyy/mm/dd')--*
from lacls_br_hcm_transactions_out a
where file_name is not null
and to_date(substr(line_content1, 0, instr(line_content1, ';')-1), 'yyyy/mm/dd') >= trunc(sysdate-8)
group by  to_date(substr(line_content1, 0, instr(line_content1, ';')-8), 'yyyy/mm/dd')
order by 2--count(1), to_date(substr(line_content1, 0, instr(line_content1, ';')-1), 'yyyy/mm/dd')
 --group by to_date(substr(line_content1, 0, instr(line_content1, ';')-1), 'yyyy/mm/dd')
-- and 
 --002136198
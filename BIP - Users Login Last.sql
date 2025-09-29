select distinct
user_name as "Usuário"
/*, 

    max(trunc(last_connect)) as "Último Acesso" */
from FND_SESSIONS ses
where last_connect > trunc(sysdate)
and user_name not in ('anonymous','integracao.gmcore', 'rats_monitor', 'em_monitoring', 'FAAdmin')
and user_name not like 'FUSION%'and (upper(user_name) like '%@GRUPO%' or upper(user_name) like 'GM%')
--group by user_name
--order by 1 desc
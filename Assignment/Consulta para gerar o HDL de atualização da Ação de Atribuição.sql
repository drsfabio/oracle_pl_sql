-- Consulta para gerar o HDL de atualiza��o da A��o de Atribui��o

SELECT 'METADATA|Assignment|AssignmentNumber|EffectiveStartDate|ActionCode' AS HDL_CONTENT
FROM DUAL
UNION ALL
SELECT 'MERGE|Assignment|' || ASSIGNMENT_NUMBER || '|' || TO_CHAR(EFFECTIVE_START_DATE, 'YYYY/MM/DD') || '|HIRE'
FROM PER_ALL_ASSIGNMENTS_M
WHERE ASSIGNMENT_NUMBER = '50110166' -- Especifique o n�mero da atribui��o aqui
  AND ACTION_CODE = 'ORA_SYNC_CONFIG_CHANGE' -- Filtra apenas os registros criados por sincroniza��o
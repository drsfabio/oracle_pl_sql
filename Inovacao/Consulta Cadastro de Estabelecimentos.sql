SELECT est.organization_id,rif.org_information1,est.name,SUBSTR(
    est.organization_code,1,14)
AS Target,est.organization_code
--rif.org_information1 AS ESTABELECIMENTO_CODE, est.name AS ESTABELECIMENTO
FROM hr_organization_v est
LEFT JOIN hr_organization_information_f rif
ON
rif.org_information_context = upper(
    'lacls_br_hcm_lru_code')
        AND rif.organization_id = est.organization_id
        AND TRUNC(
    SYSDATE)
between rif.effective_start_date
        AND rif.effective_end_date
WHERE 1 = 1
        AND est.status = upper(
    'a')
        AND est.classification_code = upper(
    'hcm_reporting_establishment')
        AND TRUNC(
    SYSDATE)
BETWEEN est.effective_start_date AND est.effective_end_date
        AND est.name LIKE '%MIX CABEDELO%';
        
SELECT 	'BIGODE 1' AS TESTE FROM DUAL UNION SELECT 'BIGODE 2' AS TESTE FROM DUAL
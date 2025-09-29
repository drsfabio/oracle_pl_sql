WITH legalentities AS (
    SELECT
    xlep.legal_entity_id
    FROM
    xle_entity_profiles         xlep,
    xle_registrations_v         xreg,
    hz_parties                  xhp,
    hr_all_organization_units_f orgs,
    hz_geographies              hg
    WHERE
    NVL(xlep.effective_to, sysdate) >= sysdate
    AND xreg.identifying = 'Y'
    AND xhp.party_id = xlep.party_id
    AND xreg.legal_entity_id = xlep.legal_entity_id
    AND xhp.party_id IN (
        SELECT
        zptp.party_id
        FROM
        zx_party_tax_profile  zptp, zx_report_codes_assoc rca, zx_reporting_codes_b  rcb, zx_reporting_types_b  rtb
        WHERE
        rtb.has_reporting_codes_flag = 'Y'
        AND TRUNC(sysdate) BETWEEN rtb.effective_from AND NVL(rtb.effective_to, TRUNC(sysdate))
        AND rtb.reporting_type_id = rcb.reporting_type_id
        AND TRUNC(sysdate) BETWEEN rcb.effective_from AND NVL(rcb.effective_to, TRUNC(sysdate))
        AND rcb.reporting_code_id = rca.reporting_code_id
        AND TRUNC(sysdate) BETWEEN rca.effective_from AND NVL(rca.effective_to, TRUNC(sysdate))
        AND rca.entity_id = zptp.party_tax_profile_id
        AND rca.entity_code = 'ZX_PARTY_TAX_PROFILE'
        AND rtb.reporting_type_code = 'LACLS_BR_HCM_PAYROLL_INTEG'
        AND rca.reporting_code_char_value IS NOT NULL
        )
    AND xlep.legal_entity_id = orgs.legal_entity_id
    AND xlep.geography_id = hg.geography_id
    AND hg.geography_type = 'COUNTRY'
    AND hg.country_code = 'BR'
    AND TRUNC(sysdate) BETWEEN TRUNC(orgs.effective_start_date) AND TRUNC(orgs.effective_end_date)
    AND EXISTS (
        SELECT
        furda.*
        FROM
        per_users                      pu,
        fun_user_role_data_asgnmnts    furda,
        fun_role_data_security_mapping frdsm
        WHERE
        1 = 1
        AND pu.active_flag = 'Y'
        AND pu.start_date <= sysdate
        AND NVL(pu.end_date, sysdate) >= sysdate
        AND pu.user_guid = furda.user_guid
        AND furda.role_name = 'LACLS_BR_HCM_BI_SEC'
        AND furda.active_flag = 'Y'
        AND furda.start_date_active <= sysdate
        AND NVL(furda.end_date_active, sysdate) >= sysdate
        AND furda.role_name = frdsm.role_name
        AND frdsm.object_name = 'XLE_ENTITY_PROFILES'
        AND furda.datasec_context_type_code = 'ORA_LEGAL_ENTITY_ID'
        AND furda.datasec_context_value1 = xlep.legal_entity_id
        )
    )
SELECT
xep.name                                     AS org_name,
REGEXP_REPLACE(xr.registration_number, '\D') AS org_registration_number,
hp.status                                    AS org_status,
(
    SELECT
    &eff_lru_code
    FROM
    hr_organization_information_f orgeff,
    hr_all_organization_units_f   haou
    WHERE
    haou.establishment_id = xep.establishment_id
    AND haou.organization_id = orgeff.organization_id
    AND orgeff.org_information_context = 'LACLS_BR_HCM_LRU_CODE'
    AND TRUNC(sysdate) BETWEEN haou.effective_start_date AND haou.effective_end_date
    AND TRUNC(sysdate) BETWEEN orgeff.effective_start_date AND orgeff.effective_end_date
    )                                            AS org_code,
DECODE((
  SELECT
  COUNT(org.establishment_id)
  FROM
  hr_org_unit_classifications_f orgclass, hr_all_organization_units_f   org
  WHERE
  org.organization_id = orgclass.organization_id
  AND orgclass.classification_code = 'HCM_REPORTING_ESTABLISHMENT'
  AND TRUNC(sysdate) BETWEEN orgclass.effective_start_date AND orgclass.effective_end_date
  AND TRUNC(sysdate) BETWEEN org.effective_start_date AND org.effective_end_date
  AND xep.establishment_id = org.establishment_id
  ), 0, 'N', 'Y') org_reporting_establishment
, (select xepl.name from xle_entity_profiles xepl where xepl.legal_entity_id = xep.legal_entity_id) org_le_name
FROM
xle_registrations xr,
xle_etb_profiles  xep,
xle_registrations xrle,
hz_parties        hp,
hz_geographies    hg
WHERE
xep.legal_entity_id = xrle.source_id
AND hp.party_id = xep.party_id
AND xep.establishment_id = xr.source_id
AND xr.source_table = 'XLE_ETB_PROFILES'
AND xep.main_establishment_flag = 'N'
AND xr.identifying_flag = 'Y'
AND xrle.source_table = 'XLE_ENTITY_PROFILES'
AND xrle.identifying_flag = 'Y'
AND xep.geography_id = hg.geography_id
AND hg.geography_type = 'COUNTRY'
AND hg.country_code = 'BR'
AND xep.legal_entity_id IN (
   SELECT
   le.legal_entity_id
   FROM
   legalentities le
   )
AND xr.jurisdiction_id IN (
   SELECT
   xjb.jurisdiction_id
   FROM
   xle_jurisdictions_b xjb
   WHERE
   xjb.registration_code_etb = 'CNPJ'
   )
AND TRUNC(sysdate) BETWEEN TRUNC(COALESCE(xep.effective_from, sysdate)) AND TRUNC(COALESCE(xep.effective_to, SYSDATE))
ORDER BY 6,
xep.name
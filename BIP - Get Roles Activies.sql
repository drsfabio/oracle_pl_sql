/** Query **/
SELECT
  gl.name " Security Context Value ",
  pr.ROLE_NAME " Job Role Name ",
  pu.username " User Name ",
  role.ACTIVE_FLAG " Is Data Access Active ",
  ' DATA ACCESS
SET
  ' " Security Context "
FROM
  fusion.FUN_USER_ROLE_DATA_ASGNMNTS role,
  fusion.gl_access_sets gl,
  fusion.per_users pu,
  fusion.per_roles_dn_vl pr
WHERE
  gl.ACCESS_SET_ID = role.ACCESS_SET_ID
  AND pu.USER_GUID = role.USER_GUID
  AND pr.ROLE_COMMON_NAME = role.ROLE_NAME
UNION
SELECT
  bu.bu_name " Security Context Value ",
  pr.ROLE_NAME " Job Role Name ",
  pu.username " User Name ",
  role.ACTIVE_FLAG " Is Data Access Active ",
  ' BUSINESS UNIT ' " Security Context "
FROM
  fusion.FUN_ALL_BUSINESS_UNITS_V bu,
  fusion.FUN_USER_ROLE_DATA_ASGNMNTS role,
  fusion.per_users pu,
  fusion.per_roles_dn_vl pr
WHERE
  role.org_id = bu.bu_id
  AND pu.USER_GUID = role.USER_GUID
  AND pr.ROLE_COMMON_NAME = role.ROLE_NAME
UNION
SELECT
  led.NAME " Security Context Value ",
  pr.role_name " Job Role Name ",
  pu.username " User Name ",
  role.ACTIVE_FLAG " Is Data Access Active ",
  ' LEDGERS ' " Security Context "
FROM
  fusion.GL_LEDGERS led,
  fusion.FUN_USER_ROLE_DATA_ASGNMNTS role,
  fusion.per_users pu,
  fusion.per_roles_dn_vl pr
WHERE
  role.LEDGER_ID = led.LEDGER_ID
  AND pu.USER_GUID = role.USER_GUID
  AND pr.ROLE_COMMON_NAME = role.ROLE_NAME
UNION
SELECT
  book.book_type_name " Security Context Value ",
  pr.ROLE_NAME " Job Role Name ",
  pu.username " User Name ",
  role.ACTIVE_FLAG " Is Data Access Active ",
  ' ASSET BOOK ' " Security Context "
FROM
  fusion.FUN_USER_ROLE_DATA_ASGNMNTS role,
  fusion.FA_BOOK_CONTROLS book,
  fusion.per_users pu,
  fusion.per_roles_dn_vl pr
WHERE
  book.BOOK_CONTROL_ID = role.book_id
  AND pu.USER_GUID = role.USER_GUID
  AND pr.ROLE_COMMON_NAME = role.ROLE_NAME
UNION
SELECT
  interco.INTERCO_ORG_NAME " Security Context Value ",
  pr.ROLE_NAME " Job Role Name ",
  pu.username " User Name ",
  role.ACTIVE_FLAG " Is Data Access Active ",
  ' INTERCOMPANY ORGANIZATION ' " Security Context "
FROM
  fusion.FUN_USER_ROLE_DATA_ASGNMNTS role,
  fusion.FUN_INTERCO_ORGANIZATIONS interco,
  fusion.per_users pu,
  fusion.per_roles_dn_vl pr
WHERE
  interco.INTERCO_ORG_ID = role.INTERCO_ORG_ID
  AND pu.USER_GUID = role.USER_GUID
  AND pr.ROLE_COMMON_NAME = role.ROLE_NAME
UNION
SELECT
  cost.COST_ORG_NAME " Security Context Value ",
  pr.ROLE_NAME " Job Role Name ",
  pu.username " User Name ",
  role.ACTIVE_FLAG " Is Data Access Active ",
  ' COST ORGANIZATION ' " Security Context "
FROM
  fusion.FUN_USER_ROLE_DATA_ASGNMNTS role,
  fusion.CST_COST_ORGS_V cost,
  fusion.per_users pu,
  fusion.per_roles_dn_vl pr
WHERE
  cost.COST_ORG_ID = role.CST_ORGANIZATION_ID
  AND pu.USER_GUID = role.USER_GUID
  AND pr.ROLE_COMMON_NAME = role.ROLE_NAME
UNION
SELECT
  mfg.DEF_SUPPLY_SUBINV " Security Context Value ",
  pr.ROLE_NAME " Job Role Name ",
  pu.username " User Name ",
  role.ACTIVE_FLAG " Is Data Access Active ",
  ' MANUFACTURING PLANT ' " Security Context "
FROM
  fusion.FUN_USER_ROLE_DATA_ASGNMNTS role,
  fusion.RCS_MFG_PARAMETERS mfg,
  fusion.per_users pu,
  fusion.per_roles_dn_vl pr
WHERE
  mfg.ORGANIZATION_ID = role.MFG_ORGANIZATION_ID
  AND pu.USER_GUID = role.USER_GUID
  AND pr.ROLE_COMMON_NAME = role.ROLE_NAME
UNION
SELECT
  budget.NAME " Security Context Value ",
  pr.ROLE_NAME " Job Role Name ",
  pu.username " User Name ",
  role.ACTIVE_FLAG " Is Data Access Active ",
  ' CONTROL BUDGET ' " Security Context "
FROM
  fusion.FUN_USER_ROLE_DATA_ASGNMNTS role,
  fusion.XCC_CONTROL_BUDGETS budget,
  fusion.per_users pu,
  fusion.per_roles_dn_vl pr
WHERE
  budget.CONTROL_BUDGET_ID = role.CONTROL_BUDGET_ID
  AND pu.USER_GUID = role.USER_GUID
  AND pr.ROLE_COMMON_NAME = role.ROLE_NAME
UNION
SELECT
  st.SET_NAME " Security Context Value ",
  pr.ROLE_NAME " Job Role Name ",
  pu.username " User Name ",
  role.ACTIVE_FLAG " Is Data Access Active ",
  ' REFERENCE DATA
SET
  ' " Security Context "
FROM
  fusion.FUN_USER_ROLE_DATA_ASGNMNTS role,
  fusion.FND_SETID_SETS_VL st,
  fusion.per_users pu,
  fusion.per_roles_dn_vl pr
WHERE
  st.SET_ID = role.SET_ID
  AND pu.USER_GUID = role.USER_GUID
  AND pr.ROLE_COMMON_NAME = role.ROLE_NAME
UNION
SELECT
  inv.ORGANIZATION_CODE " Security Context Value ",
  pr.ROLE_NAME " Job Role Name ",
  pu.username " User Name ",
  role.ACTIVE_FLAG " Is Data Access Active ",
  ' INVENTORY ORGANIZATION ' " Security Context "
FROM
  fusion.FUN_USER_ROLE_DATA_ASGNMNTS role,
  fusion.INV_ORG_PARAMETERS inv,
  fusion.per_users pu,
  fusion.per_roles_dn_vl pr
WHERE
  inv.ORGANIZATION_ID = role.INV_ORGANIZATION_ID
  AND pu.USER_GUID = role.USER_GUID
  AND pr.ROLE_COMMON_NAME = role.ROLE_NAME
UNION
SELECT
  hr.CLASSIFICATION_CODE " Security Context Value ",
  pr.ROLE_NAME " Job Role Name ",
  pu.username " User Name ",
  role.ACTIVE_FLAG " Is Data Access Active ",
  ' PROJECT ORGANIZATION CLASSIFICATION ' " Security Context "
FROM
  fusion.FUN_USER_ROLE_DATA_ASGNMNTS role,
  fusion.HR_ORG_UNIT_CLASSIFICATIONS_F hr,
  fusion.per_users pu,
  fusion.per_roles_dn_vl pr
WHERE
  hr.ORG_UNIT_CLASSIFICATION_ID = role.ORG_ID
  AND pu.USER_GUID = role.USER_GUID
  AND pr.ROLE_COMMON_NAME = role.ROLE_NAME
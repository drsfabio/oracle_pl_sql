SELECT
  r_code.*,
  "Role Code" || ' - ' || "Role Name" || ' - ' || "Job Role Name" || ' - ' || "Organization Security Profile" || ' - ' || "Position Security Profile" || ' - ' || "Country Security Profile" || ' - ' || "LDG Security Profile" || ' - ' || "Person Security Profile" || ' - ' || "Public Person Security Profile" || ' - ' || "Document Type Security Profile" || ' - ' || "Payroll Security Profile" || ' - ' || "Payroll Flow Security Profile" || ' - ' || "Person Security Profile" Concat_Val_Validation
from
  (
    SELECT
      gen.data_role_name "Role Code",(
        SELECT
          ASE_ROLE_VL.ROLE_NAME
        FROM
          FUSION.ASE_ROLE_VL ASE_ROLE_VL
        WHERE
          code = gen.data_role_name
          and rownum = 1
      ) "Role Name",(
        SELECT
          NVL(
            sec.name,
            'Missing Person Security Profile: ' || TO_CHAR(security_profile_id)
          )
        FROM
          fusion.per_gen_data_role_profiles gdrp_per,
          fusion.per_person_security_profiles sec
        WHERE
          gdrp_per.generated_data_role_id = gen.generated_data_role_id
          AND gdrp_per.hr_securing_object = 'PERSON'
          AND gdrp_per.security_profile_id = sec.person_security_profile_id(+)
      ) "Person Security Profile",(
        SELECT
          NVL(
            sec.name,
            'Missing Public Person Security Profile: ' || TO_CHAR(security_profile_id)
          )
        FROM
          fusion.per_gen_data_role_profiles gdrp_per,
          fusion.per_person_security_profiles sec
        WHERE
          gdrp_per.generated_data_role_id = gen.generated_data_role_id
          AND gdrp_per.hr_securing_object = 'PUBLIC_PERSON'
          AND gdrp_per.security_profile_id = sec.person_security_profile_id(+)
      ) "Public Person Security Profile",(
        SELECT
          NVL(
            sec.name,
            'Missing Organization Security Profile: ' || TO_CHAR(security_profile_id)
          )
        FROM
          fusion.per_gen_data_role_profiles gdrp_per,
          fusion.per_org_security_profiles sec
        WHERE
          gdrp_per.generated_data_role_id = gen.generated_data_role_id
          AND gdrp_per.hr_securing_object = 'ORGANIZATION'
          AND gdrp_per.security_profile_id = sec.org_security_profile_id(+)
      ) "Organization Security Profile",(
        SELECT
          NVL(
            sec.name,
            'Missing Position Security Profile: ' || TO_CHAR(security_profile_id)
          )
        FROM
          fusion.per_gen_data_role_profiles gdrp_per,
          fusion.per_position_security_profiles sec
        WHERE
          gdrp_per.generated_data_role_id = gen.generated_data_role_id
          AND gdrp_per.hr_securing_object = 'POSITION'
          AND gdrp_per.security_profile_id = sec.position_security_profile_id(+)
      ) "Position Security Profile",(
        SELECT
          NVL(
            sec.name,
            'Missing Country Security Profile: ' || TO_CHAR(security_profile_id)
          )
        FROM
          fusion.per_gen_data_role_profiles gdrp_per,
          fusion.per_country_security_profiles sec
        WHERE
          gdrp_per.generated_data_role_id = gen.generated_data_role_id
          AND gdrp_per.hr_securing_object = 'COUNTRY'
          AND gdrp_per.security_profile_id = sec.country_security_profile_id(+)
      ) "Country Security Profile",(
        SELECT
          NVL(
            sec.name,
            'Missing LDG Security Profile: ' || TO_CHAR(security_profile_id)
          )
        FROM
          fusion.per_gen_data_role_profiles gdrp_per,
          fusion.per_ldg_security_profiles sec
        WHERE
          gdrp_per.generated_data_role_id = gen.generated_data_role_id
          AND gdrp_per.hr_securing_object = 'LDG'
          AND gdrp_per.security_profile_id = sec.ldg_security_profile_id(+)
      ) "LDG Security Profile",(
        SELECT
          NVL(
            sec.name,
            'Missing Payroll Security Profile: ' || TO_CHAR(security_profile_id)
          )
        FROM
          fusion.per_gen_data_role_profiles gdrp_per,
          fusion.pay_pay_security_profiles sec
        WHERE
          gdrp_per.generated_data_role_id = gen.generated_data_role_id
          AND gdrp_per.hr_securing_object = 'PAYROLL'
          AND gdrp_per.security_profile_id = sec.pay_security_profile_id(+)
      ) "Payroll Security Profile",(
        SELECT
          NVL(
            sec.name,
            'Missing Payroll Flow Security Profile: ' || TO_CHAR(security_profile_id)
          )
        FROM
          fusion.per_gen_data_role_profiles gdrp_per,
          fusion.pay_flw_security_profiles sec
        WHERE
          gdrp_per.generated_data_role_id = gen.generated_data_role_id
          AND gdrp_per.hr_securing_object = 'FLOWPATTERN'
          AND gdrp_per.security_profile_id = sec.flw_security_profile_id(+)
      ) "Payroll Flow Security Profile",(
        SELECT
          NVL(
            sec.name,
            'Missing Doc Type Security Profile: ' || TO_CHAR(security_profile_id)
          )
        FROM
          fusion.per_gen_data_role_profiles gdrp_per,
          fusion.per_doc_type_security_profiles sec
        WHERE
          gdrp_per.generated_data_role_id = gen.generated_data_role_id
          AND gdrp_per.hr_securing_object = 'DOR'
          AND gdrp_per.security_profile_id = sec.doc_type_security_profile_id(+)
      ) "Document Type Security Profile",(
        SELECT
          role_name
        FROM
          per_roles_dn_tl job_role
        WHERE
          gen.base_role_id = job_role.role_id
          and job_role.language = 'US'
      ) "Job Role Name"
    FROM
      fusion.per_generated_data_roles gen
    WHERE
      gen.data_role_name IN (
        SELECT
          code
        FROM
          FUSION.ASE_ROLE_VL ASE_ROLE_VL
        WHERE
          1 = 1
          AND (
            ASE_ROLE_VL.ROLE_NAME IN (:ROLE_NAME_PARAM)
            OR 'All' IN (:ROLE_NAME_PARAM || 'All')
          )
      )
  ) r_code
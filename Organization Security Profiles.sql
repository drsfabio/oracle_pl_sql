SELECT
  gen.data_role_name "Role Name",
  (
    select
      NVL(
        sec.name,
        'Missing Person Security Profile: ' || TO_CHAR(security_profile_id)
      )
    from
      fusion.per_gen_data_role_profiles gdrp_per,
      fusion.per_person_security_profiles sec
    where
      gdrp_per.generated_data_role_id = gen.generated_data_role_id
      and gdrp_per.hr_securing_object = 'PERSON'
      and gdrp_per.security_profile_id = sec.person_security_profile_id(+)
  ) "Person Security Profile",
  (
    select
      NVL(
        sec.name,
        'Missing Public Person Security Profile: ' || TO_CHAR(security_profile_id)
      )
    from
      fusion.per_gen_data_role_profiles gdrp_per,
      fusion.per_person_security_profiles sec
    where
      gdrp_per.generated_data_role_id = gen.generated_data_role_id
      and gdrp_per.hr_securing_object = 'PUBLIC_PERSON'
      and gdrp_per.security_profile_id = sec.person_security_profile_id(+)
  ) "Public Person Security Profile",
  (
    select
      NVL(
        sec.name,
        'Missing Organization Security Profile: ' || TO_CHAR(security_profile_id)
      )
    from
      fusion.per_gen_data_role_profiles gdrp_per,
      fusion.per_org_security_profiles sec
    where
      gdrp_per.generated_data_role_id = gen.generated_data_role_id
      and gdrp_per.hr_securing_object = 'ORGANIZATION'
      and gdrp_per.security_profile_id = sec.org_security_profile_id(+)
  ) "Organization Security Profile",
  (
    select
      NVL(
        sec.name,
        'Missing Position Security Profile: ' || TO_CHAR(security_profile_id)
      )
    from
      fusion.per_gen_data_role_profiles gdrp_per,
      fusion.per_position_security_profiles sec
    where
      gdrp_per.generated_data_role_id = gen.generated_data_role_id
      and gdrp_per.hr_securing_object = 'POSITION'
      and gdrp_per.security_profile_id = sec.position_security_profile_id(+)
  ) "Position Security Profile",
  (
    select
      NVL(
        sec.name,
        'Missing Country Security Profile: ' || TO_CHAR(security_profile_id)
      )
    from
      fusion.per_gen_data_role_profiles gdrp_per,
      fusion.per_country_security_profiles sec
    where
      gdrp_per.generated_data_role_id = gen.generated_data_role_id
      and gdrp_per.hr_securing_object = 'COUNTRY'
      and gdrp_per.security_profile_id = sec.country_security_profile_id(+)
  ) "Country Security Profile",
  (
    select
      NVL(
        sec.name,
        'Missing LDG Security Profile: ' || TO_CHAR(security_profile_id)
      )
    from
      fusion.per_gen_data_role_profiles gdrp_per,
      fusion.per_ldg_security_profiles sec
    where
      gdrp_per.generated_data_role_id = gen.generated_data_role_id
      and gdrp_per.hr_securing_object = 'LDG'
      and gdrp_per.security_profile_id = sec.ldg_security_profile_id(+)
  ) "LDG Security Profile",
  (
    select
      NVL(
        sec.name,
        'Missing Payroll Security Profile: ' || TO_CHAR(security_profile_id)
      )
    from
      fusion.per_gen_data_role_profiles gdrp_per,
      fusion.pay_pay_security_profiles sec
    where
      gdrp_per.generated_data_role_id = gen.generated_data_role_id
      and gdrp_per.hr_securing_object = 'PAYROLL'
      and gdrp_per.security_profile_id = sec.pay_security_profile_id(+)
  ) "Payroll Security Profile",
  (
    select
      NVL(
        sec.name,
        'Missing Payroll Flow Security Profile: ' || TO_CHAR(security_profile_id)
      )
    from
      fusion.per_gen_data_role_profiles gdrp_per,
      fusion.pay_flw_security_profiles sec
    where
      gdrp_per.generated_data_role_id = gen.generated_data_role_id
      and gdrp_per.hr_securing_object = 'FLOWPATTERN'
      and gdrp_per.security_profile_id = sec.flw_security_profile_id(+)
  ) "Payroll Flow Security Profile",
  (
    select
      NVL(
        sec.name,
        'Missing Doc Type Security Profile: ' || TO_CHAR(security_profile_id)
      )
    from
      fusion.per_gen_data_role_profiles gdrp_per,
      fusion.per_doc_type_security_profiles sec
    where
      gdrp_per.generated_data_role_id = gen.generated_data_role_id
      and gdrp_per.hr_securing_object = 'DOR'
      and gdrp_per.security_profile_id = sec.doc_type_security_profile_id(+)
  ) "Document Type Security Profile"
FROM
  fusion.per_generated_data_roles gen
where 1 = 1
  --gen.data_role_name LIKE '%HR02%'
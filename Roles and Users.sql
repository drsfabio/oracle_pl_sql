SELECT DISTINCT
     priv.service Service,
     u.user_login Employee_ID,
     ppnf.first_name,
     ppnf.last_name,
     haou.name Department_Name,
     rtl.role_name Role_Name,
     fr.top_role_code Role_Code,
     rtl.description Role_Description,
     priv.name Privilege_Name,
     priv.code Privilege_Code,
     priv.description Privilege_Description
FROM
     FUSION.ase_user_role_mbr ur,
     FUSION.ase_role_tl rtl,
     FUSION.ase_user_b u,
     FUSION.per_users pu,
     (
          SELECT
               CONNECT_BY_ROOT parent_role_code top_role_code,
               CONNECT_BY_ROOT parent_role_id top_role_id,
               CONNECT_BY_ROOT parent_role_guid top_role_guid,
               child_role_code role_code,
               child_role_id role_id,
               child_role_guid role_guid
          FROM
               (
                    SELECT
                         pr.code parent_role_code,
                         pr.role_id parent_role_id,
                         pr.guid parent_role_guid,
                         cr.code child_role_code,
                         cr.role_id child_role_id,
                         cr.guid child_role_guid
                    FROM
                         FUSION.ase_role_b pr,
                         FUSION.ase_role_b cr,
                         FUSION.ase_role_role_mbr rr
                    WHERE
                         rr.effective_end_date IS NULL
                         AND cr.role_id = rr.parent_role_id
                         AND pr.role_id = rr.child_role_id
               ) role_hierarchy CONNECT BY NOCYCLE PRIOR child_role_id = parent_role_id
          UNION ALL
          SELECT
               r.code,
               r.role_id,
               r.guid,
               r.code,
               r.role_id,
               r.guid
          FROM
               FUSION.ase_role_b r
     ) fr,
     (
          SELECT
               privrole.role_id,
               priv.code,
               privtl.name,
               privtl.description,
               privrole.effective_start_date policy_start_date,
               privrole.effective_end_date policy_end_date,
               metric.metric_name service
          FROM
               FUSION.ase_priv_role_mbr privrole,
               FUSION.ase_privilege_b priv,
               FUSION.ase_privilege_tl privtl,
               (
                    SELECT
                         vl.translated_value metric_set_code,
                         vl.description metric_set_name
                    FROM
                         fnd_vs_value_sets vs,
                         fnd_vs_values_b v,
                         fnd_vs_values_tl vl
                    WHERE
                         vs.value_set_code = 'ORA_PER_METRICS_SETS'
                         AND v.value_set_id = vs.value_set_id
                         AND v.enabled_flag = 'Y'
                         AND SYSDATE BETWEEN nvl (v.start_date_active, SYSDATE) AND nvl  (v.end_date_active, SYSDATE)
                         AND vl.value_id = v.value_id
                         AND vl.language = 'US'
               ) metricset,
               (
                    SELECT
                         vs.value_set_code metric_set_code,
                         vl.translated_value metric_code,
                         vl.description metric_name
                    FROM
                         fnd_vs_value_sets vs,
                         fnd_vs_values_b v,
                         fnd_vs_values_tl vl
                    WHERE
                         v.value_set_id = vs.value_set_id
                         AND v.enabled_flag = 'Y'
                         AND v.flex_value_attribute17 IS NULL
                         AND SYSDATE BETWEEN nvl (v.start_date_active, SYSDATE) AND nvl  (v.end_date_active, SYSDATE)
                         AND vl.value_id = v.value_id
                         AND vl.language = 'US'
               ) metric,
               (
                    SELECT
                         vs.value_set_code metric_code,
                         vl.translated_value priv_code
                    FROM
                         fnd_vs_value_sets vs,
                         fnd_vs_values_b v,
                         fnd_vs_values_tl vl
                    WHERE
                         v.value_set_id = vs.value_set_id
                         AND v.enabled_flag = 'Y'
                         AND SYSDATE BETWEEN nvl (v.start_date_active, SYSDATE) AND nvl  (v.end_date_active, SYSDATE)
                         AND vl.value_id = v.value_id
                         AND vl.language = 'US'
               ) metricpriv
          WHERE
               priv.privilege_id = privrole.privilege_id
               AND priv.privilege_id = privtl.privilege_id
               AND privtl.Language = 'US'
               AND metric.metric_set_code = metricset.metric_set_code
               AND metricpriv.metric_code = metric.metric_code
               AND priv.code = metricpriv.priv_code
     ) priv,
     per_all_people_f papf,
     per_person_names_f ppnf,
     per_assignments_f paf,
     hr_all_organization_units haou
WHERE
     ur.user_id = u.user_id
     AND rtl.role_id = ur.role_id
     AND rtl.language = 'US'
     AND fr.top_role_id = ur.role_id
     AND priv.role_id = fr.role_id
     AND NVL (ur.effective_end_date, SYSDATE) >= SYSDATE
     AND priv.policy_start_date <= NVL (ur.effective_end_date, SYSDATE)
     AND NVL (priv.policy_end_date, SYSDATE) >= SYSDATE
     AND u.user_guid = pu.user_guid
     AND (
          pu.suspended IS NULL
          OR pu.suspended = 'N'
     )
     AND u.user_login NOT IN (
          'orcladmin',
          'weblogic_read_only',
          'xelsysadm',
          'oamSoftwareUser',
          'IDROUser',
          'PolicyROUser',
          'PolicyRWUser',
          'oimAdminUser',
          'IDMPolicyROUser',
          'IDMPolicyRWUser',
          'faoperator',
          'saas_readonly',
          'em_monitoring',
          'oamAdminUser',
          'weblogic_idm',
          'IDRWUser',
          'PUBLIC',
          'FAAdmin',
          'weblogic',
          'XELOPERATOR',
          'OblixAnonymous',
          'OCLOUD9_osn_APPID'
     )
     AND papf.person_number = u.user_login
     AND papf.person_id = ppnf.person_id
     AND papf.person_id = paf.person_id
     AND sysdate BETWEEN paf.effective_start_date AND paf.effective_end_date
     AND sysdate BETWEEN ppnf.effective_start_date AND ppnf.effective_end_date
     AND paf.organization_id = haou.organization_id
     AND paf.assignment_status_type = 'ACTIVE'
     AND paf.primary_flag = 'Y'
     AND paf.work_terms_assignment_id IS NOT NULL
     AND u.user_login NOT LIKE 'FUSION_APPS_%_APPID'
ORDER BY
     service,
     department_name,
     last_name,
     first_name
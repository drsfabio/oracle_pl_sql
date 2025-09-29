SELECT pu.username "User Name",
         ppnf.full_name "Employee Name",
         prd.abstract_role "Absteact Role Name",
         prd.job_role "Job Role Name",
         prd.data_role "User Data Role",
         prd.duty_role "Duty Role",
         prd.active_flag,
         prdt.role_name,
         prd.role_common_name,
         prdt.description,
         TO_CHAR (pur.start_date, 'DD-MON-YYYY') user_role_start_date,
         TO_CHAR (pur.end_date, 'DD-MON-YYYY') user_role_end_date
    FROM 
         per_roles_dn_tl   prdt,
         per_roles_dn      prd,
         per_person_names_f ppnf,
         per_user_roles    pur,
         per_users         pu
   WHERE     1 = 1
         AND pu.user_id = pur.user_id
         AND prdt.role_id = pur.role_id
         AND NVL (pu.suspended, 'N') = 'N'
         AND ppnf.person_id = pu.person_id
         AND ppnf.name_type = 'GLOBAL'
         AND TRUNC(SYSDATE) BETWEEN ppnf.EFFECTIVE_START_DATE AND ppnf.EFFECTIVE_END_DATE
         AND NVL (pu.start_date, SYSDATE) <= SYSDATE
         AND NVL (pu.end_date, SYSDATE) >= SYSDATE
         AND pu.active_flag = 'Y'
         AND prdt.language = USERENV ('lang')
         AND prdt.role_id = prd.role_id
         --AND pu.username =:p_user_name
ORDER BY 1,2
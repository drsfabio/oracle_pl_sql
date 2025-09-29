SELECT pu.username "User Name",
         ppnf.full_name "Employee Name",
         paam.person_id,
         paam.assignment_number,
         sttl.user_status,
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
         per_users         pu,
         per_all_assignments_m paam,
         per_assignment_status_types_tl sttl
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
         AND paam.person_id = pu.person_id
         AND paam.assignment_type = 'E'
         AND trunc(sysdate) between paam.effective_start_date and paam.effective_end_date
         AND sttl.assignment_status_type_id = paam.assignment_status_type_id AND sttl.language = userenv('lang')
         AND sttl.assignment_status_type_id = 1 -- 'Ativo - Elegí­vel para folha de pagamento'
         AND prd.role_common_name NOT IN ('GRM_COLABORADOR_ABST','GRM_PENDING_WORKER_ABSTRACT_CUSTOM')
         --AND paam.assignment_number = '0041949'
ORDER BY 1,2
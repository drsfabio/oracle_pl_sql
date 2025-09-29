WITH    assign_param AS
        (
        SELECT  sysdate extraction_date
        FROM    dual
        )
      , bank_accounts AS
        (
        SELECT  ppr.payroll_relationship_id
              , psm.name
              , acd.bank_id
              , acd.bank_name
              , acd.bank_number
              , acd.bank_code
              , acd.branch_id
              , acd.branch_number
              , acd.bank_branch_name
              , acd.bank_account_num
              , acd.check_digits
              , ppr.person_id
              , psm.last_update_date
        FROM    pay_bank_accounts acd
                INNER JOIN assign_param asp
                ON      (
                                1 = 1
                        )

                LEFT OUTER JOIN pay_person_pay_methods_f psm
                ON      (
                                psm.bank_account_id = acd.bank_account_id
                        AND     asp.extraction_date
                                BETWEEN psm.effective_start_date
                                AND     psm.effective_end_date
                        )

                LEFT OUTER JOIN pay_pay_relationships_dn ppr
                ON      (
                                ppr.payroll_relationship_id = psm.payroll_relationship_id
                        AND     asp.extraction_date
                                BETWEEN ppr.start_date
                                AND     ppr.end_date
                        )
        WHERE   1 = 1
        )
      , manager_lov AS
        (
        SELECT  DISTINCT
                posm.position_id
              , posm.position_code
              , spa.manager_assignment_id
              , spa.assignment_id
              , spa.last_update_date
        FROM    per_assignment_supervisors_f spa
                INNER JOIN assign_param asp
                ON      (
                                1 = 1
                        )

                INNER JOIN per_all_assignments_m asgm
                ON      (
                                asgm.assignment_id = spa.manager_assignment_id
                        AND     asgm.assignment_type = 'E'
                        AND     asgm.assignment_status_type = 'ACTIVE'
                        AND     asgm.effective_latest_change = 'Y'
                        AND     to_char (asgm.effective_end_date, 'YYYY-MM-DD') = '4712-12-31'
                        )

                INNER JOIN hr_all_positions_f_vl posm
                ON      (
                                posm.position_id = asgm.position_id
                        AND     asp.extraction_date
                                BETWEEN posm.effective_start_date
                                AND     posm.effective_end_date
                        )
        WHERE   1 = 1
        AND     asp.extraction_date
                BETWEEN spa.effective_start_date
                AND     spa.effective_end_date
        )
SELECT  *
FROM    (
        SELECT  DISTINCT
                '' rh01_id
              , peo.person_number rh01_person_number
              , nam.full_name rh01_desc
              , CASE
                WHEN    asg.assignment_type = 'E'
                        THEN    substr (asg.assignment_number, 4
                                      , 50)
                ELSE    NULL
                END rh01_matricula
              , asg.assignment_number rh01_matricula_completa
              , cpf.national_identifier_number rh01_cpf
              , pis.national_identifier_number rh01_nis
              , CASE
                WHEN    ent.start_date IS NOT NULL
                        THEN    ent.absence_type_id
                WHEN    sev.actual_termination_date IS NOT NULL
                        THEN    7
                ELSE    1
                END rh01_situacao
              , lep.organization_id rh01_id_empresa
              , etp.attribute1 rh01_cod_empresa
              , lep.name rh01_empresa
              , ra.registration_number rh01_cnpj_empresa
              , est.organization_id rh01_id_filial
              , rif.org_information1 rh01_cod_filial
              , est.name rh01_filial
              , re.registration_number rh01_cnpj_filial
              , job.job_id rh01_id_cargo
              , job.job_code rh01_codigo_cargo
              , jot.name rh01_cargo
              , seo.organization_id rh01_id_setor
              , seo.internal_address_line rh01_codigo_setor
              , seo.name rh01_setor
              , CASE
                WHEN    asg.assignment_type = 'P'
                        THEN    asg.projected_start_date
                ELSE    sev.date_start
                END rh01_dt_admissao
              , bka.payroll_relationship_id rh01_id_relacionamento_folha
              , bka.name rh01_desc_met_pagamento
              , bka.bank_id rh01_id_banco
              , bka.bank_name rh01_nome_banco
              , bka.bank_number rh01_numero_banco
              , bka.bank_code rh01_cod_banco
              , bka.branch_id rh01_id_agencia
              , bka.branch_number rh01_numero_agencia
              , bka.bank_branch_name rh01_nome_agencia
              , NULL rh01_digito_agencia
              , NULL rh01_id_conta
              , bka.bank_account_num rh01_numero_conta
              , bka.check_digits rh01_digito_conta
              , ent.per_absence_entry_id rh01_id_afastamento
              , ent.absence_type_id rh01_id_tipo_afastamento
              , ent.start_date rh01_dt_afastamento
              , '' rh01_id_turno_padrao
              , '' rh01_id_jornada
              , pso.date_of_birth rh01_dt_nascimento
              , CASE
                WHEN    sev.actual_termination_date IS NOT NULL
                        THEN    '0'
                ELSE    '1'
                END rh01_ativo
              , sev.actual_termination_date rh01_data_demissao
              , asg.termination_date rh01_asg_data_demissao
              , '' rh01_causa_demissao
              , pel.sex rh01_tipo_sexo
              , '' rh01_id_estabilidade
              , CASE
                WHEN    dis.category IS NOT NULL
                        THEN    '1'
                ELSE    '0'
                END rh01_deficiente
              , pel.per_information1 rh01_numero_carteira
              , pel.per_information2 rh01_serie_carteira
              , NULL rh01_digito_carteira
              , pel.per_information_date1 rh01_dt_expedicao_carteira
              , pel.attribute_date1 rh01_dt_vencimento_carteira
              , geo.geography_name rh01_uf_carteira
              , rg.national_identifier_number rh01_rg
              , rg.place_of_issue rh01_orgao_expedidor
              , rg.issue_date rh01_dt_expedicao_rg
              , geor.geography_name rh01_estado_expedidor
              , peo.creation_date rh01_dt_importacao
              , pos.attribute2 rh01_cod_categoria
              , nvl (aei.aei_information_number2, asg.assignment_number) rh01_mateso
              , nam.known_as rh01_nome_social
              , nam2.full_name rh01_desc_nome_mae
              , asg.last_update_date rh01_data_alteracao_cargo
              , asg.last_update_date rh01_data_alteracao_setor
              , asg.last_update_date rh01_dt_alteracao_filial
              , peo.person_id rh01_id_pessoa
              , pos.position_id rh01_id_posicao
              , pos.position_code rh01_codigo_posicao
              , pos.name rh01_nome_posicao
              , mlo.position_id rh01_id_posicao_superior
              , mlo.position_code rh01_codigo_posicao_superior
              , ett.attribute1 rh01_cod_ausencia
              , ent.absence_type_id rh01_id_ausencia
              , etl.name rh01_desc_ausencia
              , usf.start_date rh01_user_data_inicio
              , usf.user_guid rh01_user_guid
              , usf.end_date rh01_user_data_fim
              , usf.active_flag rh01_user_ativo
              , asg.assignment_id asg_assignment_id
              , asg.action_code asg_action_code
              , asg.effective_start_date asg_effective_start_date
              , asg.effective_end_date asg_effective_end_date
              , asg.last_update_date asg_last_update_dade
              , asg.person_id asg_person_id
              , asg.assignment_number asg_assignment_number
              , peo.last_update_date peo_last_update_date
              , pso.last_update_date pso_last_update_date
              , nam.last_update_date nam_last_update_date
              , pel.last_update_date pel_last_update_date
              , cpf.last_update_date cpf_last_update_date
              , rg.last_update_date rg_last_update_date
              , pos.last_update_date pos_last_update_date
              , sev.last_update_date sev_last_update_date
              , dis.last_update_date dis_last_update_date
              , pis.last_update_date pis_last_update_date
              , aei.last_update_date aei_last_update_date
              , ent.last_update_date ent_last_update_date
              , lep.last_update_date lep_last_update_date
              , est.last_update_date est_last_update_date
              , seo.last_update_date seo_last_update_date
              , job.last_update_date job_last_update_date
              , jot.last_update_date jot_last_update_date
              , greatest (asg.last_update_date, peo.last_update_date
                        , pso.last_update_date, nvl (nam.last_update_date, asg.last_update_date)
                        , nvl (pel.last_update_date, asg.last_update_date), nvl (cpf.last_update_date, asg.last_update_date)
                        , nvl (rg.last_update_date, asg.last_update_date), nvl (sev.last_update_date, asg.last_update_date)
                        , nvl (dis.last_update_date, asg.last_update_date), nvl (pis.last_update_date, asg.last_update_date)
                        , nvl (aei.last_update_date, asg.last_update_date), nvl (ent.last_update_date, asg.last_update_date)
                        , nvl (bka.last_update_date, asg.last_update_date), nvl (mlo.last_update_date, asg.last_update_date)) rh01_dt_alteracao
        FROM    per_all_assignments_m asg
                INNER JOIN assign_param asp
                ON      (
                                1 = 1
                        )

                INNER JOIN per_all_people_f peo
                ON      (
                                peo.person_id = asg.person_id
                        AND     asg.effective_end_date
                                BETWEEN peo.effective_start_date
                                AND     peo.effective_end_date
                        )

                INNER JOIN per_persons pso
                ON      (
                                pso.person_id = asg.person_id
                        )

                INNER JOIN per_person_names_f nam
                ON      (
                                nam.person_id = asg.person_id
                        AND     nam.name_type = 'BR'
                        AND     asg.effective_end_date
                                BETWEEN nam.effective_start_date
                                AND     nam.effective_end_date
                        )

                LEFT OUTER JOIN per_contact_relships_f rel
                ON      (
                                rel.person_id = asg.person_id
                        AND     rel.contact_type IN ('1', 'IN_MR')
                        AND     asg.effective_end_date
                                BETWEEN rel.effective_start_date
                                AND     rel.effective_end_date
                        )

                LEFT OUTER JOIN per_person_names_f nam2
                ON      (
                                nam2.person_id = rel.contact_person_id
                        AND     nam2.name_type = 'BR'
                        AND     asg.effective_end_date
                                BETWEEN nam2.effective_start_date
                                AND     nam2.effective_end_date
                        )

                INNER JOIN per_people_legislative_f pel
                ON      (
                                pel.person_id = asg.person_id
                        AND     asg.effective_end_date
                                BETWEEN pel.effective_start_date
                                AND     pel.effective_end_date
                        )

                LEFT OUTER JOIN hz_geographies geo
                ON      (
                                geo.geography_id = pel.per_information_number1
                        AND     geo.geography_element1 = 'Brazil'
                        AND     asg.effective_end_date
                                BETWEEN geo.start_date
                                AND     geo.end_date
                        )

                INNER JOIN per_national_identifiers cpf
                ON      (
                                cpf.person_id = asg.person_id
                        AND     cpf.national_identifier_type = 'CPF'
                        )

                LEFT OUTER JOIN per_national_identifiers rg
                ON      (
                                rg.person_id = asg.person_id
                        AND     rg.national_identifier_type = 'RG'
                        )

                LEFT OUTER JOIN hz_geographies geor
                ON      (
                                geor.geography_code = rg.attribute1
                        AND     geor.geography_element1 = 'Brazil'
                        AND     asg.effective_end_date
                                BETWEEN geor.start_date
                                AND     geor.end_date
                        )

                LEFT OUTER JOIN per_national_identifiers pis
                ON      (
                                pis.person_id = asg.person_id
                        AND     pis.national_identifier_type = 'PIS'
                        )

                INNER JOIN hr_organization_v lep
                ON      (
                                lep.organization_id = asg.legal_entity_id
                        AND     lep.status = 'A'
                        AND     lep.classification_code = 'HCM_LEMP'
                        AND     asg.effective_end_date
                                BETWEEN lep.effective_start_date
                                AND     lep.effective_end_date
                        )

                INNER JOIN xle_entity_profiles etp
                ON      (
                                etp.legal_entity_id = lep.legal_entity_id
                        AND     asg.effective_end_date
                                BETWEEN nvl (etp.effective_from, to_date ('1951-01-01', 'YYYY-MM-DD'))
                                AND     nvl (etp.effective_to, to_date ('4712-12-31', 'YYYY-MM-DD'))
                        )

                INNER JOIN xle_registrations_v ra
                ON      (
                                ra.legal_entity_id = lep.legal_entity_id
                        AND     asg.effective_end_date
                                BETWEEN nvl (ra.effective_from, to_date ('1951-01-01', 'YYYY-MM-DD'))
                                AND     nvl (ra.effective_to, to_date ('4712-12-31', 'YYYY-MM-DD'))
                        )

                LEFT OUTER JOIN xle_registrations_v re
                ON      (
                                re.registration_number = asg.ass_attribute19
                        AND     re.legal_entity_id IS NULL
                        AND     asg.effective_end_date
                                BETWEEN nvl (re.effective_from, to_date ('1951-01-01', 'YYYY-MM-DD'))
                                AND     nvl (re.effective_to, to_date ('4712-12-31', 'YYYY-MM-DD'))
                        )

                LEFT OUTER JOIN hr_organization_v est
                ON      (
                                est.establishment_id = re.establishment_id
                        AND     est.status = 'A'
                        AND     est.classification_code = 'HCM_REPORTING_ESTABLISHMENT'
                        AND     asg.effective_end_date
                                BETWEEN est.effective_start_date
                                AND     est.effective_end_date
                        )

                LEFT OUTER JOIN hr_organization_information_f rif
                ON      (
                                rif.org_information_context IN ('LACLS_BR_HCM_LRU_CODE', 'GM_EFF_ORG_FILIAL_DL')
                        AND     rif.organization_id = est.organization_id
                        AND     asg.effective_end_date
                                BETWEEN rif.effective_start_date
                                AND     rif.effective_end_date
                        )

                LEFT OUTER JOIN hr_organization_v seo
                ON      (
                                seo.organization_id = asg.organization_id
                        AND     seo.status = 'A'
                        AND     seo.classification_code = 'DEPARTMENT'
                        AND     asg.effective_end_date
                                BETWEEN seo.effective_start_date
                                AND     seo.effective_end_date
                        )

                LEFT OUTER JOIN per_jobs_f job
                ON      (
                                job.job_id = asg.job_id
                        AND     asg.effective_end_date
                                BETWEEN job.effective_start_date
                                AND     job.effective_end_date
                        )

                LEFT OUTER JOIN per_jobs_f_tl jot
                ON      (
                                jot.job_id = asg.job_id
                        AND     jot.language = 'PTB'
                        AND     asg.effective_end_date
                                BETWEEN jot.effective_start_date
                                AND     jot.effective_end_date
                        )

                LEFT OUTER JOIN hr_all_positions_f_vl pos
                ON      (
                                pos.position_id = asg.position_id
                        AND     asg.effective_end_date
                                BETWEEN pos.effective_start_date
                                AND     pos.effective_end_date
                        )

                LEFT OUTER JOIN per_assignment_extra_info_m aei
                ON      (
                                aei.assignment_id = asg.assignment_id
                        AND     aei.information_type = 'LACLS_BR_HCM_ADD_PERSONS'
                        AND     asg.effective_end_date
                                BETWEEN aei.effective_start_date
                                AND     aei.effective_end_date
                        )

                LEFT OUTER JOIN manager_lov mlo
                ON      (
                                mlo.assignment_id = asg.assignment_id
                        )

                INNER JOIN per_periods_of_service sev
                ON      (
                                sev.period_of_service_id = asg.period_of_service_id
                        )

                LEFT OUTER JOIN per_disabilities_f dis
                ON      (
                                dis.person_id = asg.person_id
                        AND     asg.effective_end_date
                                BETWEEN dis.effective_start_date
                                AND     dis.effective_end_date
                        AND     dis.effective_start_date = 
                                                           (
                                                           SELECT  max (dis2.effective_start_date)
                                                           FROM    per_disabilities_f dis2
                                                           WHERE   dis.person_id = dis2.person_id
                                                           AND     dis2.effective_start_date <= asg.effective_end_date
                                                           )
                        )

                LEFT OUTER JOIN bank_accounts bka
                ON      (
                                bka.person_id = asg.person_id
                        )

                LEFT OUTER JOIN anc_per_abs_entries ent
                ON      (
                                ent.person_id = asg.person_id
                        AND     ent.approval_status_cd = 'APPROVED'
                        AND     (
                                        (
                                                trunc (asp.extraction_date)
                                                BETWEEN trunc (ent.start_date)
                                                AND     trunc (nvl (ent.end_date, to_date ('4712-12-31', 'YYYY-MM-DD')))
                                        )
                                OR      (
                                                (
                                                        trunc (asp.extraction_date)
                                                        BETWEEN trunc (ent.start_date)
                                                        AND     trunc (nvl (ent.end_date, to_date ('4712-12-31', 'YYYY-MM-DD')))
                                                )
                                        AND     (
                                                        ent.last_update_date > asp.extraction_date
                                                )
                                        )
                                )
                        )

                LEFT OUTER JOIN anc_absence_types_f ett
                ON      (
                                ett.absence_type_id = ent.absence_type_id
                        AND     ett.legislation_code = 'BR'
                        AND     asg.effective_end_date
                                BETWEEN ett.effective_start_date
                                AND     ett.effective_end_date
                        )

                LEFT OUTER JOIN anc_absence_types_f_tl etl
                ON      (
                                etl.absence_type_id = ent.absence_type_id
                        AND     etl.language = 'PTB'
                        AND     asg.effective_end_date
                                BETWEEN etl.effective_start_date
                                AND     etl.effective_end_date
                        )

                LEFT OUTER JOIN per_users usf
                ON      (
                                usf.person_id = asg.person_id
                        )
        WHERE   1 = 1
        AND     asg.assignment_status_type = 'ACTIVE'
        AND     asg.effective_latest_change = 'Y'
        AND     asg.assignment_type = 'E'
        AND     sysdate
                BETWEEN asg.effective_start_date
                AND     asg.effective_end_date
        AND     REGEXP_LIKE (asg.assignment_number, '^[0-9]+$') 
        )
ORDER BY rh01_dt_alteracao ASC;
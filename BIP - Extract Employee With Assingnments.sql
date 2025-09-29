SELECT  allassignments.effective_start_date
      , allpeople.person_number
      , allassignments.assignment_number
      , regexp_replace (identifiers.national_identifier_number, '\W') national_identifier
      , personnames.full_name
      , allpositionparent.position_id
      , allpositions.position_code
      , allpositions.name position_name
      , positionhierarchy.parent_position_id
      , allpositionparent.position_code position_parent_code
      , allpositionparent.name position_parent_name
      , organization_legal.organization_id
      , entity_profiles.attribute1 codigo_empresa
      , organization_legal.name organization_legal_name
      , establishment.organization_id organization_establishment_id
      , information.org_information1 establishment_code
      , establishment.name establishment_name
      , reporting.registration_number registration_number
      , department.internal_address_line
      , department.name department_name
      , job.job_code
      , jot.name job_name
      , users.username
      , users.user_guid
FROM    per_all_assignments_m allassignments
        LEFT OUTER JOIN per_person_names_f personnames
        ON      (
                        personnames.person_id = allassignments.person_id
                AND     personnames.name_type = 'BR'
                AND     allassignments.effective_end_date
                        BETWEEN personnames.effective_start_date
                        AND     personnames.effective_end_date
                )

        LEFT OUTER JOIN per_all_people_f allpeople
        ON      (
                        allpeople.person_id = allassignments.person_id
                AND     allassignments.effective_end_date
                        BETWEEN allpeople.effective_start_date
                        AND     allpeople.effective_end_date
                )

        LEFT OUTER JOIN hr_all_positions allpositions
        ON      (
                        allpositions.position_id = allassignments.position_id
                AND     allassignments.effective_end_date
                        BETWEEN allpositions.effective_start_date
                        AND     allpositions.effective_end_date
                )

        LEFT OUTER JOIN per_position_hierarchy_f positionhierarchy
        ON      (
                        positionhierarchy.position_id = allpositions.position_id
                AND     allassignments.effective_end_date
                        BETWEEN positionhierarchy.effective_start_date
                        AND     positionhierarchy.effective_end_date
                )

        LEFT OUTER JOIN hr_all_positions allpositionparent
        ON      (
                        allpositionparent.position_id = positionhierarchy.parent_position_id
                )
        AND     (
                        allassignments.effective_end_date
                        BETWEEN allpositionparent.effective_start_date
                        AND     allpositionparent.effective_end_date
                )

        LEFT OUTER JOIN per_national_identifiers identifiers
        ON      (
                        identifiers.person_id = allassignments.person_id
                AND     identifiers.national_identifier_type = 'CPF'
                )

        LEFT OUTER JOIN hr_organization_v department
        ON      (
                        department.organization_id = allassignments.organization_id
                AND     department.status = 'A'
                AND     department.classification_code = 'DEPARTMENT'
                AND     allassignments.effective_end_date
                        BETWEEN department.effective_start_date
                        AND     department.effective_end_date
                )

        LEFT OUTER JOIN per_jobs_f job
        ON      (
                        job.job_id = allassignments.job_id
                AND     allassignments.effective_end_date
                        BETWEEN job.effective_start_date
                        AND     job.effective_end_date
                )

        LEFT OUTER JOIN per_jobs_f_tl jot
        ON      (
                        jot.job_id = allassignments.job_id
                AND     jot.language = 'PTB'
                AND     allassignments.effective_end_date
                        BETWEEN jot.effective_start_date
                        AND     jot.effective_end_date
                )

        LEFT OUTER JOIN hr_organization_v organization_legal
        ON      (
                        organization_legal.organization_id = allassignments.legal_entity_id
                AND     organization_legal.status = 'A'
                AND     organization_legal.classification_code = 'HCM_LEMP'
                AND     allassignments.effective_end_date
                        BETWEEN organization_legal.effective_start_date
                        AND     organization_legal.effective_end_date
                )

        LEFT OUTER JOIN xle_entity_profiles entity_profiles
        ON      (
                        entity_profiles.legal_entity_id = organization_legal.legal_entity_id
                AND     allassignments.effective_end_date
                        BETWEEN nvl (entity_profiles.effective_from, to_date ('1951-01-01', 'YYYY-MM-DD'))
                        AND     nvl (entity_profiles.effective_to, to_date ('4712-12-31', 'YYYY-MM-DD'))
                )

        LEFT OUTER JOIN xle_registrations_v reporting
        ON      (
                        reporting.registration_number = allassignments.ass_attribute19
                AND     reporting.legal_entity_id IS NULL
                AND     allassignments.effective_end_date
                        BETWEEN nvl (reporting.effective_from, to_date ('1951-01-01', 'YYYY-MM-DD'))
                        AND     nvl (reporting.effective_to, to_date ('4712-12-31', 'YYYY-MM-DD'))
                )

        LEFT OUTER JOIN hr_organization_v establishment
        ON      (
                        establishment.establishment_id = reporting.establishment_id
                AND     establishment.status = 'A'
                AND     establishment.classification_code = 'HCM_REPORTING_ESTABLISHMENT'
                AND     allassignments.effective_end_date
                        BETWEEN establishment.effective_start_date
                        AND     establishment.effective_end_date
                )

        LEFT OUTER JOIN hr_organization_information_f information
        ON      (
                        information.org_information_context IN ('LACLS_BR_HCM_LRU_CODE', 'GM_EFF_ORG_FILIAL_DL')
                AND     information.organization_id = establishment.organization_id
                AND     allassignments.effective_end_date
                        BETWEEN information.effective_start_date
                        AND     information.effective_end_date
                )

        LEFT OUTER JOIN per_users users
        ON      (
                        users.person_id = allassignments.person_id
                )
WHERE   (
                allassignments.assignment_type = 'E'
        --AND     allassignments.assignment_status_type = 'ACTIVE'
        AND     allassignments.effective_latest_change = 'Y'
        AND     TRUNC(SYSDATE)
                BETWEEN allassignments.effective_start_date
                AND     allassignments.effective_end_date
        AND     allpeople.person_number = 44389
        )
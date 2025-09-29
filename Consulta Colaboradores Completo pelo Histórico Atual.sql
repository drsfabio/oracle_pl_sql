SELECT
peo.person_number,
paam.assignment_number,
nam.full_name,
paam.action_code,
paam.reason_code,
pastt.user_status assignment_status,
    CASE
        WHEN paam.assignment_type = upper('p')
        THEN paam.projected_start_date
    ELSE sev.date_start
END AS data_admissao,
paam.primary_assignment_flag,
sev.period_of_service_id,
paam.effective_start_date,
paam.effective_end_date,
est.organization_id id_filial,
rif.org_information1 codigo_filial,
est.name AS filial,
seo.organization_id AS id_setor,
seo.internal_address_line AS codigo_setor,
seo.name AS setor,
flv.flex_value id_centro_custo,
ffv.description centro_custo,
job.job_id AS id_cargo,
job.job_code AS codigo_cargo,
jot.name AS cargo,
sid.internal_address_line AS codigo_sindicato,
sid.name AS sindicato
FROM
per_all_assignments_m paam
LEFT JOIN per_all_people_f peo
ON(
    peo.person_id = paam.person_id
            and paam.effective_end_date between peo.effective_start_date
            and peo.effective_end_date
    )
LEFT JOIN per_persons pso
ON(
    pso.person_id = paam.person_id)
LEFT JOIN per_person_names_f nam
ON(
    nam.person_id = paam.person_id
            and nam.name_type = upper(
        'br')
            and paam.effective_end_date between nam.effective_start_date
            and nam.effective_end_date
    )
LEFT JOIN per_periods_of_service sev
ON(
    sev.period_of_service_id = paam.period_of_service_id
    )
LEFT JOIN per_assignment_status_types past
ON paam.assignment_status_type_id = past.assignment_status_type_id
        and trunc(
    sysdate)
between past.start_date
        and nvl(
    past.end_date,sysdate)
LEFT JOIN per_assignment_status_types_tl pastt
ON past.assignment_status_type_id = pastt.assignment_status_type_id
        and pastt.source_lang = upper(
    'us')
LEFT JOIN xle_registrations_v re
ON(
    re.registration_number = paam.ass_attribute19
            and re.legal_entity_id IS NULL
            and paam.effective_end_date between nvl(
        re.effective_from,
        to_date(
            '1951-01-01','yyyy-mm-dd')
        )
            and nvl(
        re.effective_to,
        to_date(
            '4712-12-31','yyyy-mm-dd')
        )
    )
LEFT JOIN hr_organization_v est
ON(
    est.establishment_id = re.establishment_id
            and est.status = upper(
        'a')
            and est.classification_code = upper(
        'hcm_reporting_establishment')
            and paam.effective_end_date between est.effective_start_date
            and est.effective_end_date
    )
LEFT JOIN hr_organization_information_f rif
ON(
    rif.org_information_context = upper(
        'lacls_br_hcm_lru_code')
            and rif.organization_id = est.organization_id
            and paam.effective_end_date between rif.effective_start_date
            and rif.effective_end_date
    )
LEFT JOIN hr_organization_v seo
ON(
    seo.organization_id = paam.organization_id
            and seo.status = upper(
        'a')
            and seo.classification_code = upper(
        'department')
            and paam.effective_end_date between seo.effective_start_date
            and seo.effective_end_date
    )
LEFT JOIN per_jobs_f job
ON(
    job.job_id = paam.job_id
            and paam.effective_end_date between job.effective_start_date
            and job.effective_end_date
    )
LEFT JOIN per_jobs_f_tl jot
ON(
    jot.job_id = paam.job_id
            and jot.language = userenv(
        'lang')
            and paam.effective_end_date between jot.effective_start_date
            and jot.effective_end_date
    )
LEFT JOIN hr_all_positions_f pos
ON(
    pos.position_id = paam.position_id
            and paam.effective_end_date between pos.effective_start_date
            and pos.effective_end_date
    )
LEFT JOIN hr_organization_v sid
ON(
    sid.organization_id = pos.union_id
            and sid.status = upper(
        'a')
            and sid.classification_code = upper(
        'ora_per_union')
            and paam.effective_end_date between sid.effective_start_date
            and sid.effective_end_date
    )
INNER JOIN fnd_flex_values flv
ON(
    flv.flex_value_id = pos.cost_center)
INNER JOIN fnd_flex_values_tl ffv
ON(
    ffv.flex_value_id = flv.flex_value_id
            and ffv.language = userenv(
        'lang')
    )
WHERE
1 = 1
--and paam.primary_assignment_flag = upper('y')
        and paam.assignment_type = upper(
    'e')
        and paam.effective_latest_change = upper(
    'y')
        and trunc(
    sysdate)
between paam.effective_start_date
        and paam.effective_end_date
        and paam.active_status_type = 'ACTIVE'
        and rif.org_information1 = '0412'
        AND ROWNUM < 100
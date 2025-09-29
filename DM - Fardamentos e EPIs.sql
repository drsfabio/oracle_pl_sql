with uniformes as (
  select
    nvl(:p_data, trunc(sysdate)) as data_processamento,
    bu.name as empresa,
    (
      select
        rif1.org_information1
      from
        hr_organization_information_f rif1,
        hr_organization_v est1
      where
        rif1.org_information_context in ('lacls_br_hcm_lru_code', 'gm_eff_org_filial_dl')
        and rif1.organization_id = est1.organization_id
        and trunc(sysdate) between rif1.effective_start_date
        and rif1.effective_end_date
        and substr(est1.organization_code, -14, 14) = pos.attribute19
        and est1.classification_code = upper('hcm_reporting_establishment')
        and rownum = 1
    ) as cod_filial,
    xle.establishment_name as filial,
    (
      substr(xle.registration_number, 1, 2) || '.' || substr(xle.registration_number, 3, 3) || '.' || substr(xle.registration_number, 6, 3) || '/' || substr(xle.registration_number, 9, 4) || '-' || substr(xle.registration_number, 13, 2)
    ) as cnpj_filial,
    dp.name as departamento,
    job.name as cargo,
    pnam.full_name as colaborador,
    (
      select
        flvg.meaning
      from
        per_all_people_f papf,
        per_people_legislative_f pplf,
        fnd_lookup_values flvg
      where
        papf.person_id = pplf.person_id
        and pplf.legislation_code = upper('br')
        and flvg.language = upper('ptb')
        and papf.person_id = per.person_id
        and trunc (sysdate) between pplf.effective_start_date
        and pplf.effective_end_date
        and trunc (sysdate) between papf.effective_start_date
        and papf.effective_end_date
        and pplf.sex = flvg.lookup_code
        and flvg.lookup_type = 'sex'
    ) as sexo,
    regexp_replace(cpf.national_identifier_number, '\W') as cpf,
    '' as requisicao,
    '' as num_candidato,
    '' as etapa,
    pos.position_code as posicao,
    per.attribute6 as camisa,
    per.attribute7 as calca,
    per.attribute8 as calcado
  from
    per_all_assignments_m asg
    inner join per_persons per on (
      per.person_id = asg.person_id
      and (
        per.attribute6 is not null
        or per.attribute7 is not null
        or per.attribute8 is not null
      )
      and trunc(per.creation_date) >= '2024-05-01'
    )
    left join per_person_names_f pnam on (
      per.person_id = pnam.person_id
      and pnam.name_type = upper('global')
      and sysdate between pnam.effective_start_date
      and pnam.effective_end_date
    )
    left join per_jobs_f_tl job on (
      job.source_lang = upper('ptb')
      and job.language = upper('ptb')
      and asg.job_id = job.job_id
    )
    left join xle_registrations_v xle on (
      xle.registration_number = asg.ass_attribute19
    )
    left join hr_organization_v dp on (
      dp.classification_code = upper('department')
      and dp.organization_id = asg.organization_id
    )
    left join hr_organization_v bu on (
      bu.classification_code = upper('fun_business_unit')
      and bu.organization_id = asg.business_unit_id
      and job.language = upper('ptb')
    )
    left join hr_all_positions_f pos on (
      asg.position_id = pos.position_id
      and sysdate between pos.effective_start_date
      and pos.effective_end_date
    )
    left join per_national_identifiers cpf on (
      cpf.person_id = asg.person_id
      and cpf.national_identifier_type = upper('cpf')
    )
  where
    asg.system_person_type = upper('pwk')
    and asg.assignment_status_type = upper('active')
    and asg.position_id is not null
    and sysdate between asg.effective_start_date
    and asg.effective_end_date
    and trunc(asg.last_update_date) >= nvl(:p_data, trunc(sysdate))
    and asg.person_id not in (
      select
        isub1.person_id
      from
        irc_submissions isub1
      where
        asg.person_id = isub1.person_id
        and isub1.submission_confirmed_date <= (asg.effective_start_date - 30)
    )
  union
  select
    nvl(:p_data, trunc(sysdate)) as data_processamento,
    bu.name as empresa,
    (
      select
        rif1.org_information1
      from
        hr_organization_information_f rif1,
        hr_organization_v est1
      where
        rif1.org_information_context in ('lacls_br_hcm_lru_code', 'gm_eff_org_filial_dl')
        and rif1.organization_id = est1.organization_id
        and trunc(sysdate) between rif1.effective_start_date
        and rif1.effective_end_date
        and substr(est1.organization_code, -14, 14) = pos.attribute19
        and est1.classification_code = upper('hcm_reporting_establishment')
        and rownum = 1
    ) as cod_filial,
    xle.establishment_name as filial,
    (
      substr(xle.registration_number, 1, 2) || '.' || substr(xle.registration_number, 3, 3) || '.' || substr(xle.registration_number, 6, 3) || '.' || substr(xle.registration_number, 9, 4) || '.' || substr(xle.registration_number, 13, 2)
    ) as cnpj_filial,
    dp.name as departamento,
    job.name as cargo,
    pnam.full_name as colaborador,
    (
      select
        flvg.meaning
      from
        per_all_people_f papf,
        per_people_legislative_f pplf,
        fnd_lookup_values flvg
      where
        papf.person_id = pplf.person_id
        and pplf.legislation_code = upper('br')
        and flvg.language = upper('ptb')
        and papf.person_id = isub.person_id
        and trunc (sysdate) between pplf.effective_start_date
        and pplf.effective_end_date
        and trunc (sysdate) between papf.effective_start_date
        and papf.effective_end_date
        and pplf.sex = flvg.lookup_code
        and flvg.lookup_type = upper('sex')
    ) as sexo,
    regexp_replace(cpf.national_identifier_number, '\W') as cpf,
    irv.requisition_number as requisicao,
    icand.candidate_number as num_candidato,
    ipt.name as etapa,
    pos.position_code as posicao,
    xinfo.pei_information4 as camisas,
    xinfo.pei_information5 as calcas,
    xinfo.pei_information6 as calcados
  from
    irc_submissions isub
    inner join irc_candidates icand on (isub.person_id = icand.person_id)
    inner join irc_requisitions_vl irv on (
      isub.person_id = icand.person_id
      and isub.requisition_id = irv.requisition_id
    )
    inner join irc_phases_tl ipt on (
      ipt.name in ('validação pré-admissão')
      and ipt.language = upper('ptb')
      and isub.current_phase_id = ipt.phase_id
    )
    inner join irc_states_tl istt on (
      isub.current_state_id = istt.state_id
      and istt.name not in ('rejected by employer', 'withdrawn by candidate')
      and istt.language = upper('ptb')
    )
    inner join per_people_f ppf on (ppf.person_id = irv.recruiter_id)
    inner join per_jobs_f_tl job on (
      job.source_lang = upper('ptb')
      and job.language = upper('ptb')
    )
    inner join hr_all_positions_f pos on (
      pos.position_id = irv.position_id
      and sysdate between pos.effective_start_date
      and pos.effective_end_date
      and pos.job_id = job.job_id
    )
    inner join xle_registrations_v xle on (
      xle.establishment_name is not null
      and xle.registration_number = pos.attribute19
    )
    inner join hr_organization_v dp on (
      dp.classification_code = upper('department')
      and dp.organization_id = pos.organization_id
    )
    inner join hr_organization_v bu on (
      bu.classification_code = upper('fun_business_unit')
      and bu.organization_id = pos.business_unit_id
    )
    inner join per_person_names_f pnam on (
      pnam.person_id = isub.person_id
      and pnam.name_type = upper('global')
      and sysdate between pnam.effective_start_date
      and pnam.effective_end_date
    )
    left join irc_ja_extra_info xinfo on (
      isub.submission_id = xinfo.submission_id
    )
    left join per_national_identifiers cpf on (
      cpf.person_id = isub.person_id
      and cpf.national_identifier_type = upper('cpf')
    )
  where
    isub.submission_confirmed_date >= nvl(:p_data, trunc(sysdate))
    and isub.object_status = upper('ora_active')
)
select
  distinct *
from
  uniformes
order by
  empresa,
  filial,
  colaborador
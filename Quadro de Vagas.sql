select
  distinct bu.name as bu_name,
  est.name as filial,
  dp.name as depto_name,
  pos.position_code as position_code,
  pos2.name as pos_name,
  pos.position_id as position_id,
  pos.fte as quadro_ideal,(
    select
      count(*)
    from
      per_all_assignments_m t2
    where
      t2.assignment_status_type = 'active'
      and t2.position_id = pos.position_id
      and t2.system_person_type = 'emp'
      and trunc(t2.effective_start_date) <= current_date
      and (
        trunc(t2.effective_end_date) = '4712-12-31'
        or trunc(t2.effective_end_date) > current_date
      )
  ) - (
    select
      count(distinct t2.person_id)
    from
      per_all_assignments_m t2,
      anc_per_abs_entries t4
    where
      t2.assignment_status_type = 'active'
      and t2.system_person_type = 'emp'
      and t2.position_id = pos.position_id
      and trunc(t2.effective_start_date) <= current_date
      and (
        trunc(t2.effective_end_date) = '4712-12-31'
        or trunc(t2.effective_end_date) > current_date
      )
      and t2.person_id = t4.person_id
      and trunc(t4.start_date) <= current_date
      and trunc(t4.end_date) is null
  ) as quadro_real,(
    select
      count(*)
    from
      per_all_assignments_m t2
    where
      t2.assignment_status_type = 'active'
      and t2.position_id = pos.position_id
      and t2.system_person_type = 'emp'
      and trunc(t2.effective_start_date) <= current_date
      and (
        trunc(t2.effective_end_date) = '4712-12-31'
        or trunc(t2.effective_end_date) > current_date
      )
  ) - (
    select
      count(distinct t2.person_id)
    from
      per_all_assignments_m t2,
      anc_per_abs_entries t4
    where
      t2.assignment_status_type = 'active'
      and t2.system_person_type = 'emp'
      and t2.position_id = pos.position_id
      and trunc(t2.effective_start_date) <= current_date
      and (
        trunc(t2.effective_end_date) = '4712-12-31'
        or trunc(t2.effective_end_date) > current_date
      )
      and t2.person_id = t4.person_id
      and trunc(t4.start_date) <= current_date
      and trunc(t4.end_date) is null
  ) - pos.fte as diferenca,(
    select
      count(distinct t2.person_id)
    from
      per_all_assignments_m t2
    where
      t2.assignment_status_type = 'inactive'
      and t2.system_person_type = 'emp'
      and t2.record_creator = 'mf_terminations'
      and t2.position_id = pos.position_id
  ) as desligamento_programado,(
    select
      count(distinct t2.person_id)
    from
      per_all_assignments_m t2,
      anc_per_abs_entries t4
    where
      t2.assignment_status_type = 'active'
      and t2.system_person_type = 'emp'
      and t2.position_id = pos.position_id
      and trunc(t2.effective_start_date) <= current_date
      and (
        trunc(t2.effective_end_date) = '4712-12-31'
        or trunc(t2.effective_end_date) > current_date
      )
      and t2.person_id = t4.person_id
      and trunc(t4.start_date) <= current_date
      and trunc(t4.end_date) is null
  ) as afastados,(
    select
      count(distinct t2.person_id)
    from
      per_all_assignments_m t2,
      per_disabilities_f t4
    where
      t2.assignment_status_type = 'active'
      and t2.system_person_type = 'emp'
      and t2.position_id = pos.position_id
      and trunc(t2.effective_start_date) <= current_date
      and (
        trunc(t2.effective_end_date) = '4712-12-31'
        or trunc(t2.effective_end_date) > current_date
      )
      and t2.person_id = t4.person_id
      and trunc(t4.effective_end_date) >= current_date
      and trunc(t4.effective_start_date) <= current_date
  ) as pcd,(
    select
      count(*)
    from
      per_all_assignments_m t2
    where
      t2.assignment_status_type = 'active'
      and t2.position_id = pos.position_id
      and t2.system_person_type = 'pwk'
      and trunc(t2.effective_start_date) <= current_date
      and (
        trunc(t2.effective_end_date) = '4712-12-31'
        or trunc(t2.effective_end_date) > current_date
      )
  ) as em_admissao,(
    select
      count(*)
    from
      irc_requisitions_b t5
    where
      t5.object_status = 'ora_active'
      and t5.approved_date is not null
      and t5.filled_date is null
      and pos.position_id = t5.position_id
      and t5.suspended_duration is null
      and trunc(t5.open_date) <= current_date
  ) as vagas_em_aberto
from
  hr_all_positions_f pos
  left join hr_organization_v bu on bu.classification_code = 'fun_business_unit'
  and bu.organization_id = pos.business_unit_id
  left join hr_organization_v dp on dp.classification_code = 'department'
  and dp.organization_id = pos.organization_id
  left join hr_all_positions_f_tl pos2 on pos2.position_id = pos.position_id
  and language = 'ptb'
  left join hr_organization_v unio on unio.organization_id = pos.union_id
  and unio.classification_code = 'ora_per_union'
  left join hr_organization_v est on substr(est.organization_code, -14, 14) = pos.attribute19
  and est.classification_code = 'hcm_reporting_establishment'
  left join per_jobs_f job on job.job_id = pos.job_id
  left join per_jobs_f_tl jot on jot.job_id = job.job_id
where
  pos.effective_end_date = '4712-12-31'
  and pos.active_status = 'a'
  and trunc(sysdate) between pos.effective_start_date
  and pos.effective_end_date
  and trunc(sysdate) between pos2.effective_start_date
  and pos2.effective_end_date
  and (
    case
      when decode(:p_filial, null, 1, 0) = 1 then 1
      when (est.name) in (:p_filial) then 1
      else 0
    end
  ) = 1
  and (
    case
      when decode(:p_empresa, null, 1, 0) = 1 then 1
      when (bu.name) in (:p_empresa) then 1
      else 0
    end
  ) = 1
  and (
    case
      when decode(:p_departamento, null, 1, 0) = 1 then 1
      when (dp.name) in (:p_departamento) then 1
      else 0
    end
  ) = 1
  and (
    case
      when decode(:p_cargo, null, 1, 0) = 1 then 1
      when (jot.name) in (:p_cargo) then 1
      else 0
    end
  ) = 1
order by
  4,
  1,
  2,
  3
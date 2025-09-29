select
  ppn.display_name,
  pall.person_number,
  asg.assignment_number,
  usr.username,
  pos.date_start,
  pos.actual_termination_date,
  aor.legislative_data_group_id,
  aor.location_id,
  aor.responsibility_name,
  aor.assignment_id,
  aor.person_id,
  aor.start_date,
  aor.end_date,
  aor.responsibility_type,
  aor.status,
  aor.recruiting_org_tree_code,
  aor.recruiting_org_tree_ver,
  loc.internal_location_code,
  loc.location_use,
  loc.location_code,
  loc.location_name
from
  per_asg_responsibilities aor
  inner join per_persons pps on aor.person_id = pps.person_id
  inner join per_person_names_f ppn on aor.person_id = ppn.person_id
  inner join per_all_people_f pall on aor.person_id = pall.person_id
  inner join per_all_assignments_m asg on aor.person_id = asg.person_id
  inner join per_periods_of_service pos on pos.period_of_service_id = asg.period_of_service_id
  and pos.legislation_code = upper('br')
  and asg.effective_end_date between pos.date_start
  and nvl(
    pos.actual_termination_date,
    to_date('4712-12-31', 'rrrr/mm/dd')
  )
  left join hr_locations loc on loc.location_id = aor.location_id
  and trunc(sysdate) between loc.effective_start_date
  and loc.effective_end_date
  and loc.active_status = upper('a')
  and loc.style = upper('br')
  left join per_users usr ON usr.user_guid = pps.user_guid
where
  1 = 1
  and trunc(sysdate) between ppn.effective_start_date
  and ppn.effective_end_date
  and ppn.name_type = upper('global')
  and asg.assignment_type = upper('e')
  and trunc(sysdate) between asg.effective_start_date
  and asg.effective_end_date
  and aor.responsibility_type = upper('ora_recruiting')
  --and ppn.display_name LIKE '%LIVIA AZEVEDO SILVA LIMA%'
  
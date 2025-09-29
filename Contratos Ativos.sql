select
  per.person_id,
  pap.person_number,
  to_date(pos.date_start, 'rrrr/mm/dd') date_start,
  ppn.full_name,
  asg.period_of_service_id,
  asg.assignment_type,
  asg.assignment_id,
  asg.assignment_number,
  asg.organization_id,
  asg.job_id,
  asg.location_id,
  asg.position_id,
  asg.grade_id,
  asg.establishment_id,
  asg.ass_attribute19,
  pus.username,
  pus.user_guid
from
  per_persons per
  inner join per_person_names_f ppn on ppn.person_id = per.person_id
  and ppn.name_type = upper('global')
  and trunc(sysdate) between ppn.effective_start_date
  and ppn.effective_end_date
  inner join per_all_people_f pap on pap.person_id = per.person_id
  and trunc(sysdate) between pap.effective_start_date
  and pap.effective_end_date
  inner join per_all_assignments_m asg on asg.person_id = per.person_id
  and asg.assignment_status_type = upper('active')
  and asg.effective_latest_change = upper('y')
  and asg.assignment_type = upper('e')
  and trunc(sysdate) between asg.effective_start_date
  and asg.effective_end_date
  inner join per_periods_of_service pos on pos.period_of_service_id = asg.period_of_service_id
  left join per_users pus on pus.user_guid = per.user_guid
where
  nvl(
    pos.actual_termination_date,
    to_date('4712-12-31', 'rrrr/mm/dd')
  ) > trunc(sysdate)
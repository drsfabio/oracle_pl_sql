SELECT ppl.person_number,
       ppl.person_id,
       ppln.display_name,
       pps.date_start                                               hire_date,
       pps.actual_termination_date                                  term_date,
       paf.assignment_type,
       paf.assignment_number,
       paf.asg_information1                                         aca_ft,
       paf.action_code,
       paf.effective_start_date                                     paf_effective_start,
       paf.effective_end_date                                       paf_effective_end,
       paf.primary_flag,
       pni.national_identifier_number,
       le.name                                                      le_name,
       rep_est.name                                                 reporting_establishment,
       ppln_sup.full_name                                           supervisor_name,
       pps.worker_number,
       ppos_sup.worker_number                                       supervisor_worker_number,
       paf_sup.assignment_number                                    supervisor_asg,
       ppl_sup.person_number                                        supervisor_person_num,
       pps.adjusted_svc_date,
       org.name                                                     org_name,
       jobs.name                                                    job_name,
       paf.assignment_id,
       paf.assignment_name,
       paf.employee_category,
       paf.employment_category,
       hr_general.Decode_lookup('EMP_CAT', paf.employment_category) asg_category,
       past.user_status                                             assignment_status,
       paf.assignment_status_type_id,
       To_char(pp.date_of_birth, 'MM/DD/YYYY')                      emp_dob
FROM   per_all_assignments_m paf,
       hr_all_organization_units org,
       per_all_people_f ppl,
       per_person_names_f_v ppln,
       per_jobs jobs,
       per_national_identifiers pni,
       hr_all_organization_units_vl rep_est,
       per_persons pp,
       per_assignment_status_types_vl past,
       per_periods_of_service pps,
       per_assignment_supervisors_f sup,
       per_all_assignments_f paf_sup,
       per_all_people_f ppl_sup,
       per_person_names_f_v ppln_sup,
       per_periods_of_service ppos_sup,
       per_legal_employers le
WHERE  1 = 1
       AND Trunc(SYSDATE) BETWEEN paf.effective_start_date (+) AND paf.effective_end_date (+)
       AND Trunc(SYSDATE) BETWEEN ppl.effective_start_date AND ppl.effective_end_date
       AND Trunc(SYSDATE) BETWEEN ppln.effective_start_date (+) AND ppln.effective_end_date (+)
       AND ppl.person_id = pp.person_id (+)
       AND ppl.person_id = paf.person_id(+)
       AND ppl.person_id = ppln.person_id (+)
       AND paf.job_id = jobs.job_id(+)
       AND paf.organization_id = org.organization_id (+)
       AND paf.assignment_status_type_id = past.assignment_status_type_id (+)
       AND ppl.person_id = pni.person_id (+)
       AND paf.assignment_type = 'E'
       AND pni.national_identifier_type (+) = 'SSN'
       AND paf.assignment_id = sup.assignment_id (+)
       AND sup.manager_assignment_id = paf_sup.assignment_id(+)
       AND paf_sup.person_id = ppl_sup.person_id(+)
       AND ppl_sup.person_id = ppln_sup.person_id(+)
       AND paf_sup.period_of_service_id = ppos_sup.period_of_service_id (+)
       AND Trunc(SYSDATE) BETWEEN sup.effective_start_date (+) AND sup.effective_end_date(+)
       AND Trunc(SYSDATE) BETWEEN paf_sup.effective_start_date (+) AND paf_sup.effective_end_date(+)
       AND Trunc(SYSDATE) BETWEEN ppl_sup.effective_start_date(+) AND ppl_sup.effective_end_date(+)
       AND Trunc(SYSDATE) BETWEEN ppln_sup.effective_start_date (+) AND
                                  ppln_sup.effective_end_date(+)
       AND Trunc(SYSDATE) BETWEEN le.effective_start_date (+) AND le.effective_end_date(+)
       AND paf.legal_entity_id = le.organization_id (+)
       AND le.status = 'A'
       AND past.user_status NOT LIKE '%In%ctive%'
       AND paf.establishment_id = rep_est.organization_id (+)
       AND 1 = 1
ORDER  BY pps.date_start ASC,
          paf.last_update_date DESC,
          paf.effective_start_date ASC; 

 
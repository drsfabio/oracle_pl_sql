SELECT ldg.name legislative_data_group
    ,person.full_name
    ,asg.assignment_number
    ,alloc.effective_start_date
    ,alloc.effective_end_date
    ,accounts.proportion
    ,accounts.segment1
    ,accounts.segment2
    ,accounts.segment3
    ,accounts.segment4
    ,accounts.segment5
    ,accounts.segment6
FROM pay_cost_allocations_f alloc
    ,per_legislative_data_groups_vl ldg
    ,pay_rel_groups_dn rel
    ,per_person_names_f_v person
    ,per_all_assignments_m_v asg
    ,pay_cost_alloc_accounts accounts
WHERE alloc.legislative_data_group_id = ldg.legislative_data_group_id
    AND alloc.source_type = 'ASG'
    AND alloc.source_id = rel.relationship_group_id
    AND rel.assignment_id = asg.assignment_id
    AND alloc.effective_start_date BETWEEN asg.effective_start_date
        AND asg.effective_end_date
    AND asg.effective_latest_change = 'Y'
    AND asg.person_id = person.person_id
    AND alloc.effective_start_date BETWEEN person.effective_start_date
        AND person.effective_end_date
    AND alloc.cost_allocation_record_id = accounts.cost_allocation_record_id(+)
ORDER BY ldg.name
    ,person.full_name
    ,asg.assignment_number
    ,alloc.effective_start_date



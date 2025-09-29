select distinct module_identifier "ProcessName"
, p.person_number
, n.full_name
, subject
, STATUS
, h.INITIATOR_USER_ID "SubmittedBy" 
, d.submitted_date
, ppnf_sup.full_name "assignees"
, ps.person_number "ApproverPersonNumber"
, ppnf_sup.full_name "PendingApproverName", h.transaction_id
, module_identifier
, object
, object_id
from
hrc_txn_header h, 
hrc_txn_data d,
anc_per_abs_entries abs,
PER_PERSON_SECURED_LIST_V p, 
per_person_names_f n,
PER_ASSIGNMENT_SECURED_LIST_V a,
per_assignment_supervisors_f AssignmentSupervisor,
per_person_names_f_v ppnf_sup,
per_all_people_f ps
where 
h.transaction_id = d.transaction_id  
and object_id= abs.per_absence_entry_id
and abs.person_id = p.person_id
and n.person_id = p.person_id
and a.person_id = p.person_id
and abs.approval_status_cd = 'AWAITING'
and a.assignment_type ='E'
and n.name_type = 'GLOBAL'
and ppnf_sup.name_type = 'GLOBAL'
and a.assignment_status_type = 'ACTIVE'
and ps.person_id = ppnf_sup.person_id
and AssignmentSupervisor.assignment_id = a.assignment_id
and AssignmentSupervisor.manager_id = ppnf_sup.person_id
and sysdate between p.effective_start_date and p.effective_end_date
and sysdate between n.effective_start_date and n.effective_end_date
and sysdate between a.effective_start_date and a.effective_end_date
and sysdate between ps.effective_start_date and ps.effective_end_date
and sysdate between AssignmentSupervisor.effective_start_date and AssignmentSupervisor.effective_end_date
and sysdate between ppnf_sup.effective_start_date and ppnf_sup.effective_end_date
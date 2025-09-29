SELECT pcafv.collective_agreement_name
      ,TO_CHAR(pcafv.effective_start_date,'YYYY/MM/DD') Start_Date
      ,pcafv.legislation_code
      ,pcafv.status
      ,pcafv.identification_code
      ,pcafv.description
      ,pcafv.comments
      ,houf_union.name Union_Name
      ,pcafv.bargaining_unit_code
      ,ple.name Legal_Employer
      ,pcafv.employee_org_name
      ,pcafv.employee_org_contact
      ,pcafv.employer_org_name
      ,pcafv.employer_org_contact
  FROM per_col_agreements_f_vl pcafv
      ,hr_all_organization_units_f_vl houf_union
      ,per_legal_employers ple
 WHERE pcafv.legal_entity_id = ple.organization_id(+)
   AND pcafv.union_id = houf_union.organization_id(+)
   AND trunc(SYSDATE) BETWEEN pcafv.effective_start_date AND pcafv.effective_end_date
   AND trunc(SYSDATE) BETWEEN houf_union.effective_start_date(+) AND houf_union.effective_end_date(+)
   AND trunc(SYSDATE) BETWEEN ple.effective_start_date(+) AND ple.effective_end_date(+)
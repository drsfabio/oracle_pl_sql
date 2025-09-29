select pedv.definition_name
      ,ffv.formula_name
  from per_ext_data_elements_vl pedev
      ,pay_report_records_f prrf
      ,pay_report_blocks prb
      ,per_ext_definitions_vl pedv
      ,ff_formulas_vl ffv 
where pedev.report_record_id = prrf.report_record_id
  and prrf.report_block_id = prb.report_block_id
  and prb.ext_definition_id = pedv.ext_definition_id
  and pedv.definition_name LIKE 'Dec%Absence%'
  and ffv.formula_id = pedev.rule_id
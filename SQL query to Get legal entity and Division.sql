SELECT horg.name enterprise ,
       horg.organization_id enterprise_id ,
       xr.registered_name ,
       xr.alternate_registered_name ,
       xr.registration_number ,
       xr.place_of_registration ,
       xr.effective_from ,
       xr.effective_to ,
       xep.name "LEGAL_ENTITY_NAME" ,
       xep.legal_entity_identifier ,
       hou.business_group_id ,
       hou.organization_id "BU_ID" ,
       hou.name "BU_NAME" ,
       hou.date_from "BU_FROM_DATE" ,
       hou.date_to "BU_TO_DATE" ,
       hou.short_code "BU_SHORT_CODE" ,
       hou.set_of_books_id ,
       gll.name ledger_name ,
       gll.ledger_id
FROM xle_entity_profiles xep ,
     xle_registrations xr ,
     hr_operating_units hou ,
     hr_organization_units horg ,
     gl_ledger_norm_seg_vals glnsv ,
     gl_ledgers gll
WHERE xep.legal_entity_id = xr.source_id
  AND xr.source_table = 'XLE_ENTITY_PROFILES'
  AND xep.legal_entity_id = hou.default_legal_context_id(+)
  AND horg.organization_id = hou.business_group_id
  AND glnsv.legal_entity_id = xep.legal_entity_id
  AND gll.ledger_id = glnsv.ledger_id
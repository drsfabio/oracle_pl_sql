SELECT bo.data_set_id, b.ui_name data_file_name, fl.text line_details,
       fr.key_source_id, l.msg_text MESSAGE, fr.line_operation,
       ds.ucm_content_id content_id, ds.request_id,
       fr.key_source_owner source_system_owner, bo.creation_date
  FROM hrc_dl_message_lines l,
       hrc_dl_data_set_bus_objs bo,
       hrc_dl_data_sets ds,
       hrc_dl_physical_lines pl,
       hrc_dl_file_rows fr,
       hrc_dl_file_lines fl,
       hrc_dl_ui_bus_objects_tl b,
       hrc_dl_business_objects c
 WHERE bo.data_set_bus_obj_id = l.data_set_bus_obj_id
   AND ds.data_set_id = bo.data_set_id
   AND pl.physical_line_id(+) = l.message_source_line_id
   AND fr.row_id(+) = pl.row_id
   AND fl.line_id(+) = fr.line_id
   AND b.language = 'US'
   AND bo.business_object_id = c.business_object_id
   AND c.ui_business_object_id = b.ui_business_object_id
   AND l.message_source_table_name = 'HRC_DL_PHYSICAL_LINES'
UNION
SELECT bo.data_set_id, b.ui_name data_file_name, fl.text line_details,
       fr.key_source_id, l.msg_text MESSAGE, fr.line_operation,
       ds.ucm_content_id content_id, ds.request_id,
       fr.key_source_owner source_system_owner, bo.creation_date
  FROM hrc_dl_message_lines l,
       hrc_dl_data_set_bus_objs bo,
       hrc_dl_data_sets ds,
       hrc_dl_logical_lines ll,
       hrc_dl_file_rows fr,
       hrc_dl_file_lines fl,
       hrc_dl_ui_bus_objects_tl b,
       hrc_dl_business_objects c
 WHERE bo.data_set_bus_obj_id = l.data_set_bus_obj_id
   AND ds.data_set_id = bo.data_set_id
   AND ll.logical_line_id(+) = l.message_source_line_id
   AND fr.logical_line_id(+) = ll.logical_line_id
   AND fl.line_id(+) = fr.line_id
   AND b.language = 'US'
   AND bo.business_object_id = c.business_object_id
   AND c.ui_business_object_id = b.ui_business_object_id
   AND l.message_source_table_name = 'HRC_DL_LOGICAL_LINES'
UNION
SELECT bo.data_set_id, b.ui_name data_file_name, fl.text line_details,
       fr.key_source_id, 'LOADED_SUCCESSFULLY' MESSAGE, fr.line_operation,
       ds.ucm_content_id content_id, ds.request_id,
       fr.key_source_owner source_system_owner, bo.creation_date
  FROM hrc_dl_data_set_bus_objs bo,
       hrc_dl_data_sets ds,
       hrc_dl_physical_lines pl,
       hrc_dl_file_rows fr,
       hrc_dl_file_lines fl,
       hrc_dl_ui_bus_objects_tl b,
       hrc_dl_business_objects c
 WHERE ds.data_set_id = bo.data_set_id
   AND fr.row_id = pl.row_id
   AND fl.line_id = fr.line_id
   AND b.language = 'US'
   AND bo.data_set_bus_obj_id = pl.data_set_bus_obj_id
   AND pl.validated_loaded_status = 'LOADED_SUCCESS'
   AND bo.business_object_id = c.business_object_id
   AND c.ui_business_object_id = b.ui_business_object_id
   AND bo.loaded_count >= 1
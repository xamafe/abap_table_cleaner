interface ZIF_TABLE_CLEANER
  public .
  TYPES ty_fields TYPE SORTED TABLE OF fieldname WITH UNIQUE DEFAULT KEY.
  METHODS: get_table_name RETURNING value(r_result) TYPE tabname,
           get_block RETURNING value(r_result) TYPE abap_bool,
           get_fields RETURNING value(r_result) TYPE ty_fields,
           clean_input
                 CHANGING
                   ch_fields TYPE /SCWM/TT_FIELD_DEF.

endinterface.

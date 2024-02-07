interface ZIF_TABLE_CLEANER
  public .
  TYPES ty_fields TYPE STANDARD TABLE OF fieldname WITH DEFAULT KEY.
  METHODS: set_table_content IMPORTING i_table_content TYPE REF TO data,
           get_table_name RETURNING value(r_result) TYPE tabname,
           get_table_content RETURNING value(r_result) TYPE REF TO data,
           get_block RETURNING value(r_result) TYPE abap_bool,
           get_fields RETURNING value(r_result) TYPE ty_fields,
           clean CHANGING ch_table_content TYPE table OPTIONAL.

endinterface.

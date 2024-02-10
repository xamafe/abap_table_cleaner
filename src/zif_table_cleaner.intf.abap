INTERFACE zif_table_cleaner
  PUBLIC .
  TYPES ty_fields TYPE SORTED TABLE OF fieldname WITH UNIQUE DEFAULT KEY.
  METHODS: get_table_name RETURNING VALUE(r_result) TYPE tabname,
    get_block RETURNING VALUE(r_result) TYPE abap_bool,
    get_fields RETURNING VALUE(r_result) TYPE ty_fields,
    clean_input
      CHANGING
        ch_fields TYPE cnvltrl_rfc_db_fld_tt.

ENDINTERFACE.

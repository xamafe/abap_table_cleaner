FUNCTION z_secure_rfc_read_table.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(QUERY_TABLE) LIKE  DD02L-TABNAME
*"     VALUE(DELIMITER) LIKE  SONV-FLAG DEFAULT SPACE
*"     VALUE(NO_DATA) LIKE  SONV-FLAG DEFAULT SPACE
*"     VALUE(ROWSKIPS) LIKE  SOID-ACCNT DEFAULT 0
*"     VALUE(ROWCOUNT) LIKE  SOID-ACCNT DEFAULT 0
*"     VALUE(GET_SORTED) TYPE  BOOLE_D OPTIONAL
*"     VALUE(USE_ET_DATA_4_RETURN) TYPE  BOOLE_D OPTIONAL
*"  EXPORTING
*"     VALUE(ET_DATA) TYPE  SDTI_RESULT_TAB
*"  TABLES
*"      OPTIONS STRUCTURE  RFC_DB_OPT OPTIONAL
*"      FIELDS STRUCTURE  RFC_DB_FLD OPTIONAL
*"      DATA STRUCTURE  TAB512 OPTIONAL
*"  EXCEPTIONS
*"      TABLE_NOT_AVAILABLE
*"      TABLE_WITHOUT_DATA
*"      OPTION_NOT_VALID
*"      FIELD_NOT_VALID
*"      NOT_AUTHORIZED
*"      DATA_BUFFER_EXCEEDED
*"      RFC_READ_TABLE_OTHERS
*"----------------------------------------------------------------------
  AUTHORITY-CHECK OBJECT 'ZSECRFC'
                  ID 'ACTVT' FIELD '03'
                  ID 'TABLE' FIELD query_table.
  IF sy-subrc <> 0.
    RAISE not_authorized.
  ENDIF.

  DATA(table_cleaner) = zcl_table_cleaner=>create( query_table ).
  IF table_cleaner IS BOUND
    AND table_cleaner->get_block( ) = abap_true.
    RAISE not_authorized.
  ELSEIF table_cleaner IS BOUND.
    table_cleaner->clean_input( CHANGING ch_fields = fields[] ).
  ENDIF.

  CALL FUNCTION 'RFC_READ_TABLE'
    EXPORTING
      query_table          = query_table
      delimiter            = delimiter
      no_data              = no_data
      rowskips             = rowskips
      rowcount             = rowcount
      get_sorted           = get_sorted
      use_et_data_4_return = use_et_data_4_return
    IMPORTING
      et_data              = et_data
    TABLES
      options              = options
      fields               = fields
      data                 = data
    EXCEPTIONS
      table_not_available  = 1
      table_without_data   = 2
      option_not_valid     = 3
      field_not_valid      = 4
      not_authorized       = 5
      data_buffer_exceeded = 6
      OTHERS               = 7.

  CASE sy-subrc.
    WHEN 1. RAISE table_not_available .
    WHEN 2. RAISE table_without_data  .
    WHEN 3. RAISE option_not_valid    .
    WHEN 4. RAISE field_not_valid     .
    WHEN 5. RAISE not_authorized      .
    WHEN 6. RAISE data_buffer_exceeded.
    WHEN 7. RAISE rfc_read_table_others.
  ENDCASE.


ENDFUNCTION.

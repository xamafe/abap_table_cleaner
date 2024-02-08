CLASS zcl_table_cleaner DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES zif_table_cleaner.
    ALIASES: get_table_name FOR zif_table_cleaner~get_table_name,
             get_block FOR zif_table_cleaner~get_block,
             get_fields FOR zif_table_cleaner~get_fields,
             ty_fields FOR zif_table_cleaner~ty_fields.

    CLASS-METHODS create
      IMPORTING
        i_query_table   TYPE dd02l-tabname
      RETURNING
        VALUE(r_result) TYPE REF TO zif_table_cleaner.
    METHODS: constructor
      IMPORTING
        i_table_name TYPE tabname,
      set_block IMPORTING i_block TYPE abap_bool,
      set_fields IMPORTING i_fields TYPE ty_fields.

  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA table_name TYPE tabname.
    DATA block TYPE abap_bool.
    DATA fields TYPE SORTED TABLE OF fieldname WITH UNIQUE DEFAULT KEY.
    METHODS set_table_name IMPORTING i_table_name TYPE tabname.
ENDCLASS.


CLASS zcl_table_cleaner IMPLEMENTATION.

  METHOD constructor.

    me->table_name = i_table_name.

  ENDMETHOD.
  METHOD zif_table_cleaner~get_table_name.
    r_result = me->table_name.
  ENDMETHOD.

  METHOD set_table_name.
    me->table_name = i_table_name.
  ENDMETHOD.

  METHOD create.
    SELECT FROM ztable_cleaner
        FIELDS *
        WHERE table_name = @i_query_table
        INTO TABLE @DATA(restrictions).
    IF sy-subrc <> 0.
      EXIT.
    ENDIF.
    DATA(table_cleaner) = NEW zcl_table_cleaner( i_query_table ).
    table_cleaner->set_block( restrictions[ 1 ]-block ).
    table_cleaner->set_fields( VALUE #( FOR restriction IN restrictions
                                        ( restriction-field_name ) ) ).
    r_result = table_cleaner.
  ENDMETHOD.

  METHOD zif_table_cleaner~get_block.
    r_result = me->block.
  ENDMETHOD.

  METHOD set_block.
    me->block = i_block.
  ENDMETHOD.

  METHOD zif_table_cleaner~get_fields.
    r_result = me->fields.
  ENDMETHOD.

  METHOD set_fields.
    me->fields = i_fields.
  ENDMETHOD.

  METHOD zif_table_cleaner~clean_input.

    "TODO: If empty get whole table...

    ch_fields = FILTER #( ch_fields EXCEPT IN get_fields( ) WHERE fieldname = table_line  ).

  ENDMETHOD.

ENDCLASS.

CLASS zcl_table_cleaner DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES zif_table_cleaner.
    ALIASES: set_table_content FOR zif_table_cleaner~set_table_content,
             get_table_name FOR zif_table_cleaner~get_table_name,
             get_table_content FOR zif_table_cleaner~get_table_content,
             get_block FOR zif_table_cleaner~get_block,
             get_fields FOR zif_table_cleaner~get_fields,
             ty_fields FOR zif_table_cleaner~ty_fields,
             clean FOR zif_table_cleaner~clean.

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
    DATA table_content TYPE REF TO data.
    DATA block TYPE abap_bool.
    DATA fields TYPE STANDARD TABLE OF fieldname.
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

  METHOD zif_table_cleaner~get_table_content.
    r_result = me->table_content.
  ENDMETHOD.

  METHOD zif_table_cleaner~set_table_content.
    me->table_content = i_table_content.
  ENDMETHOD.


  METHOD create.
    SELECT FROM ztable_clener
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

  METHOD zif_table_cleaner~clean.
    FIELD-SYMBOLS <table> TYPE table.
    IF table_content IS BOUND.
      ASSIGN table_content->* TO <table>.
    ELSEIF ch_table_content IS SUPPLIED.
      ASSIGN ch_table_content TO <table>.
    ENDIF.

    IF get_block( ) = abap_true.
      FREE <table>.
      EXIT.
    ENDIF.

    LOOP AT get_fields( ) ASSIGNING FIELD-SYMBOL(<field_name>).
      LOOP AT <table> ASSIGNING FIELD-SYMBOL(<line>).
        ASSIGN COMPONENT <field_name> OF STRUCTURE <line> TO FIELD-SYMBOL(<field>).
        FREE <field>.
      ENDLOOP.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

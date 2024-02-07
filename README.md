# abap_table_cleaner

This small project wraps the RFC_READ_TABLE and adds some kind of safety via an Z-Auth Object and a customizing table... :-D

This is not meant to be productive code, but just a prototype how to solve this.

Some explanations what are the ideas behind this wrapper:
1) It contains a Z-authority object, because all auth objects used in RFC_READ_TABLE are used many times all over SAP. So a user may need some objects, but should not use RFC_READ_TABLE. In lower versions the function module was not protected at all.
2) In the future it should also test S_RFC, but this is a very common auth object, too
3) Then the original RFC_READ_TABLE is called. In newer versions, there are some authrity checks
4) After the data was fetched from the table the returned data can be filtered by a customization table. In this table columns are defined, that should never be returned (table USR02 column PWDSALTEDHASH is a good example). Or a table can be completely blocked.

I designed this with newer syntax, but the ideas can be adapted to SAP 4.6A aswell.

CLASS zpal_cl_seed_gl DEFINITION
  PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.

CLASS zpal_cl_seed_gl IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    DELETE FROM zpal_gl_account.

    DATA lt TYPE STANDARD TABLE OF zpal_gl_account.
    lt = VALUE #(
      ( client = sy-mandt gl_account = '100' description = 'Kasa'                              account_type = 'A' )
      ( client = sy-mandt gl_account = '102' description = 'Bankalar'                          account_type = 'A' )
      ( client = sy-mandt gl_account = '120' description = 'Alıcılar (Ticari Alacaklar)'       account_type = 'A' )
      ( client = sy-mandt gl_account = '150' description = 'İlk Madde ve Malzeme (Stok)'       account_type = 'A' )
      ( client = sy-mandt gl_account = '320' description = 'Satıcılar (Ticari Borçlar)'        account_type = 'P' )
      ( client = sy-mandt gl_account = '600' description = 'Yurtiçi Satışlar'                  account_type = 'G' )
      ( client = sy-mandt gl_account = '621' description = 'Satılan Ticari Malların Maliyeti'  account_type = 'M' )
    ).
    INSERT zpal_gl_account FROM TABLE @lt.

    out->write( |{ lines( lt ) } hesap eklendi.| ).

  ENDMETHOD.
ENDCLASS.

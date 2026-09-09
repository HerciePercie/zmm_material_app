CLASS zpal_cl_seed_je DEFINITION
  PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.

CLASS zpal_cl_seed_je IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    DELETE FROM zpal_je_head.
    DELETE FROM zpal_je_item.

    DATA lt_head TYPE STANDARD TABLE OF zpal_je_head.
    lt_head = VALUE #(
      ( client = sy-mandt je_id = 'JE-000001' posting_date = sy-datum doc_type = 'MANL'
        header_text = 'Açılış kaydı - Bankadan kasaya' total_debit = '50000.00' total_credit = '50000.00' currency_code = 'TRY' )
    ).
    INSERT zpal_je_head FROM TABLE @lt_head.

    DATA lt_item TYPE STANDARD TABLE OF zpal_je_item.
    lt_item = VALUE #(
      ( client = sy-mandt je_id = 'JE-000001' item_pos = 10 gl_account = '100' debit_credit = 'S' amount = '50000.00' cost_center = 'CC-ADMIN' item_text = 'Kasa girişi'  currency_code = 'TRY' )
      ( client = sy-mandt je_id = 'JE-000001' item_pos = 20 gl_account = '102' debit_credit = 'H' amount = '50000.00' cost_center = 'CC-ADMIN' item_text = 'Banka çıkışı' currency_code = 'TRY' )
    ).
    INSERT zpal_je_item FROM TABLE @lt_item.

    out->write( |{ lines( lt_head ) } muhasebe fişi eklendi.| ).

  ENDMETHOD.
ENDCLASS.

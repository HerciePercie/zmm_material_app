CLASS zpal_cl_seed_movetype DEFINITION
  PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.

CLASS zpal_cl_seed_movetype IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    DELETE FROM zpal_move_type.

    DATA lt TYPE STANDARD TABLE OF zpal_move_type.
    lt = VALUE #(
      ( client = sy-mandt mov_type = '101' description = 'Depo Girişi (Mal Kabul)'  direction = '+' )
      ( client = sy-mandt mov_type = '102' description = 'Depo Giriş İptali'         direction = '-' )
      ( client = sy-mandt mov_type = '131' description = 'Üretimden Mamul Girişi'    direction = '+' )
      ( client = sy-mandt mov_type = '201' description = 'Satış Çıkışı (Sevkiyat)'   direction = '-' )
      ( client = sy-mandt mov_type = '202' description = 'Satış Çıkış İptali'        direction = '+' )
      ( client = sy-mandt mov_type = '261' description = 'Üretim Sarfiyatı (Bileşen)' direction = '-' )
      ( client = sy-mandt mov_type = '301' description = 'Depolar Arası Transfer'    direction = ' ' )
      ( client = sy-mandt mov_type = '561' description = 'Başlangıç Stok Girişi'     direction = '+' )
    ).
    INSERT zpal_move_type FROM TABLE @lt.

    out->write( |{ lines( lt ) } hareket türü eklendi.| ).

  ENDMETHOD.
ENDCLASS.

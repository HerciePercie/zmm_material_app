CLASS zpal_cl_seed_costcenter DEFINITION
  PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.

CLASS zpal_cl_seed_costcenter IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    DELETE FROM zpal_cost_center.

    DATA lt TYPE STANDARD TABLE OF zpal_cost_center.
    lt = VALUE #(
      ( client = sy-mandt cost_center = 'CC-PROD'  description = 'Üretim' )
      ( client = sy-mandt cost_center = 'CC-SALES' description = 'Satış ve Pazarlama' )
      ( client = sy-mandt cost_center = 'CC-WHSE'  description = 'Depo ve Lojistik' )
      ( client = sy-mandt cost_center = 'CC-ADMIN' description = 'Genel Yönetim' )
    ).
    INSERT zpal_cost_center FROM TABLE @lt.

    out->write( |{ lines( lt ) } masraf yeri eklendi.| ).

  ENDMETHOD.
ENDCLASS.

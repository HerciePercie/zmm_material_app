CLASS zpal_cl_seed_prod DEFINITION
  PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.

CLASS zpal_cl_seed_prod IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    DELETE FROM zpal_prod_ord.

    DATA lt TYPE STANDARD TABLE OF zpal_prod_ord.
    lt = VALUE #(
      ( client = sy-mandt prod_id = 'PRD-0001' product_mat = 'MAT-2001' order_qty = 20 order_unit = 'ST' prod_status = '01' header_text = 'Polo T-Shirt üretim partisi' )
      ( client = sy-mandt prod_id = 'PRD-0002' product_mat = 'MAT-2002' order_qty = 5  order_unit = 'ST' prod_status = '01' header_text = 'Blazer üretim partisi' )
    ).
    INSERT zpal_prod_ord FROM TABLE @lt.

    out->write( |{ lines( lt ) } üretim emri eklendi.| ).

  ENDMETHOD.
ENDCLASS.

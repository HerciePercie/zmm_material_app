CLASS zpal_cl_seed_bom DEFINITION
  PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.

CLASS zpal_cl_seed_bom IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    DELETE FROM zpal_bom_head.
    DELETE FROM zpal_bom_item.

    DATA lt_head TYPE STANDARD TABLE OF zpal_bom_head.
    lt_head = VALUE #(
      ( client = sy-mandt bom_id = 'BOM-0001' product_mat = 'MAT-2001' base_qty = 1 base_unit = 'ST' header_text = 'Slim Fit Polo T-Shirt Reçetesi' )
      ( client = sy-mandt bom_id = 'BOM-0002' product_mat = 'MAT-2002' base_qty = 1 base_unit = 'ST' header_text = 'Premium Blazer Ceket Reçetesi' )
    ).
    INSERT zpal_bom_head FROM TABLE @lt_head.

    DATA lt_item TYPE STANDARD TABLE OF zpal_bom_item.
    lt_item = VALUE #(
      ( client = sy-mandt bom_id = 'BOM-0001' item_pos = 10 component_mat = 'MAT-1001' quantity = '1.500' unit = 'M'  )
      ( client = sy-mandt bom_id = 'BOM-0001' item_pos = 20 component_mat = 'MAT-1002' quantity = 4       unit = 'ST' )
      ( client = sy-mandt bom_id = 'BOM-0002' item_pos = 10 component_mat = 'MAT-1001' quantity = 3       unit = 'M'  )
      ( client = sy-mandt bom_id = 'BOM-0002' item_pos = 20 component_mat = 'MAT-1002' quantity = 8       unit = 'ST' )
    ).
    INSERT zpal_bom_item FROM TABLE @lt_item.

    out->write( |{ lines( lt_head ) } reçete, { lines( lt_item ) } bileşen eklendi.| ).

  ENDMETHOD.
ENDCLASS.

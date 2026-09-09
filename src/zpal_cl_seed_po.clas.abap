CLASS zpal_cl_seed_po DEFINITION
  PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.

CLASS zpal_cl_seed_po IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    DELETE FROM zpal_po_head.
    DELETE FROM zpal_po_item.

    DATA lt_head TYPE STANDARD TABLE OF zpal_po_head.
    lt_head = VALUE #(
      ( client = sy-mandt po_id = 'PO-9001' vendor_id = 'VEN-0001' vendor_name = 'Bursa Tekstil Kumaş San.'
        order_date = sy-datum total_amount = '60000.00' currency_code = 'TRY' po_status = '01' )
      ( client = sy-mandt po_id = 'PO-9002' vendor_id = 'VEN-0002' vendor_name = 'Güven Metal Aksesuar Ltd.'
        order_date = sy-datum total_amount = '15000.00' currency_code = 'TRY' po_status = '01' )
    ).
    INSERT zpal_po_head FROM TABLE @lt_head.

    DATA lt_item TYPE STANDARD TABLE OF zpal_po_item.
    lt_item = VALUE #(
      ( client = sy-mandt po_id = 'PO-9001' item_pos = 10 mat_id = 'MAT-1001' quantity = 500  unit = 'M'  unit_price = '120.00' net_amount = '60000.00' currency_code = 'TRY' )
      ( client = sy-mandt po_id = 'PO-9002' item_pos = 10 mat_id = 'MAT-1002' quantity = 1000 unit = 'ST' unit_price = '15.00'  net_amount = '15000.00' currency_code = 'TRY' )
    ).
    INSERT zpal_po_item FROM TABLE @lt_item.

    out->write( |{ lines( lt_head ) } satın alma siparişi, { lines( lt_item ) } kalem eklendi.| ).

  ENDMETHOD.
ENDCLASS.

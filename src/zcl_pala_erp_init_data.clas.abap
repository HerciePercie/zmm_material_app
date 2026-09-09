CLASS zcl_pala_erp_init_data DEFINITION
  PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.

CLASS zcl_pala_erp_init_data IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    DELETE FROM zpal_customer.
    DELETE FROM zmm_mat_master.
    DELETE FROM zmm_stock_mov.
    DELETE FROM ztsd_so_head.
    DELETE FROM ztsd_so_item.

    DATA(lv_ts) = utclong_current( ).

    " --- Müşteri ana verisi ---
    DATA lt_cust TYPE STANDARD TABLE OF zpal_customer.
    lt_cust = VALUE #(
      ( client = sy-mandt customer_id = 'CUST-0001' name = 'LC Waikiki Mağazacılık'
        tax_number = '1234567890' customer_group = 'RETL' email = 'satinalma@lcw.com'
        phone = '+90 212 000 0001' street = 'Organize Sanayi Bölgesi No:12'
        city = 'İstanbul' postal_code = '34000' country = 'TR' order_block = abap_false )
      ( client = sy-mandt customer_id = 'CUST-0002' name = 'Defacto Perakende A.Ş.'
        tax_number = '2345678901' customer_group = 'RETL' email = 'tedarik@defacto.com'
        phone = '+90 232 000 0002' street = 'Atatürk Cad. Moda Plaza K:4'
        city = 'İzmir' postal_code = '35000' country = 'TR' order_block = abap_false )
      ( client = sy-mandt customer_id = 'CUST-0003' name = 'Mavi Giyim Sanayi'
        tax_number = '3456789012' customer_group = 'WHOL' email = 'siparis@mavi.com'
        phone = '+90 216 000 0003' street = 'Bağdat Caddesi No:88 Kadıköy'
        city = 'İstanbul' postal_code = '34710' country = 'TR' order_block = abap_true )
    ).
    INSERT zpal_customer FROM TABLE @lt_cust.
    out->write( |[Ana Veri] { lines( lt_cust ) } müşteri.| ).

    " --- Malzeme ana verisi ---
    DATA lt_mat TYPE STANDARD TABLE OF zmm_mat_master.
    lt_mat = VALUE #(
      ( client = sy-mandt mat_id = 'MAT-1001' mat_desc = 'Pamuklu Kumaş Topu'    mat_type = 'ROH'  base_unit = 'M'  stock_qty = 500  unit_price = '120.00'  currency = 'TRY' created_by = sy-uname created_at = lv_ts last_changed_at = lv_ts )
      ( client = sy-mandt mat_id = 'MAT-1002' mat_desc = 'Metal Düğme Paketi'    mat_type = 'ROH'  base_unit = 'ST' stock_qty = 2000 unit_price = '15.00'   currency = 'TRY' created_by = sy-uname created_at = lv_ts last_changed_at = lv_ts )
      ( client = sy-mandt mat_id = 'MAT-2001' mat_desc = 'Slim Fit Polo T-Shirt' mat_type = 'FERT' base_unit = 'ST' stock_qty = 150  unit_price = '450.00'  currency = 'TRY' created_by = sy-uname created_at = lv_ts last_changed_at = lv_ts )
      ( client = sy-mandt mat_id = 'MAT-2002' mat_desc = 'Premium Blazer Ceket'  mat_type = 'FERT' base_unit = 'ST' stock_qty = 60   unit_price = '2200.00' currency = 'TRY' created_by = sy-uname created_at = lv_ts last_changed_at = lv_ts )
    ).
    INSERT zmm_mat_master FROM TABLE @lt_mat.
    out->write( |[Ana Veri] { lines( lt_mat ) } malzeme.| ).

    " --- Stok hareketleri (101 giriş) ---
    DATA lt_mov TYPE STANDARD TABLE OF zmm_stock_mov.
    lt_mov = VALUE #(
      ( client = sy-mandt mov_id = 'MOV-000001' mat_id = 'MAT-2001' mov_type = '101' quantity = 150 unit = 'ST' doc_ref = 'INIT' created_by = sy-uname created_at = lv_ts )
      ( client = sy-mandt mov_id = 'MOV-000002' mat_id = 'MAT-2002' mov_type = '101' quantity = 60  unit = 'ST' doc_ref = 'INIT' created_by = sy-uname created_at = lv_ts )
    ).
    INSERT zmm_stock_mov FROM TABLE @lt_mov.
    out->write( |[Hareket] { lines( lt_mov ) } stok hareketi.| ).

    " --- Satış siparişi başlıkları (müşteriye bağlı) ---
    DATA lt_head TYPE STANDARD TABLE OF ztsd_so_head.
    lt_head = VALUE #(
      ( client = sy-mandt sales_order_id = 'SO-1001' customer_id = 'CUST-0001' customer_name = 'LC Waikiki Mağazacılık'
        order_date = sy-datum total_amount = '13500.00' currency_code = 'TRY' order_status = '01'
        delivery_address = 'Organize Sanayi Bölgesi No:12, İstanbul' )
      ( client = sy-mandt sales_order_id = 'SO-1002' customer_id = 'CUST-0002' customer_name = 'Defacto Perakende A.Ş.'
        order_date = sy-datum total_amount = '22000.00' currency_code = 'TRY' order_status = '01'
        delivery_address = 'Atatürk Cad. Moda Plaza K:4, İzmir' )
    ).
    INSERT ztsd_so_head FROM TABLE @lt_head.

    " --- Satış siparişi kalemleri ---
    DATA lt_item TYPE STANDARD TABLE OF ztsd_so_item.
    lt_item = VALUE #(
      ( client = sy-mandt sales_order_id = 'SO-1001' item_pos = 10 mat_id = 'MAT-2001' quantity = 30 unit = 'ST' unit_price = '450.00'  net_amount = '13500.00' currency_code = 'TRY' )
      ( client = sy-mandt sales_order_id = 'SO-1002' item_pos = 10 mat_id = 'MAT-2002' quantity = 10 unit = 'ST' unit_price = '2200.00' net_amount = '22000.00' currency_code = 'TRY' )
    ).
    INSERT ztsd_so_item FROM TABLE @lt_item.
    out->write( |[Hareket] { lines( lt_head ) } sipariş, { lines( lt_item ) } kalem.| ).

  ENDMETHOD.
ENDCLASS.

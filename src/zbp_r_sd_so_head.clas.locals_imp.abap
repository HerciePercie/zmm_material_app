CLASS lhc_SalesOrder DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR SalesOrder RESULT result.

    METHODS approveOrder FOR MODIFY
      IMPORTING keys FOR ACTION SalesOrder~approveOrder RESULT result.

    METHODS cancelOrder FOR MODIFY
      IMPORTING keys FOR ACTION SalesOrder~cancelOrder RESULT result.

    METHODS shipOrder FOR MODIFY
      IMPORTING keys FOR ACTION SalesOrder~shipOrder RESULT result.

    METHODS calculateTotalAmount FOR DETERMINE ON SAVE
      IMPORTING keys FOR SalesOrder~calculateTotalAmount.

    METHODS validateApproval FOR VALIDATE ON SAVE
      IMPORTING keys FOR SalesOrder~validateApproval.
ENDCLASS.

CLASS lhc_SalesOrder IMPLEMENTATION.

  METHOD get_instance_authorizations.

    READ ENTITIES OF zr_sd_so_head IN LOCAL MODE
      ENTITY SalesOrder
        FIELDS ( OrderStatus )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_orders).

    LOOP AT keys INTO DATA(ls_key).
      READ TABLE lt_orders INTO DATA(ls_order) WITH KEY %tky = ls_key-%tky.

      result = VALUE #( BASE result (
        %tky                 = ls_key-%tky
        %update              = if_abap_behv=>auth-allowed
        %delete              = if_abap_behv=>auth-allowed
        %action-approveOrder = COND #( WHEN ls_order-OrderStatus = '01'
                                       THEN if_abap_behv=>auth-allowed ELSE if_abap_behv=>auth-unauthorized )
        %action-shipOrder    = COND #( WHEN ls_order-OrderStatus = '02'
                                       THEN if_abap_behv=>auth-allowed ELSE if_abap_behv=>auth-unauthorized )
        %action-cancelOrder  = COND #( WHEN ls_order-OrderStatus = '01' OR ls_order-OrderStatus = '02'
                                       THEN if_abap_behv=>auth-allowed ELSE if_abap_behv=>auth-unauthorized )
      ) ).
    ENDLOOP.

  ENDMETHOD.

  METHOD approveOrder.
    MODIFY ENTITIES OF zr_sd_so_head IN LOCAL MODE
      ENTITY SalesOrder
        UPDATE FIELDS ( OrderStatus )
        WITH VALUE #( FOR key IN keys (
          %tky        = key-%tky
          OrderStatus = '02'
        ) ).

    READ ENTITIES OF zr_sd_so_head IN LOCAL MODE
      ENTITY SalesOrder
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_updated_orders).

    result = VALUE #( FOR updated_order IN lt_updated_orders (
      %tky   = updated_order-%tky
      %param = updated_order
    ) ).
  ENDMETHOD.

  METHOD cancelOrder.
    MODIFY ENTITIES OF zr_sd_so_head IN LOCAL MODE
      ENTITY SalesOrder
        UPDATE FIELDS ( OrderStatus )
        WITH VALUE #( FOR key IN keys (
          %tky        = key-%tky
          OrderStatus = '04'
        ) ).

    READ ENTITIES OF zr_sd_so_head IN LOCAL MODE
      ENTITY SalesOrder
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_updated_orders).

    result = VALUE #( FOR updated_order IN lt_updated_orders (
      %tky   = updated_order-%tky
      %param = updated_order
    ) ).
  ENDMETHOD.

    METHOD shipOrder.

    LOOP AT keys INTO DATA(ls_key).
      MODIFY ENTITIES OF zr_sd_so_head IN LOCAL MODE
        ENTITY SalesOrder
          UPDATE FIELDS ( ShippingCarrier TrackingNumber OrderStatus )
          WITH VALUE #( (
            %tky            = ls_key-%tky
            ShippingCarrier = ls_key-%param-shipping_carrier
            TrackingNumber  = ls_key-%param-tracking_number
            OrderStatus     = '03'
          ) ).
    ENDLOOP.

    READ ENTITIES OF zr_sd_so_head IN LOCAL MODE
      ENTITY SalesOrder
        FIELDS ( SalesOrderId TotalAmount CurrencyCode )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_orders).

    READ ENTITIES OF zr_sd_so_head IN LOCAL MODE
      ENTITY SalesOrder BY \_Items
        FROM VALUE #( FOR key IN keys ( %tky = key-%tky ) )
      LINK DATA(lt_links)
      RESULT DATA(lt_item_keys).

    READ ENTITIES OF zr_sd_so_head IN LOCAL MODE
      ENTITY OrderItem
        FIELDS ( MatId Quantity Unit )
        WITH CORRESPONDING #( lt_item_keys )
      RESULT DATA(lt_items).

    LOOP AT keys INTO ls_key.
      READ TABLE lt_orders INTO DATA(ls_order) WITH KEY %tky = ls_key-%tky.

      " --- MM stok düşümü (201) ---
      LOOP AT lt_links INTO DATA(ls_link) WHERE source = ls_key-%tky.
        READ TABLE lt_items INTO DATA(ls_item) WITH KEY %tky = ls_link-target.
        IF sy-subrc = 0.
          MODIFY ENTITIES OF zi_mm_material
            ENTITY Material
              EXECUTE postGoodsMovement
                FROM VALUE #( ( %tky   = VALUE #( MatId = ls_item-MatId )
                                %param = VALUE #( mov_type = '201'
                                                   quantity = ls_item-Quantity
                                                   unit     = ls_item-Unit
                                                   doc_ref  = ls_order-SalesOrderId ) ) )
            RESULT DATA(lt_pgm_result)
            FAILED DATA(lt_pgm_failed)
            REPORTED DATA(lt_pgm_reported).
        ENDIF.
      ENDLOOP.

      " --- Otomatik muhasebe fişi: Borç 120 Alıcılar / Alacak 600 Satışlar ---
      IF ls_order-TotalAmount > 0.
        MODIFY ENTITIES OF zpal_i_je_head
          ENTITY JournalEntry
            EXECUTE postAuto
              FROM VALUE #( ( %cid   = |JESD_{ sy-tabix }|
                              %param = VALUE #( doc_type       = 'SD'
                                                reference      = ls_order-SalesOrderId
                                                header_text    = |Satis sevkiyati - { ls_order-SalesOrderId }|
                                                debit_account  = '120'
                                                credit_account = '600'
                                                amount         = ls_order-TotalAmount
                                                currency       = ls_order-CurrencyCode
                                                cost_center    = 'CC-SALES' ) ) )
          REPORTED DATA(lt_je_rep)
          FAILED   DATA(lt_je_fail).
      ENDIF.

    ENDLOOP.

    READ ENTITIES OF zr_sd_so_head IN LOCAL MODE
      ENTITY SalesOrder
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_updated_orders).

    result = VALUE #( FOR updated_order IN lt_updated_orders (
      %tky   = updated_order-%tky
      %param = updated_order
    ) ).
  ENDMETHOD.

  METHOD calculateTotalAmount.

    READ ENTITIES OF zr_sd_so_head IN LOCAL MODE
      ENTITY SalesOrder BY \_Items
        FROM VALUE #( FOR key IN keys ( %tky = key-%tky ) )
      LINK DATA(lt_links)
      RESULT DATA(lt_item_keys).

    READ ENTITIES OF zr_sd_so_head IN LOCAL MODE
      ENTITY OrderItem
        FIELDS ( NetAmount )
        WITH CORRESPONDING #( lt_item_keys )
      RESULT DATA(lt_items).

    DATA lt_head_update TYPE TABLE FOR UPDATE zr_sd_so_head.

    LOOP AT keys INTO DATA(ls_key).
      DATA(lv_total) = CONV ztsd_so_head-total_amount( 0 ).

      LOOP AT lt_links INTO DATA(ls_link) WHERE source = ls_key-%tky.
        READ TABLE lt_items INTO DATA(ls_item) WITH KEY %tky = ls_link-target.
        IF sy-subrc = 0.
          lv_total += ls_item-NetAmount.
        ENDIF.
      ENDLOOP.

      lt_head_update = VALUE #( BASE lt_head_update ( %tky = ls_key-%tky TotalAmount = lv_total ) ).
    ENDLOOP.

    MODIFY ENTITIES OF zr_sd_so_head IN LOCAL MODE
      ENTITY SalesOrder
        UPDATE FIELDS ( TotalAmount )
        WITH lt_head_update.

  ENDMETHOD.

  METHOD validateApproval.

    READ ENTITIES OF zr_sd_so_head IN LOCAL MODE
      ENTITY SalesOrder
        FIELDS ( CustomerId OrderStatus )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_orders).

    LOOP AT lt_orders INTO DATA(ls_order) WHERE OrderStatus = '02'.

      IF ls_order-CustomerId IS NOT INITIAL.
        READ ENTITIES OF zpal_i_customer
          ENTITY Customer
            FIELDS ( OrderBlock )
            WITH VALUE #( ( CustomerId = ls_order-CustomerId ) )
          RESULT DATA(lt_customers).

        READ TABLE lt_customers INTO DATA(ls_customer) INDEX 1.
        IF sy-subrc = 0 AND ls_customer-OrderBlock = abap_true.
          APPEND VALUE #( %tky = ls_order-%tky ) TO failed-salesorder.
          APPEND VALUE #( %tky = ls_order-%tky
                          %msg = new_message_with_text(
                                   severity = if_abap_behv_message=>severity-error
                                   text = |Müşteri { ls_order-CustomerId } sipariş bloklu, onaylanamaz.| ) )
                 TO reported-salesorder.
          CONTINUE.
        ENDIF.
      ENDIF.

      READ ENTITIES OF zr_sd_so_head IN LOCAL MODE
        ENTITY SalesOrder BY \_Items
          FROM VALUE #( ( %tky = ls_order-%tky ) )
        LINK DATA(lt_links)
        RESULT DATA(lt_item_keys).

      READ ENTITIES OF zr_sd_so_head IN LOCAL MODE
        ENTITY OrderItem
          FIELDS ( MatId Quantity )
          WITH CORRESPONDING #( lt_item_keys )
        RESULT DATA(lt_items).

      LOOP AT lt_items INTO DATA(ls_item).
        READ ENTITIES OF zi_mm_material
          ENTITY Material
            FIELDS ( StockQty MatDesc )
            WITH VALUE #( ( MatId = ls_item-MatId ) )
          RESULT DATA(lt_materials).

        READ TABLE lt_materials INTO DATA(ls_material) INDEX 1.
        IF sy-subrc = 0 AND ls_material-StockQty < ls_item-Quantity.
          APPEND VALUE #( %tky = ls_order-%tky ) TO failed-salesorder.
          APPEND VALUE #( %tky = ls_order-%tky
                          %msg = new_message_with_text(
                                   severity = if_abap_behv_message=>severity-error
                                   text = |{ ls_material-MatDesc }: mevcut stok { ls_material-StockQty }, istenen { ls_item-Quantity } - yetersiz.| ) )
                 TO reported-salesorder.
        ENDIF.
      ENDLOOP.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.


CLASS lhc_OrderItem DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS calculateNetAmount FOR DETERMINE ON MODIFY
      IMPORTING keys FOR OrderItem~calculateNetAmount.
ENDCLASS.

CLASS lhc_OrderItem IMPLEMENTATION.

  METHOD calculateNetAmount.

    READ ENTITIES OF zr_sd_so_head IN LOCAL MODE
      ENTITY OrderItem
        FIELDS ( Quantity UnitPrice )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_items).

    MODIFY ENTITIES OF zr_sd_so_head IN LOCAL MODE
      ENTITY OrderItem
        UPDATE FIELDS ( NetAmount )
        WITH VALUE #( FOR item IN lt_items (
          %tky      = item-%tky
          NetAmount = item-Quantity * item-UnitPrice
        ) ).

  ENDMETHOD.

ENDCLASS.

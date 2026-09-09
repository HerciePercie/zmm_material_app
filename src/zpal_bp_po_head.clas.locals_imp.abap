
CLASS lhc_PurchaseOrder DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR PurchaseOrder RESULT result.

    METHODS approvePO FOR MODIFY
      IMPORTING keys FOR ACTION PurchaseOrder~approvePO RESULT result.

    METHODS cancelPO FOR MODIFY
      IMPORTING keys FOR ACTION PurchaseOrder~cancelPO RESULT result.

    METHODS receiveGoods FOR MODIFY
      IMPORTING keys FOR ACTION PurchaseOrder~receiveGoods RESULT result.

    METHODS calculateTotalAmount FOR DETERMINE ON SAVE
      IMPORTING keys FOR PurchaseOrder~calculateTotalAmount.

    METHODS validatePOApproval FOR VALIDATE ON SAVE
      IMPORTING keys FOR PurchaseOrder~validatePOApproval.
ENDCLASS.

CLASS lhc_PurchaseOrder IMPLEMENTATION.

  METHOD get_instance_authorizations.

    READ ENTITIES OF zpal_i_po_head IN LOCAL MODE
      ENTITY PurchaseOrder
        FIELDS ( PoStatus )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_pos).

    LOOP AT keys INTO DATA(ls_key).
      READ TABLE lt_pos INTO DATA(ls_po) WITH KEY %tky = ls_key-%tky.

      result = VALUE #( BASE result (
        %tky                 = ls_key-%tky
        %update              = if_abap_behv=>auth-allowed
        %delete              = if_abap_behv=>auth-allowed
        %action-approvePO    = COND #( WHEN ls_po-PoStatus = '01'
                                       THEN if_abap_behv=>auth-allowed ELSE if_abap_behv=>auth-unauthorized )
        %action-receiveGoods = COND #( WHEN ls_po-PoStatus = '02'
                                       THEN if_abap_behv=>auth-allowed ELSE if_abap_behv=>auth-unauthorized )
        %action-cancelPO     = COND #( WHEN ls_po-PoStatus = '01' OR ls_po-PoStatus = '02'
                                       THEN if_abap_behv=>auth-allowed ELSE if_abap_behv=>auth-unauthorized )
      ) ).
    ENDLOOP.

  ENDMETHOD.

  METHOD approvePO.
    MODIFY ENTITIES OF zpal_i_po_head IN LOCAL MODE
      ENTITY PurchaseOrder
        UPDATE FIELDS ( PoStatus )
        WITH VALUE #( FOR key IN keys ( %tky = key-%tky PoStatus = '02' ) ).

    READ ENTITIES OF zpal_i_po_head IN LOCAL MODE
      ENTITY PurchaseOrder
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_updated).

    result = VALUE #( FOR po IN lt_updated ( %tky = po-%tky %param = po ) ).
  ENDMETHOD.

  METHOD cancelPO.
    MODIFY ENTITIES OF zpal_i_po_head IN LOCAL MODE
      ENTITY PurchaseOrder
        UPDATE FIELDS ( PoStatus )
        WITH VALUE #( FOR key IN keys ( %tky = key-%tky PoStatus = '04' ) ).

    READ ENTITIES OF zpal_i_po_head IN LOCAL MODE
      ENTITY PurchaseOrder
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_updated).

    result = VALUE #( FOR po IN lt_updated ( %tky = po-%tky %param = po ) ).
  ENDMETHOD.

   METHOD receiveGoods.

    MODIFY ENTITIES OF zpal_i_po_head IN LOCAL MODE
      ENTITY PurchaseOrder
        UPDATE FIELDS ( PoStatus )
        WITH VALUE #( FOR key IN keys ( %tky = key-%tky PoStatus = '03' ) ).

    READ ENTITIES OF zpal_i_po_head IN LOCAL MODE
      ENTITY PurchaseOrder
        FIELDS ( PoId TotalAmount CurrencyCode )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_pos).

    READ ENTITIES OF zpal_i_po_head IN LOCAL MODE
      ENTITY PurchaseOrder BY \_Items
        FROM VALUE #( FOR key IN keys ( %tky = key-%tky ) )
      LINK DATA(lt_links)
      RESULT DATA(lt_item_keys).

    READ ENTITIES OF zpal_i_po_head IN LOCAL MODE
      ENTITY PurchaseOrderItem
        FIELDS ( MatId Quantity Unit )
        WITH CORRESPONDING #( lt_item_keys )
      RESULT DATA(lt_items).

    LOOP AT keys INTO DATA(ls_key).
      READ TABLE lt_pos INTO DATA(ls_po) WITH KEY %tky = ls_key-%tky.

      " --- MM stok artışı (101) ---
      LOOP AT lt_links INTO DATA(ls_link) WHERE source = ls_key-%tky.
        READ TABLE lt_items INTO DATA(ls_item) WITH KEY %tky = ls_link-target.
        IF sy-subrc = 0.
          MODIFY ENTITIES OF zi_mm_material
            ENTITY Material
              EXECUTE postGoodsMovement
                FROM VALUE #( ( %tky   = VALUE #( MatId = ls_item-MatId )
                                %param = VALUE #( mov_type = '101'
                                                   quantity = ls_item-Quantity
                                                   unit     = ls_item-Unit
                                                   doc_ref  = ls_po-PoId ) ) )
            RESULT DATA(lt_pgm_result)
            FAILED DATA(lt_pgm_failed)
            REPORTED DATA(lt_pgm_reported).
        ENDIF.
      ENDLOOP.

      " --- Otomatik muhasebe fişi: Borç 150 Stok / Alacak 320 Satıcılar ---
      IF ls_po-TotalAmount > 0.
        MODIFY ENTITIES OF zpal_i_je_head
          ENTITY JournalEntry
            EXECUTE postAuto
              FROM VALUE #( ( %cid   = |JEPO_{ sy-tabix }|
                              %param = VALUE #( doc_type       = 'PO'
                                                reference      = ls_po-PoId
                                                header_text    = |Mal kabul - { ls_po-PoId }|
                                                debit_account  = '150'
                                                credit_account = '320'
                                                amount         = ls_po-TotalAmount
                                                currency       = ls_po-CurrencyCode
                                                cost_center    = 'CC-WHSE' ) ) )
          REPORTED DATA(lt_je_rep)
          FAILED   DATA(lt_je_fail).
      ENDIF.

    ENDLOOP.

    READ ENTITIES OF zpal_i_po_head IN LOCAL MODE
      ENTITY PurchaseOrder
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_updated).

    result = VALUE #( FOR po IN lt_updated ( %tky = po-%tky %param = po ) ).
  ENDMETHOD.

  METHOD calculateTotalAmount.

    READ ENTITIES OF zpal_i_po_head IN LOCAL MODE
      ENTITY PurchaseOrder BY \_Items
        FROM VALUE #( FOR key IN keys ( %tky = key-%tky ) )
      LINK DATA(lt_links)
      RESULT DATA(lt_item_keys).

    READ ENTITIES OF zpal_i_po_head IN LOCAL MODE
      ENTITY PurchaseOrderItem
        FIELDS ( NetAmount )
        WITH CORRESPONDING #( lt_item_keys )
      RESULT DATA(lt_items).

    DATA lt_head_update TYPE TABLE FOR UPDATE zpal_i_po_head.

    LOOP AT keys INTO DATA(ls_key).
      DATA(lv_total) = CONV zpal_po_head-total_amount( 0 ).

      LOOP AT lt_links INTO DATA(ls_link) WHERE source = ls_key-%tky.
        READ TABLE lt_items INTO DATA(ls_item) WITH KEY %tky = ls_link-target.
        IF sy-subrc = 0.
          lv_total += ls_item-NetAmount.
        ENDIF.
      ENDLOOP.

      lt_head_update = VALUE #( BASE lt_head_update ( %tky = ls_key-%tky TotalAmount = lv_total ) ).
    ENDLOOP.

    MODIFY ENTITIES OF zpal_i_po_head IN LOCAL MODE
      ENTITY PurchaseOrder
        UPDATE FIELDS ( TotalAmount )
        WITH lt_head_update.

  ENDMETHOD.

  METHOD validatePOApproval.

    READ ENTITIES OF zpal_i_po_head IN LOCAL MODE
      ENTITY PurchaseOrder
        FIELDS ( VendorId PoStatus )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_pos).

    LOOP AT lt_pos INTO DATA(ls_po) WHERE PoStatus = '02'.

      IF ls_po-VendorId IS NOT INITIAL.
        READ ENTITIES OF zpal_i_vendor
          ENTITY Vendor
            FIELDS ( PurchaseBlock )
            WITH VALUE #( ( VendorId = ls_po-VendorId ) )
          RESULT DATA(lt_vendors).

        READ TABLE lt_vendors INTO DATA(ls_vendor) INDEX 1.
        IF sy-subrc = 0 AND ls_vendor-PurchaseBlock = abap_true.
          APPEND VALUE #( %tky = ls_po-%tky ) TO failed-purchaseorder.
          APPEND VALUE #( %tky = ls_po-%tky
                          %msg = new_message_with_text(
                                   severity = if_abap_behv_message=>severity-error
                                   text = |Tedarikçi { ls_po-VendorId } satın alma bloklu, onaylanamaz.| ) )
                 TO reported-purchaseorder.
        ENDIF.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.


CLASS lhc_PoItem DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS calculateNetAmount FOR DETERMINE ON MODIFY
      IMPORTING keys FOR PurchaseOrderItem~calculateNetAmount.
ENDCLASS.

CLASS lhc_PoItem IMPLEMENTATION.

  METHOD calculateNetAmount.

    READ ENTITIES OF zpal_i_po_head IN LOCAL MODE
      ENTITY PurchaseOrderItem
        FIELDS ( Quantity UnitPrice )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_items).

    MODIFY ENTITIES OF zpal_i_po_head IN LOCAL MODE
      ENTITY PurchaseOrderItem
        UPDATE FIELDS ( NetAmount )
        WITH VALUE #( FOR item IN lt_items (
          %tky      = item-%tky
          NetAmount = item-Quantity * item-UnitPrice
        ) ).

  ENDMETHOD.

ENDCLASS.

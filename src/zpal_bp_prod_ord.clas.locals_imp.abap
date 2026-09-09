CLASS lhc_ProductionOrder DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR ProductionOrder RESULT result.

    METHODS confirmProduction FOR MODIFY
      IMPORTING keys FOR ACTION ProductionOrder~confirmProduction RESULT result.

    METHODS cancelProduction FOR MODIFY
      IMPORTING keys FOR ACTION ProductionOrder~cancelProduction RESULT result.

    METHODS validateComponents FOR VALIDATE ON SAVE
      IMPORTING keys FOR ProductionOrder~validateComponents.
ENDCLASS.

CLASS lhc_ProductionOrder IMPLEMENTATION.

  METHOD get_instance_authorizations.
    result = VALUE #( FOR key IN keys (
      %tky                      = key-%tky
      %update                   = if_abap_behv=>auth-allowed
      %delete                   = if_abap_behv=>auth-allowed
      %action-confirmProduction = if_abap_behv=>auth-allowed
      %action-cancelProduction  = if_abap_behv=>auth-allowed
    ) ).
  ENDMETHOD.

  METHOD confirmProduction.

    DATA lv_factor  TYPE decfloat34.
    DATA lv_consume TYPE zpal_bom_item-quantity.

    READ ENTITIES OF zpal_i_prod_ord IN LOCAL MODE
      ENTITY ProductionOrder
        FIELDS ( ProdId ProductMat OrderQty OrderUnit )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_orders).

    LOOP AT lt_orders INTO DATA(ls_ord).

      SELECT SINGLE bom_id, base_qty FROM zpal_bom_head
        WHERE product_mat = @ls_ord-ProductMat
        INTO ( @DATA(lv_bom_id), @DATA(lv_base_qty) ).
      IF sy-subrc <> 0 OR lv_base_qty = 0.
        CONTINUE.
      ENDIF.

      lv_factor = ls_ord-OrderQty / lv_base_qty.

      " --- Bileşenleri sarf et (261) ---
      SELECT component_mat, quantity, unit FROM zpal_bom_item
        WHERE bom_id = @lv_bom_id
        INTO TABLE @DATA(lt_comps).

      LOOP AT lt_comps INTO DATA(ls_comp).
        lv_consume = ls_comp-quantity * lv_factor.

        MODIFY ENTITIES OF zi_mm_material
          ENTITY Material
            EXECUTE postGoodsMovement
              FROM VALUE #( ( %tky   = VALUE #( MatId = ls_comp-component_mat )
                              %param = VALUE #( mov_type = '261'
                                                 quantity = lv_consume
                                                 unit     = ls_comp-unit
                                                 doc_ref  = ls_ord-ProdId ) ) )
          RESULT DATA(lt_r1) FAILED DATA(lt_f1) REPORTED DATA(lt_rep1).
      ENDLOOP.

      " --- Mamulü üret (131) ---
      MODIFY ENTITIES OF zi_mm_material
        ENTITY Material
          EXECUTE postGoodsMovement
            FROM VALUE #( ( %tky   = VALUE #( MatId = ls_ord-ProductMat )
                            %param = VALUE #( mov_type = '131'
                                               quantity = ls_ord-OrderQty
                                               unit     = ls_ord-OrderUnit
                                               doc_ref  = ls_ord-ProdId ) ) )
        RESULT DATA(lt_r2) FAILED DATA(lt_f2) REPORTED DATA(lt_rep2).

      " --- Durumu tamamlandı yap ---
      MODIFY ENTITIES OF zpal_i_prod_ord IN LOCAL MODE
        ENTITY ProductionOrder
          UPDATE FIELDS ( ProdStatus )
          WITH VALUE #( ( %tky = ls_ord-%tky ProdStatus = '02' ) ).

    ENDLOOP.

    READ ENTITIES OF zpal_i_prod_ord IN LOCAL MODE
      ENTITY ProductionOrder
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_updated).

    result = VALUE #( FOR o IN lt_updated ( %tky = o-%tky %param = o ) ).

  ENDMETHOD.

  METHOD cancelProduction.

    MODIFY ENTITIES OF zpal_i_prod_ord IN LOCAL MODE
      ENTITY ProductionOrder
        UPDATE FIELDS ( ProdStatus )
        WITH VALUE #( FOR key IN keys ( %tky = key-%tky ProdStatus = '03' ) ).

    READ ENTITIES OF zpal_i_prod_ord IN LOCAL MODE
      ENTITY ProductionOrder
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_updated).

    result = VALUE #( FOR o IN lt_updated ( %tky = o-%tky %param = o ) ).

  ENDMETHOD.

  METHOD validateComponents.

    DATA lv_factor TYPE decfloat34.
    DATA lv_needed TYPE zpal_bom_item-quantity.

    READ ENTITIES OF zpal_i_prod_ord IN LOCAL MODE
      ENTITY ProductionOrder
        FIELDS ( ProductMat OrderQty ProdStatus )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_orders).

    LOOP AT lt_orders INTO DATA(ls_ord) WHERE ProdStatus = '02'.

      SELECT SINGLE bom_id, base_qty FROM zpal_bom_head
        WHERE product_mat = @ls_ord-ProductMat
        INTO ( @DATA(lv_bom_id), @DATA(lv_base_qty) ).

      IF sy-subrc <> 0 OR lv_base_qty = 0.
        APPEND VALUE #( %tky = ls_ord-%tky ) TO failed-productionorder.
        APPEND VALUE #( %tky = ls_ord-%tky
                        %msg = new_message_with_text(
                                 severity = if_abap_behv_message=>severity-error
                                 text = |{ ls_ord-ProductMat } için ürün reçetesi yok - üretim yapılamaz.| ) )
               TO reported-productionorder.
        CONTINUE.
      ENDIF.

      lv_factor = ls_ord-OrderQty / lv_base_qty.

      SELECT component_mat, quantity FROM zpal_bom_item
        WHERE bom_id = @lv_bom_id
        INTO TABLE @DATA(lt_comps).

      LOOP AT lt_comps INTO DATA(ls_comp).
        lv_needed = ls_comp-quantity * lv_factor.

        READ ENTITIES OF zi_mm_material
          ENTITY Material
            FIELDS ( StockQty MatDesc )
            WITH VALUE #( ( MatId = ls_comp-component_mat ) )
          RESULT DATA(lt_mats).

        READ TABLE lt_mats INTO DATA(ls_mat) INDEX 1.
        IF sy-subrc = 0 AND ls_mat-StockQty < lv_needed.
          APPEND VALUE #( %tky = ls_ord-%tky ) TO failed-productionorder.
          APPEND VALUE #( %tky = ls_ord-%tky
                          %msg = new_message_with_text(
                                   severity = if_abap_behv_message=>severity-error
                                   text = |{ ls_mat-MatDesc }: mevcut { ls_mat-StockQty }, gereken { lv_needed } - üretim için yetersiz.| ) )
                 TO reported-productionorder.
        ENDIF.
      ENDLOOP.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

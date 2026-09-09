CLASS lhc_Material DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Material RESULT result.

    METHODS addStock FOR MODIFY
      IMPORTING keys FOR ACTION Material~addStock RESULT result.

    METHODS postGoodsMovement FOR MODIFY
      IMPORTING keys FOR ACTION Material~postGoodsMovement RESULT result.
ENDCLASS.

CLASS lhc_Material IMPLEMENTATION.

  METHOD get_instance_authorizations.
    result = VALUE #( FOR key IN keys (
      %tky                      = key-%tky
      %update                   = if_abap_behv=>auth-allowed
      %delete                   = if_abap_behv=>auth-allowed
      %action-addStock          = if_abap_behv=>auth-allowed
      %action-postGoodsMovement = if_abap_behv=>auth-allowed
    ) ).
  ENDMETHOD.

  METHOD addStock.

    READ ENTITIES OF zi_mm_material IN LOCAL MODE
      ENTITY Material
        FIELDS ( StockQty BaseUnit )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_materials).

    SELECT MAX( mov_id ) FROM zmm_stock_mov INTO @DATA(lv_last_mov).
    DATA(lv_seq) = COND i( WHEN lv_last_mov IS INITIAL
                           THEN 0
                           ELSE CONV i( substring( val = lv_last_mov off = 4 len = 6 ) ) ).

    DATA lt_mov_create TYPE TABLE FOR CREATE zi_mm_material\_StockMovements.

    LOOP AT keys INTO DATA(ls_key).

      READ TABLE lt_materials INTO DATA(ls_mat) WITH KEY %tky = ls_key-%tky.
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      DATA(lv_unit) = COND #( WHEN ls_key-%param-unit IS NOT INITIAL
                              THEN ls_key-%param-unit
                              ELSE ls_mat-BaseUnit ).

      MODIFY ENTITIES OF zi_mm_material IN LOCAL MODE
        ENTITY Material
          UPDATE FIELDS ( StockQty )
          WITH VALUE #( ( %tky     = ls_key-%tky
                          StockQty = ls_mat-StockQty + ls_key-%param-quantity ) ).

      lv_seq += 1.

      lt_mov_create = VALUE #( BASE lt_mov_create
        ( %tky   = ls_key-%tky
          %target = VALUE #(
            ( %cid      = |MOVCID_{ sy-tabix }|
              MovId     = |MOV-{ lv_seq WIDTH = 6 ALIGN = RIGHT PAD = '0' }|
              MovType   = '101'
              Quantity  = ls_key-%param-quantity
              Unit      = lv_unit
              DocRef    = 'ADDSTOCK' ) ) ) ).

    ENDLOOP.

    IF lt_mov_create IS NOT INITIAL.
      MODIFY ENTITIES OF zi_mm_material IN LOCAL MODE
        ENTITY Material
          CREATE BY \_StockMovements
            FIELDS ( MovId MovType Quantity Unit DocRef )
            WITH lt_mov_create
        REPORTED DATA(lt_reported)
        FAILED   DATA(lt_failed).
    ENDIF.

    READ ENTITIES OF zi_mm_material IN LOCAL MODE
      ENTITY Material
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_updated).

    result = VALUE #( FOR mat IN lt_updated ( %tky = mat-%tky %param = mat ) ).

  ENDMETHOD.

  METHOD postGoodsMovement.

    READ ENTITIES OF zi_mm_material IN LOCAL MODE
      ENTITY Material
        FIELDS ( StockQty BaseUnit )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_materials).

    SELECT MAX( mov_id ) FROM zmm_stock_mov INTO @DATA(lv_last_mov).
    DATA(lv_seq) = COND i( WHEN lv_last_mov IS INITIAL
                           THEN 0
                           ELSE CONV i( substring( val = lv_last_mov off = 4 len = 6 ) ) ).

    DATA lt_mov_create TYPE TABLE FOR CREATE zi_mm_material\_StockMovements.

    LOOP AT keys INTO DATA(ls_key).

      READ TABLE lt_materials INTO DATA(ls_mat) WITH KEY %tky = ls_key-%tky.
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      " Hareket türünün yönünü ana veriden oku — koda gömülü değil
      SELECT SINGLE direction FROM zpal_move_type
        WHERE mov_type = @ls_key-%param-mov_type
        INTO @DATA(lv_direction).
      IF sy-subrc <> 0.
        lv_direction = '+'.
      ENDIF.

      DATA lv_delta TYPE zmm_mat_master-stock_qty.
IF lv_direction = '-'.
  lv_delta = 0 - ls_key-%param-quantity.
ELSE.
  lv_delta = ls_key-%param-quantity.
ENDIF.
      MODIFY ENTITIES OF zi_mm_material IN LOCAL MODE
        ENTITY Material
          UPDATE FIELDS ( StockQty )
          WITH VALUE #( ( %tky = ls_key-%tky StockQty = ls_mat-StockQty + lv_delta ) ).

      lv_seq += 1.

      lt_mov_create = VALUE #( BASE lt_mov_create
        ( %tky    = ls_key-%tky
          %target = VALUE #(
            ( %cid     = |MOVCID_{ sy-tabix }|
              MovId    = |MOV-{ lv_seq WIDTH = 6 ALIGN = RIGHT PAD = '0' }|
              MovType  = ls_key-%param-mov_type
              Quantity = ls_key-%param-quantity
              Unit     = COND #( WHEN ls_key-%param-unit IS NOT INITIAL THEN ls_key-%param-unit ELSE ls_mat-BaseUnit )
              DocRef   = ls_key-%param-doc_ref ) ) ) ).

    ENDLOOP.

    IF lt_mov_create IS NOT INITIAL.
      MODIFY ENTITIES OF zi_mm_material IN LOCAL MODE
        ENTITY Material
          CREATE BY \_StockMovements
            FIELDS ( MovId MovType Quantity Unit DocRef )
            WITH lt_mov_create
        REPORTED DATA(lt_reported_pgm)
        FAILED   DATA(lt_failed_pgm).
    ENDIF.

    READ ENTITIES OF zi_mm_material IN LOCAL MODE
      ENTITY Material
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_updated).

    result = VALUE #( FOR mat IN lt_updated ( %tky = mat-%tky %param = mat ) ).

  ENDMETHOD.

ENDCLASS.

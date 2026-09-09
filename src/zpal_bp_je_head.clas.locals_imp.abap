CLASS lhc_JournalEntry DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR JournalEntry RESULT result.

    METHODS postAuto FOR MODIFY
      IMPORTING keys FOR ACTION JournalEntry~postAuto.
ENDCLASS.

CLASS lhc_JournalEntry IMPLEMENTATION.

  METHOD get_global_authorizations.
    result-%create = if_abap_behv=>auth-allowed.
    result-%update = if_abap_behv=>auth-allowed.
    result-%delete = if_abap_behv=>auth-allowed.
  ENDMETHOD.

   METHOD postAuto.

    LOOP AT keys INTO DATA(ls_key).

      SELECT MAX( je_id ) FROM zpal_je_head INTO @DATA(lv_last).
      DATA(lv_seq) = COND i( WHEN strlen( lv_last ) = 9
                             THEN CONV i( substring( val = lv_last off = 3 len = 6 ) )
                             ELSE 0 ).
      lv_seq += 1.
      DATA(lv_je_id) = CONV zpal_je_head-je_id( |JE-{ lv_seq WIDTH = 6 ALIGN = RIGHT PAD = '0' }| ).

      MODIFY ENTITIES OF zpal_i_je_head IN LOCAL MODE
        ENTITY JournalEntry
          CREATE FIELDS ( JeId PostingDate DocType Reference HeaderText CurrencyCode TotalDebit TotalCredit )
            WITH VALUE #( ( %cid         = |JEH_{ sy-tabix }|
                            JeId         = lv_je_id
                            PostingDate  = cl_abap_context_info=>get_system_date( )
                            DocType      = ls_key-%param-doc_type
                            Reference    = ls_key-%param-reference
                            HeaderText   = ls_key-%param-header_text
                            CurrencyCode = ls_key-%param-currency
                            TotalDebit   = ls_key-%param-amount
                            TotalCredit  = ls_key-%param-amount ) )
        ENTITY JournalEntry
          CREATE BY \_Items
            FIELDS ( ItemPos GlAccount DebitCredit Amount CostCenter CurrencyCode )
            WITH VALUE #( ( %cid_ref = |JEH_{ sy-tabix }|
                            %target  = VALUE #(
                              ( %cid         = |JEI1_{ sy-tabix }|
                                ItemPos      = '0010'
                                GlAccount    = ls_key-%param-debit_account
                                DebitCredit  = 'S'
                                Amount       = ls_key-%param-amount
                                CostCenter   = ls_key-%param-cost_center
                                CurrencyCode = ls_key-%param-currency )
                              ( %cid         = |JEI2_{ sy-tabix }|
                                ItemPos      = '0020'
                                GlAccount    = ls_key-%param-credit_account
                                DebitCredit  = 'H'
                                Amount       = ls_key-%param-amount
                                CostCenter   = ls_key-%param-cost_center
                                CurrencyCode = ls_key-%param-currency ) ) ) )
        REPORTED DATA(lt_rep)
        FAILED   DATA(lt_fail).

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

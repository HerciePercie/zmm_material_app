CLASS zpal_cl_seed_dept DEFINITION
  PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.

CLASS zpal_cl_seed_dept IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    DELETE FROM zpal_department.

    DATA lt TYPE STANDARD TABLE OF zpal_department.
    lt = VALUE #(
      ( client = sy-mandt dept_id = 'DEP-PROD'  dept_name = 'Üretim'             cost_center = 'CC-PROD'  )
      ( client = sy-mandt dept_id = 'DEP-SALES' dept_name = 'Satış ve Pazarlama' cost_center = 'CC-SALES' )
      ( client = sy-mandt dept_id = 'DEP-WHSE'  dept_name = 'Depo ve Lojistik'   cost_center = 'CC-WHSE'  )
      ( client = sy-mandt dept_id = 'DEP-FI'    dept_name = 'Finans ve Muhasebe' cost_center = 'CC-ADMIN' )
      ( client = sy-mandt dept_id = 'DEP-HR'    dept_name = 'İnsan Kaynakları'   cost_center = 'CC-ADMIN' )
      ( client = sy-mandt dept_id = 'DEP-MGMT'  dept_name = 'Genel Yönetim'      cost_center = 'CC-ADMIN' )
    ).
    INSERT zpal_department FROM TABLE @lt.

    out->write( |{ lines( lt ) } departman eklendi.| ).

  ENDMETHOD.
ENDCLASS.

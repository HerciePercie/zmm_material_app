CLASS zpal_cl_seed_emp DEFINITION
  PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.

CLASS zpal_cl_seed_emp IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    DELETE FROM zpal_employee.

    DATA lt TYPE STANDARD TABLE OF zpal_employee.
    lt = VALUE #(
      ( client = sy-mandt emp_id = 'EMP-0001'
        first_name = 'Ahmet' last_name = 'Yılmaz'
        department_id = 'DEP-PROD' positionn = 'Üretim Müdürü'
        hire_date = '20200115' email = 'ahmet.yilmaz@pala.com'
        phone = '+90 532 000 0001'
        monthly_salary = '75000.00' currency_code = 'TRY' emp_status = 'A' )
      ( client = sy-mandt emp_id = 'EMP-0002'
        first_name = 'Ayşe' last_name = 'Demir'
        department_id = 'DEP-SALES' positionn = 'Satış Temsilcisi'
        hire_date = '20210301' email = 'ayse.demir@pala.com'
        phone = '+90 532 000 0002'
        monthly_salary = '48000.00' currency_code = 'TRY' emp_status = 'A' )
      ( client = sy-mandt emp_id = 'EMP-0003'
        first_name = 'Mehmet' last_name = 'Kaya'
        department_id = 'DEP-WHSE' positionn = 'Depo Sorumlusu'
        hire_date = '20190610' email = 'mehmet.kaya@pala.com'
        phone = '+90 532 000 0003'
        monthly_salary = '42000.00' currency_code = 'TRY' emp_status = 'A' )
      ( client = sy-mandt emp_id = 'EMP-0004'
        first_name = 'Zeynep' last_name = 'Şahin'
        department_id = 'DEP-FI' positionn = 'Muhasebe Uzmanı'
        hire_date = '20220901' email = 'zeynep.sahin@pala.com'
        phone = '+90 532 000 0004'
        monthly_salary = '55000.00' currency_code = 'TRY' emp_status = 'A' )
      ( client = sy-mandt emp_id = 'EMP-0005'
        first_name = 'Can' last_name = 'Öztürk'
        department_id = 'DEP-HR' positionn = 'İK Uzmanı'
        hire_date = '20230201' email = 'can.ozturk@pala.com'
        phone = '+90 532 000 0005'
        monthly_salary = '50000.00' currency_code = 'TRY' emp_status = 'A' )
    ).
    INSERT zpal_employee FROM TABLE @lt.

    out->write( |{ lines( lt ) } personel eklendi.| ).

  ENDMETHOD.
ENDCLASS.

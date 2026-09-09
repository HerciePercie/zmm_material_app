CLASS zpal_cl_seed_vendor DEFINITION
  PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.

CLASS zpal_cl_seed_vendor IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    DELETE FROM zpal_vendor.

    DATA lt TYPE STANDARD TABLE OF zpal_vendor.
    lt = VALUE #(
      ( client = sy-mandt vendor_id = 'VEN-0001' name = 'Bursa Tekstil Kumaş San.'
        tax_number = '5551112223' vendor_group = 'ROH' email = 'satis@bursatekstil.com'
        phone = '+90 224 000 0001' street = 'Demirtaş OSB 4. Cadde No:7'
        city = 'Bursa' postal_code = '16245' country = 'TR' purchase_block = abap_false )
      ( client = sy-mandt vendor_id = 'VEN-0002' name = 'Güven Metal Aksesuar Ltd.'
        tax_number = '5552223334' vendor_group = 'ROH' email = 'siparis@guvenmetal.com'
        phone = '+90 212 000 0002' street = 'İkitelli OSB Metalciler Sitesi'
        city = 'İstanbul' postal_code = '34490' country = 'TR' purchase_block = abap_false )
      ( client = sy-mandt vendor_id = 'VEN-0003' name = 'Anadolu Ambalaj A.Ş.'
        tax_number = '5553334445' vendor_group = 'VERP' email = 'info@anadoluambalaj.com'
        phone = '+90 312 000 0003' street = 'Ostim San. Sitesi 100. Yıl Blv.'
        city = 'Ankara' postal_code = '06370' country = 'TR' purchase_block = abap_true )
    ).
    INSERT zpal_vendor FROM TABLE @lt.

    out->write( |{ lines( lt ) } tedarikçi eklendi.| ).

  ENDMETHOD.
ENDCLASS.

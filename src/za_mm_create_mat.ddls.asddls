@EndUserText.label: 'Yeni Malzeme Ekle Pop-up Parametreleri'
define abstract entity ZA_MM_CREATE_MAT {
  @EndUserText.label: 'Malzeme Kodu'
  mat_id     : abap.char(10);

  @EndUserText.label: 'Malzeme Açıklaması'
  mat_desc   : abap.char(40);

  @EndUserText.label: 'Malzeme Tipi (FERT/ROH/HALB)'
  mat_type   : abap.char(4);

  @EndUserText.label: 'Ölçü Birimi (ST/M/KG)'
  base_unit  : abap.unit(3);

  @EndUserText.label: 'Başlangıç Stok Miktarı'
  @Semantics.quantity.unitOfMeasure: 'base_unit'
  stock_qty  : abap.quan(13,3);

  @EndUserText.label: 'Birim Satış Fiyatı'
  @Semantics.amount.currencyCode: 'currency'
  unit_price : abap.curr(15,2);

  @EndUserText.label: 'Para Birimi'
  currency   : abap.cuky;
}

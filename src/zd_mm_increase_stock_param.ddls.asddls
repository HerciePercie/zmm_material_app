@EndUserText.label: 'Stok Artirma Pop-Up Parametresi'
define abstract entity ZD_MM_INCREASE_STOCK_PARAM
{
  @EndUserText.label: 'Eklenecek Miktar'
  @Semantics.quantity.unitOfMeasure: 'Unit'
  quantity : abap.quan(13,3);

  @EndUserText.label: 'Birim'
  unit     : abap.unit(3);
}

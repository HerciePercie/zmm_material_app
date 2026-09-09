@EndUserText.label: 'Stok Hareketi Kayit Parametreleri'
define abstract entity ZD_MM_POST_MOVEMENT_PARAM
{
  @EndUserText.label: 'Hareket Turu (Orn: 201=Satis Cikisi)'
  mov_type : abap.char(3);

  @EndUserText.label: 'Miktar'
  @Semantics.quantity.unitOfMeasure: 'Unit'
  quantity : abap.quan(13,3);

  @EndUserText.label: 'Birim'
  unit     : abap.unit(3);

  @EndUserText.label: 'Referans Belge (Orn: Siparis No)'
  doc_ref  : abap.char(10);
}

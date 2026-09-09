@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Stok Hareketleri Projection View'
define view entity ZC_MM_STOCK_MOV
  as projection on ZI_MM_STOCK_MOV
{
      @UI.lineItem: [{ position: 10, label: 'Hareket Belge No' }]
  key MovId,
      MatId,

      @UI.lineItem: [{ position: 20, label: 'Hareket Türü' }]
      @ObjectModel.text.element: ['MovTypeText']
      @UI.textArrangement: #TEXT_FIRST
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZPAL_I_MOVE_TYPE', element: 'MovType' } }]
      MovType,

      MovTypeText,

      @UI.lineItem: [{ position: 30, label: 'Miktar' }]
      @Semantics.quantity.unitOfMeasure: 'Unit'
      Quantity,
      Unit,

      @UI.lineItem: [{ position: 40, label: 'Referans Belge (SO No)' }]
      DocRef,
      @UI.lineItem: [{ position: 50, label: 'İşlemi Yapan' }]
      CreatedBy,
      @UI.lineItem: [{ position: 60, label: 'İşlem Tarihi' }]
      CreatedAt,

      _Material : redirected to parent ZC_MM_MATERIAL
}

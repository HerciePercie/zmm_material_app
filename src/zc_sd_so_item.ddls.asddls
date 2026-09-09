@EndUserText.label: 'SD Satis Siparis Kalemleri UI Projection'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
define view entity ZC_SD_SO_ITEM
  as projection on ZR_SD_SO_ITEM
{
      @UI.facet: [{
          id: 'ItemData',
          purpose: #STANDARD,
          type: #IDENTIFICATION_REFERENCE,
          label: 'Kalem Detayı',
          position: 10
      }]

      @UI.identification: [{ position: 10, label: 'Sipariş No' }]
  key SalesOrderId,

      @UI.lineItem: [{ position: 10, label: 'Satır No' }]
      @UI.identification: [{ position: 20, label: 'Satır No' }]
  key ItemPos,

      @UI.lineItem: [{ position: 20, label: 'Malzeme Kodu' }]
      @UI.identification: [{ position: 30, label: 'Malzeme Kodu' }]
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{
          entity: {
              name: 'ZC_MM_MATERIAL',
              element: 'MatId'
          }
      }]
      MatId,

      @UI.lineItem: [{ position: 30, label: 'Miktar' }]
      @UI.identification: [{ position: 40, label: 'Miktar' }]
      @Semantics.quantity.unitOfMeasure: 'Unit'
      Quantity,

      Unit,

      @UI.lineItem: [{ position: 40, label: 'Birim Fiyat' }]
      @UI.identification: [{ position: 50, label: 'Birim Fiyat' }]
      @Semantics.amount.currencyCode: 'CurrencyCode'
      UnitPrice,

      @UI.lineItem: [{ position: 50, label: 'Net Tutar' }]
      @UI.identification: [{ position: 60, label: 'Net Tutar' }]
      @Semantics.amount.currencyCode: 'CurrencyCode'
      NetAmount,

      CurrencyCode,

      _Header   : redirected to parent ZC_SD_SO_HEAD,
      _Material : redirected to ZC_MM_MATERIAL
}

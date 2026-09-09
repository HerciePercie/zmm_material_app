@EndUserText.label: 'Satin Alma Siparis Kalem - UI'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity ZPAL_C_PO_ITEM
  as projection on ZPAL_I_PO_ITEM
{
      @UI.lineItem: [{ position: 10 }]
      @UI.identification: [{ position: 10 }]
  key PoId,

      @UI.lineItem: [{ position: 20 }]
      @UI.identification: [{ position: 20 }]
  key ItemPos,

      @UI.lineItem: [{ position: 30 }]
      @UI.identification: [{ position: 30 }]
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZC_MM_MATERIAL', element: 'MatId' } }]
      MatId,

      @UI.lineItem: [{ position: 40 }]
      @UI.identification: [{ position: 40 }]
      @Semantics.quantity.unitOfMeasure: 'Unit'
      Quantity,

      @UI.lineItem: [{ position: 50 }]
      Unit,

      @UI.lineItem: [{ position: 60 }]
      @UI.identification: [{ position: 50 }]
      @Semantics.amount.currencyCode: 'CurrencyCode'
      UnitPrice,

      @UI.lineItem: [{ position: 70 }]
      @UI.identification: [{ position: 60 }]
      @Semantics.amount.currencyCode: 'CurrencyCode'
      NetAmount,

      CurrencyCode,

      _Header   : redirected to parent ZPAL_C_PO_HEAD,
      _Material : redirected to ZC_MM_MATERIAL
}

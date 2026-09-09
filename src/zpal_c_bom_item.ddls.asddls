@EndUserText.label: 'Urun Recetesi Kalem - UI'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity ZPAL_C_BOM_ITEM
  as projection on ZPAL_I_BOM_ITEM
{
      @UI.lineItem: [{ position: 10 }]
      @UI.identification: [{ position: 10 }]
  key BomId,

      @UI.lineItem: [{ position: 20 }]
      @UI.identification: [{ position: 20 }]
  key ItemPos,

      @UI.lineItem: [{ position: 30 }]
      @UI.identification: [{ position: 30 }]
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZC_MM_MATERIAL', element: 'MatId' } }]
      ComponentMat,

      @UI.lineItem: [{ position: 40 }]
      @UI.identification: [{ position: 40 }]
      @Semantics.quantity.unitOfMeasure: 'Unit'
      Quantity,

      @UI.lineItem: [{ position: 50 }]
      @UI.identification: [{ position: 50 }]
      Unit,

      _Header : redirected to parent ZPAL_C_BOM_HEAD
}

@EndUserText.label: 'Urun Recetesi Baslik - UI'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
@ObjectModel.semanticKey: ['BomId']
@UI.headerInfo: {
    typeName: 'Ürün Reçetesi',
    typeNamePlural: 'Ürün Reçeteleri',
    title: { type: #STANDARD, value: 'BomId' },
    description: { value: 'HeaderText' }
}
define root view entity ZPAL_C_BOM_HEAD
  provider contract transactional_query
  as projection on ZPAL_I_BOM_HEAD
{
      @UI.facet: [
          { id: 'General', purpose: #STANDARD, type: #IDENTIFICATION_REFERENCE, label: 'Reçete Bilgileri', position: 10 },
          { id: 'Items', purpose: #STANDARD, type: #LINEITEM_REFERENCE, targetElement: '_Items', label: 'Bileşenler', position: 20 }
      ]

      @UI.lineItem: [{ position: 10, importance: #HIGH }]
      @UI.identification: [{ position: 10 }]
      @Search.defaultSearchElement: true
  key BomId,

      @UI.lineItem: [{ position: 20, importance: #HIGH }]
      @UI.identification: [{ position: 20 }]
      @UI.selectionField: [{ position: 10 }]
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZC_MM_MATERIAL', element: 'MatId' } }]
      ProductMat,

      @UI.lineItem: [{ position: 30 }]
      @UI.identification: [{ position: 30 }]
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      BaseQty,

      @UI.lineItem: [{ position: 40 }]
      @UI.identification: [{ position: 40 }]
      BaseUnit,

      @UI.lineItem: [{ position: 50, importance: #HIGH }]
      @UI.identification: [{ position: 50 }]
      HeaderText,

      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,

      _Items : redirected to composition child ZPAL_C_BOM_ITEM
}

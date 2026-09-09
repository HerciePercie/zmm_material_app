@EndUserText.label: 'Uretim Emri - UI'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
@ObjectModel.semanticKey: ['ProdId']
@UI.headerInfo: {
    typeName: 'Üretim Emri',
    typeNamePlural: 'Üretim Emirleri',
    title: { type: #STANDARD, value: 'ProdId' },
    description: { value: 'HeaderText' }
}
define root view entity ZPAL_C_PROD_ORD
  provider contract transactional_query
  as projection on ZPAL_I_PROD_ORD
{
      @UI.facet: [
          { id: 'General', purpose: #STANDARD, type: #IDENTIFICATION_REFERENCE, label: 'Üretim Emri Bilgileri', position: 10 }
      ]

      @UI.lineItem: [
          { position: 10, importance: #HIGH },
          { type: #FOR_ACTION, dataAction: 'confirmProduction', label: 'Üretimi Tamamla', position: 1 },
          { type: #FOR_ACTION, dataAction: 'cancelProduction', label: 'İptal Et', position: 2 }
      ]
      @UI.identification: [{ position: 10 }]
      @Search.defaultSearchElement: true
  key ProdId,

      @UI.lineItem: [{ position: 20, importance: #HIGH }]
      @UI.identification: [{ position: 20 }]
      @UI.selectionField: [{ position: 10 }]
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZC_MM_MATERIAL', element: 'MatId' } }]
      ProductMat,

      @UI.lineItem: [{ position: 30 }]
      @UI.identification: [{ position: 30 }]
      @Semantics.quantity.unitOfMeasure: 'OrderUnit'
      OrderQty,

      @UI.lineItem: [{ position: 40 }]
      @UI.identification: [{ position: 40 }]
      OrderUnit,

      @UI.lineItem: [{ position: 50 }]
      @UI.identification: [{ position: 50 }]
      @UI.selectionField: [{ position: 20 }]
      ProdStatus,

      @UI.lineItem: [{ position: 60, importance: #HIGH }]
      @UI.identification: [{ position: 60 }]
      HeaderText,

      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt
}

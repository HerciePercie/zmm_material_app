@EndUserText.label: 'Muhasebe Fisi Baslik - UI'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
@ObjectModel.semanticKey: ['JeId']
@UI.headerInfo: {
    typeName: 'Muhasebe Fişi',
    typeNamePlural: 'Muhasebe Fişleri',
    title: { type: #STANDARD, value: 'JeId' },
    description: { value: 'HeaderText' }
}
define root view entity ZPAL_C_JE_HEAD
  provider contract transactional_query
  as projection on ZPAL_I_JE_HEAD
{
      @UI.facet: [
          { id: 'General', purpose: #STANDARD, type: #IDENTIFICATION_REFERENCE, label: 'Fiş Bilgileri', position: 10 },
          { id: 'Items', purpose: #STANDARD, type: #LINEITEM_REFERENCE, targetElement: '_Items', label: 'Fiş Satırları', position: 20 }
      ]

      @UI.lineItem: [{ position: 10, importance: #HIGH }]
      @UI.identification: [{ position: 10 }]
      @Search.defaultSearchElement: true
  key JeId,

      @UI.lineItem: [{ position: 20 }]
      @UI.identification: [{ position: 20 }]
      PostingDate,

      @UI.lineItem: [{ position: 30 }]
      @UI.identification: [{ position: 30 }]
      @UI.selectionField: [{ position: 10 }]
      DocType,

      @UI.lineItem: [{ position: 40 }]
      @UI.identification: [{ position: 40 }]
      Reference,

      @UI.lineItem: [{ position: 50, importance: #HIGH }]
      @UI.identification: [{ position: 50 }]
      HeaderText,

      @UI.lineItem: [{ position: 60 }]
      @UI.identification: [{ position: 60 }]
      @Semantics.amount.currencyCode: 'CurrencyCode'
      TotalDebit,

      @UI.lineItem: [{ position: 70 }]
      @UI.identification: [{ position: 70 }]
      @Semantics.amount.currencyCode: 'CurrencyCode'
      TotalCredit,

      CurrencyCode,

      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,

      _Items : redirected to composition child ZPAL_C_JE_ITEM
}

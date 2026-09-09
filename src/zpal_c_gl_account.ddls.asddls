@EndUserText.label: 'Hesap Plani - UI Projection'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
@ObjectModel.semanticKey: ['GlAccount']
@UI.headerInfo: {
    typeName: 'Hesap',
    typeNamePlural: 'Hesap Planı',
    title: { type: #STANDARD, value: 'GlAccount' },
    description: { value: 'Description' }
}
define root view entity ZPAL_C_GL_ACCOUNT
  provider contract transactional_query
  as projection on ZPAL_I_GL_ACCOUNT
{
      @UI.facet: [
          { id: 'General', purpose: #STANDARD, type: #IDENTIFICATION_REFERENCE, label: 'Genel Bilgiler', position: 10 }
      ]

      @UI.lineItem: [{ position: 10, importance: #HIGH }]
      @UI.identification: [{ position: 10 }]
      @UI.selectionField: [{ position: 10 }]
      @Search.defaultSearchElement: true
  key GlAccount,

      @UI.lineItem: [{ position: 20, importance: #HIGH }]
      @UI.identification: [{ position: 20 }]
      @Search.defaultSearchElement: true
      Description,

      @UI.lineItem: [{ position: 30 }]
      @UI.identification: [{ position: 30 }]
      @UI.selectionField: [{ position: 20 }]
      AccountType,

      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt
}

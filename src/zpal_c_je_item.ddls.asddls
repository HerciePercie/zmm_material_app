@EndUserText.label: 'Muhasebe Fisi Kalem - UI'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity ZPAL_C_JE_ITEM
  as projection on ZPAL_I_JE_ITEM
{
      @UI.lineItem: [{ position: 10 }]
      @UI.identification: [{ position: 10 }]
  key JeId,

      @UI.lineItem: [{ position: 20 }]
      @UI.identification: [{ position: 20 }]
  key ItemPos,

      @UI.lineItem: [{ position: 30 }]
      @UI.identification: [{ position: 30 }]
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZPAL_C_GL_ACCOUNT', element: 'GlAccount' } }]
      GlAccount,

      @UI.lineItem: [{ position: 40 }]
      @UI.identification: [{ position: 40 }]
      DebitCredit,

      @UI.lineItem: [{ position: 50 }]
      @UI.identification: [{ position: 50 }]
      @Semantics.amount.currencyCode: 'CurrencyCode'
      Amount,

      @UI.lineItem: [{ position: 60 }]
      @UI.identification: [{ position: 60 }]
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZPAL_I_COST_CENTER', element: 'CostCenter' } }]
      CostCenter,

      @UI.lineItem: [{ position: 70 }]
      @UI.identification: [{ position: 70 }]
      ItemText,

      CurrencyCode,

      _Header : redirected to parent ZPAL_C_JE_HEAD
}

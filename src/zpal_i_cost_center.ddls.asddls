@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Masraf Yeri'
@ObjectModel.representativeKey: 'CostCenter'
@Search.searchable: true
define view entity ZPAL_I_COST_CENTER
  as select from zpal_cost_center
{
      @EndUserText.label: 'Masraf Yeri'
      @Search.defaultSearchElement: true
  key cost_center as CostCenter,

      @EndUserText.label: 'Açıklama'
      @Semantics.text: true
      @Search.defaultSearchElement: true
      description as Description
}

@EndUserText.label: 'MM Malzeme UI Projection View'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: ['MatId']
define root view entity ZC_MM_MATERIAL
  provider contract transactional_query
  as projection on ZI_MM_MATERIAL
{
      @Search.defaultSearchElement: true
  key MatId,

      @Search.defaultSearchElement: true
      MatDesc,

      MatType,
      BaseUnit,

      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      StockQty,

      @Semantics.amount.currencyCode: 'Currency'
      UnitPrice,

      Currency,
      CreatedAt,
      CreatedBy,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,

      _StockMovements : redirected to composition child ZC_MM_STOCK_MOV
}

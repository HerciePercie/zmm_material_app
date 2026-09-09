@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Malzeme Ana Veri Interface View'
define root view entity ZI_MM_MATERIAL
  as select from zmm_mat_master
  composition [0..*] of ZI_MM_STOCK_MOV as _StockMovements
{
  @EndUserText.label: 'Malzeme Kodu'
  key mat_id                as MatId,

      @EndUserText.label: 'Malzeme Açıklaması'
      mat_desc              as MatDesc,

      @EndUserText.label: 'Malzeme Tipi'
      mat_type              as MatType,

      @EndUserText.label: 'Ölçü Birimi'
      base_unit             as BaseUnit,

      @EndUserText.label: 'Depo Mevcut Stoğu'
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      stock_qty             as StockQty,

      @EndUserText.label: 'Birim Fiyat'
      @Semantics.amount.currencyCode: 'Currency'
      unit_price            as UnitPrice,

      @EndUserText.label: 'Para Birimi'
      currency              as Currency,

      @Semantics.user.createdBy: true
      created_by            as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by       as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,

      _StockMovements
}

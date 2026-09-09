@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Uretim Emri - Interface'
define root view entity ZPAL_I_PROD_ORD
  as select from zpal_prod_ord
  association [0..1] to ZI_MM_MATERIAL as _Product on $projection.ProductMat = _Product.MatId
{
  @EndUserText.label: 'Üretim Emri No'
  key prod_id               as ProdId,

      @EndUserText.label: 'Mamul (Üretilecek Malzeme)'
      @ObjectModel.foreignKey.association: '_Product'
      product_mat           as ProductMat,

      @EndUserText.label: 'Üretim Miktarı'
      @Semantics.quantity.unitOfMeasure: 'OrderUnit'
      order_qty             as OrderQty,

      @EndUserText.label: 'Birim'
      order_unit            as OrderUnit,

      @EndUserText.label: 'Durum'
      prod_status           as ProdStatus,

      @EndUserText.label: 'Açıklama'
      header_text           as HeaderText,

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

      _Product
}

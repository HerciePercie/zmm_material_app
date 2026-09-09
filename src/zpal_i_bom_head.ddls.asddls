@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Urun Recetesi Baslik - Interface'
define root view entity ZPAL_I_BOM_HEAD
  as select from zpal_bom_head
  composition [0..*] of ZPAL_I_BOM_ITEM as _Items
  association [0..1] to ZI_MM_MATERIAL as _Product on $projection.ProductMat = _Product.MatId
{
  @EndUserText.label: 'Reçete No'
  key bom_id                as BomId,

      @EndUserText.label: 'Mamul (Üretilen Malzeme)'
      @ObjectModel.foreignKey.association: '_Product'
      product_mat           as ProductMat,

      @EndUserText.label: 'Baz Miktar'
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      base_qty              as BaseQty,

      @EndUserText.label: 'Baz Birim'
      base_unit             as BaseUnit,

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

      _Items,
      _Product
}

@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Stok Hareketleri Interface View'
define view entity ZI_MM_STOCK_MOV
  as select from zmm_stock_mov
  association        to parent ZI_MM_MATERIAL  as _Material on  $projection.MatId = _Material.MatId
  association [0..1] to ZPAL_I_MOVE_TYPE        as _MoveType on  $projection.MovType = _MoveType.MovType
{
  @EndUserText.label: 'Hareket Belge No'
  key mov_id     as MovId,

      @EndUserText.label: 'Malzeme Kodu'
      mat_id     as MatId,

      @EndUserText.label: 'Hareket Türü'
      @ObjectModel.foreignKey.association: '_MoveType'
      mov_type   as MovType,

      @EndUserText.label: 'Hareket Türü Açıklaması'
      _MoveType.Description as MovTypeText,
      _MoveType.Direction  as MovTypeDirection,

      @EndUserText.label: 'Miktar'
      @Semantics.quantity.unitOfMeasure: 'Unit'
      quantity   as Quantity,

      @EndUserText.label: 'Birim'
      unit       as Unit,

      @EndUserText.label: 'Referans Belge'
      doc_ref    as DocRef,

      @EndUserText.label: 'Oluşturan'
      created_by as CreatedBy,

      @EndUserText.label: 'Oluşturulma Zamanı'
      created_at as CreatedAt,

      _Material,
      _MoveType
}

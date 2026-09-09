@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Urun Recetesi Kalem - Interface'
define view entity ZPAL_I_BOM_ITEM
  as select from zpal_bom_item
  association to parent ZPAL_I_BOM_HEAD as _Header    on $projection.BomId = _Header.BomId
  association [0..1] to ZI_MM_MATERIAL   as _Component on $projection.ComponentMat = _Component.MatId
{
  @EndUserText.label: 'Reçete No'
  key bom_id                as BomId,

      @EndUserText.label: 'Satır No'
  key item_pos              as ItemPos,

      @EndUserText.label: 'Bileşen (Hammadde)'
      @ObjectModel.foreignKey.association: '_Component'
      component_mat         as ComponentMat,

      @EndUserText.label: 'Miktar'
      @Semantics.quantity.unitOfMeasure: 'Unit'
      quantity              as Quantity,

      @EndUserText.label: 'Birim'
      unit                  as Unit,

      _Header,
      _Component
}

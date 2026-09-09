@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Stok Hareket Turu'
@ObjectModel.representativeKey: 'MovType'
@Search.searchable: true
define view entity ZPAL_I_MOVE_TYPE
  as select from zpal_move_type
{
      @EndUserText.label: 'Hareket Türü'
      @Search.defaultSearchElement: true
  key mov_type   as MovType,

      @EndUserText.label: 'Açıklama'
      @Semantics.text: true
      @Search.defaultSearchElement: true
      description as Description,

      @EndUserText.label: 'Yön'
      direction  as Direction
}

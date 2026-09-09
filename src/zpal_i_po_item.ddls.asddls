@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Satin Alma Siparis Kalem - Interface'
define view entity ZPAL_I_PO_ITEM
  as select from zpal_po_item
  association to parent ZPAL_I_PO_HEAD as _Header   on $projection.PoId = _Header.PoId
  association [0..1] to ZI_MM_MATERIAL  as _Material on $projection.MatId = _Material.MatId
{
  @EndUserText.label: 'Satın Alma Sipariş No'
  key po_id                     as PoId,

      @EndUserText.label: 'Satır No'
  key item_pos                  as ItemPos,

      @EndUserText.label: 'Malzeme Kodu'
      @ObjectModel.foreignKey.association: '_Material'
      mat_id                    as MatId,

      @EndUserText.label: 'Miktar'
      @Semantics.quantity.unitOfMeasure: 'Unit'
      quantity                  as Quantity,

      @EndUserText.label: 'Birim'
      unit                      as Unit,

      @EndUserText.label: 'Birim Fiyat'
      @Semantics.amount.currencyCode: 'CurrencyCode'
      unit_price                as UnitPrice,

      @EndUserText.label: 'Net Tutar'
      @Semantics.amount.currencyCode: 'CurrencyCode'
      net_amount                as NetAmount,

      @EndUserText.label: 'Para Birimi'
      currency_code             as CurrencyCode,

      _Header,
      _Material
}

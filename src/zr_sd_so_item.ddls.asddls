@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SD Satis Kalemleri Root View'
define view entity ZR_SD_SO_ITEM
  as select from ztsd_so_item
  association to parent ZR_SD_SO_HEAD as _Header   on $projection.SalesOrderId = _Header.SalesOrderId
  association [0..1] to ZI_MM_MATERIAL as _Material on $projection.MatId       = _Material.MatId
{
  @EndUserText.label: 'Sipariş No'
  key sales_order_id                        as SalesOrderId,

      @EndUserText.label: 'Satır No'
  key item_pos                              as ItemPos,

      @EndUserText.label: 'Malzeme Kodu'
      @ObjectModel.foreignKey.association: '_Material'
      mat_id                                as MatId,

      @EndUserText.label: 'Miktar'
      @Semantics.quantity.unitOfMeasure: 'Unit'
      quantity                              as Quantity,

      @EndUserText.label: 'Birim'
      unit                                  as Unit,

      @EndUserText.label: 'Birim Fiyat'
      @Semantics.amount.currencyCode: 'CurrencyCode'
      unit_price                            as UnitPrice,

      @EndUserText.label: 'Net Tutar'
      @Semantics.amount.currencyCode: 'CurrencyCode'
      net_amount                            as NetAmount,

      @EndUserText.label: 'Para Birimi'
      currency_code                         as CurrencyCode,

      _Header,
      _Material
}

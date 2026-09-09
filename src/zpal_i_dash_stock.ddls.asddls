@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Dashboard - Stok Degeri'
define view entity ZPAL_I_DASH_STOCK
  as select from zmm_mat_master
{
  key mat_id   as MatId,
      mat_desc as MatDesc,
      mat_type as MatType,
      cast( stock_qty  as abap.dec( 15, 3 ) ) as StockQty,
      cast( unit_price as abap.dec( 15, 2 ) ) as UnitPrice,
      cast( stock_qty as abap.dec( 15, 3 ) ) * cast( unit_price as abap.dec( 15, 2 ) ) as StockValue
}

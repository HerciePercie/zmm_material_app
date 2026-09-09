@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Dashboard - SD Siparis Durum Ozeti'
define view entity ZPAL_I_DASH_SD
  as select from ztsd_so_head
{
  key   order_status                                as OrderStatus,
        count( * )                                   as OrderCount,
        cast( sum( total_amount ) as abap.dec( 23, 2 ) ) as TotalAmount
}
group by order_status

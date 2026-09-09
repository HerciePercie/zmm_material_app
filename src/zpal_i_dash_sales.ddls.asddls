@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Dashboard - Musteriye Gore Ciro'
define view entity ZPAL_I_DASH_SALES
  as select from ztsd_so_head
{
  key customer_id                                       as CustomerId,
      max( customer_name )                              as CustomerName,
      count( * )                                        as OrderCount,
      cast( sum( total_amount ) as abap.dec( 23, 2 ) )  as Revenue
}
where order_status = '03'
group by customer_id

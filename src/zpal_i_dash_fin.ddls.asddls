@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Dashboard - Muhasebe Fisi Ozeti'
define view entity ZPAL_I_DASH_FIN
  as select from zpal_je_head
{
  key   doc_type                                     as DocType,
        count( * )                                    as JeCount,
        cast( sum( total_debit ) as abap.dec( 23, 2 ) ) as TotalDebit
}
group by doc_type

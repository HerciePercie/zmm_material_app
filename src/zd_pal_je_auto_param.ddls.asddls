@EndUserText.label: 'Otomatik Muhasebe Fisi Parametreleri'
define abstract entity ZD_PAL_JE_AUTO_PARAM
{
  doc_type       : abap.char(4);
  reference      : abap.char(10);
  header_text    : abap.char(60);
  debit_account  : abap.char(10);
  credit_account : abap.char(10);
  @Semantics.amount.currencyCode: 'currency'
  amount         : abap.curr(15,2);
  currency       : abap.cuky;
  cost_center    : abap.char(10);
}

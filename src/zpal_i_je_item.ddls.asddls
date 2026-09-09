@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Muhasebe Fisi Kalem - Interface'
define view entity ZPAL_I_JE_ITEM
  as select from zpal_je_item
  association to parent ZPAL_I_JE_HEAD as _Header on $projection.JeId = _Header.JeId
{
  @EndUserText.label: 'Fiş No'
  key je_id                 as JeId,

      @EndUserText.label: 'Satır No'
  key item_pos              as ItemPos,

      @EndUserText.label: 'Hesap No'
      gl_account            as GlAccount,

      @EndUserText.label: 'Borç/Alacak (S/H)'
      debit_credit          as DebitCredit,

      @EndUserText.label: 'Tutar'
      @Semantics.amount.currencyCode: 'CurrencyCode'
      amount                as Amount,

      @EndUserText.label: 'Masraf Yeri'
      cost_center           as CostCenter,

      @EndUserText.label: 'Satır Açıklaması'
      item_text             as ItemText,

      @EndUserText.label: 'Para Birimi'
      currency_code         as CurrencyCode,

      _Header
}

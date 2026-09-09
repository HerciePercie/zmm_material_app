@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Muhasebe Fisi Baslik - Interface'
define root view entity ZPAL_I_JE_HEAD
  as select from zpal_je_head
  composition [0..*] of ZPAL_I_JE_ITEM as _Items
{
  @EndUserText.label: 'Fiş No'
  key je_id                 as JeId,

      @EndUserText.label: 'Kayıt Tarihi'
      posting_date          as PostingDate,

      @EndUserText.label: 'Belge Türü'
      doc_type              as DocType,

      @EndUserText.label: 'Referans Belge'
      reference             as Reference,

      @EndUserText.label: 'Fiş Açıklaması'
      header_text           as HeaderText,

      @EndUserText.label: 'Toplam Borç'
      @Semantics.amount.currencyCode: 'CurrencyCode'
      total_debit           as TotalDebit,

      @EndUserText.label: 'Toplam Alacak'
      @Semantics.amount.currencyCode: 'CurrencyCode'
      total_credit          as TotalCredit,

      @EndUserText.label: 'Para Birimi'
      currency_code         as CurrencyCode,

      @Semantics.user.createdBy: true
      created_by            as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by       as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,

      _Items
}

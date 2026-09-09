@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Hesap Plani - Interface View'
define root view entity ZPAL_I_GL_ACCOUNT
  as select from zpal_gl_account
{
  @EndUserText.label: 'Hesap No'
  key gl_account            as GlAccount,

      @EndUserText.label: 'Hesap Adı'
      description            as Description,

      @EndUserText.label: 'Hesap Tipi'
      account_type          as AccountType,

      @Semantics.user.createdBy: true
      created_by            as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by       as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt
}

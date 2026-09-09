@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Tedarikci Ana Verisi - Interface View'
define root view entity ZPAL_I_VENDOR
  as select from zpal_vendor
{
  @EndUserText.label: 'Tedarikçi No'
  key vendor_id             as VendorId,

      @EndUserText.label: 'Ünvan'
      name                  as Name,

      @EndUserText.label: 'Vergi No'
      tax_number            as TaxNumber,

      @EndUserText.label: 'Tedarikçi Grubu'
      vendor_group          as VendorGroup,

      @EndUserText.label: 'E-Posta'
      email                 as Email,

      @EndUserText.label: 'Telefon'
      phone                 as Phone,

      @EndUserText.label: 'Sokak / Cadde'
      street                as Street,

      @EndUserText.label: 'Şehir'
      city                  as City,

      @EndUserText.label: 'Posta Kodu'
      postal_code           as PostalCode,

      @EndUserText.label: 'Ülke'
      country               as Country,

      @EndUserText.label: 'Satın Alma Bloğu'
      purchase_block        as PurchaseBlock,

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

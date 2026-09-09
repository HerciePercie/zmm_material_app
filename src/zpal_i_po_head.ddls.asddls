@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Satin Alma Siparis Baslik - Interface'
define root view entity ZPAL_I_PO_HEAD
  as select from zpal_po_head
  composition [0..*] of ZPAL_I_PO_ITEM as _Items
  association [0..1] to ZPAL_I_VENDOR as _Vendor on $projection.VendorId = _Vendor.VendorId
{
  @EndUserText.label: 'Satın Alma Sipariş No'
  key po_id                 as PoId,

      @EndUserText.label: 'Tedarikçi No'
      @ObjectModel.foreignKey.association: '_Vendor'
      vendor_id             as VendorId,

      @EndUserText.label: 'Tedarikçi Ünvanı'
      vendor_name           as VendorName,

      @EndUserText.label: 'Sipariş Tarihi'
      order_date            as OrderDate,

      @EndUserText.label: 'Toplam Tutar'
      @Semantics.amount.currencyCode: 'CurrencyCode'
      total_amount          as TotalAmount,

      @EndUserText.label: 'Para Birimi'
      currency_code         as CurrencyCode,

      @EndUserText.label: 'Sipariş Durumu'
      po_status             as PoStatus,

      @EndUserText.label: 'İrsaliye No'
      delivery_note         as DeliveryNote,

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

      _Items,
      _Vendor
}

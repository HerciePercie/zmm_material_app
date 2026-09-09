@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SD Satis Siparis Baslik Root CDS'
define root view entity ZR_SD_SO_HEAD
  as select from ztsd_so_head
  composition [0..*] of ZR_SD_SO_ITEM as _Items
  association [0..1] to ZPAL_I_CUSTOMER as _Customer on $projection.CustomerId = _Customer.CustomerId
{
  @EndUserText.label: 'Sipariş No'
  key sales_order_id        as SalesOrderId,

      @EndUserText.label: 'Müşteri No'
      @ObjectModel.foreignKey.association: '_Customer'
      customer_id           as CustomerId,

      @EndUserText.label: 'Müşteri Ünvanı'
      customer_name         as CustomerName,

      @EndUserText.label: 'Sipariş Tarihi'
      order_date            as OrderDate,

      @EndUserText.label: 'Toplam Tutar'
      @Semantics.amount.currencyCode: 'CurrencyCode'
      total_amount          as TotalAmount,

      @EndUserText.label: 'Para Birimi'
      currency_code         as CurrencyCode,

      @EndUserText.label: 'Sipariş Durumu'
      order_status          as OrderStatus,

      @EndUserText.label: 'Kargo Firması'
      shipping_carrier      as ShippingCarrier,

      @EndUserText.label: 'Kargo Takip No'
      tracking_number       as TrackingNumber,

      @EndUserText.label: 'Teslimat Adresi'
      delivery_address      as DeliveryAddress,

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
      _Customer
}

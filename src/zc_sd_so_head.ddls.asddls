@EndUserText.label: 'SD Satis Siparis Baslik UI Projection'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
@ObjectModel.semanticKey: ['SalesOrderId']
@UI.headerInfo: {
    typeName: 'Sipariş',
    typeNamePlural: 'Siparişler',
    title: { type: #STANDARD, value: 'SalesOrderId' },
    description: { value: 'CustomerName' }
}
define root view entity ZC_SD_SO_HEAD
  provider contract transactional_query
  as projection on ZR_SD_SO_HEAD
{
      @UI.facet: [
          { id: 'GeneralInfo', purpose: #STANDARD, type: #IDENTIFICATION_REFERENCE, label: 'Sipariş Genel Bilgileri', position: 10 },
          { id: 'ShippingInfo', purpose: #STANDARD, type: #FIELDGROUP_REFERENCE, targetQualifier: 'ShippingGroup', label: 'Kargo ve Sevkiyat Detayları', position: 20 },
          { id: 'OrderItems', purpose: #STANDARD, type: #LINEITEM_REFERENCE, targetElement: '_Items', label: 'Sipariş Edilen Ürünler', position: 30 }
      ]

      @UI.lineItem: [
          { position: 10, label: 'Sipariş No', importance: #HIGH },
          { type: #FOR_ACTION, dataAction: 'approveOrder', label: 'Siparişi Onayla', position: 1 },
          { type: #FOR_ACTION, dataAction: 'shipOrder', label: 'Kargoya Ver', position: 2 },
          { type: #FOR_ACTION, dataAction: 'cancelOrder', label: 'İptal Et', position: 3 }
      ]
      @UI.identification: [{ position: 10, label: 'Sipariş No' }]
      @Search.defaultSearchElement: true
  key SalesOrderId,

      @UI.lineItem: [{ position: 15, label: 'Müşteri No', importance: #HIGH }]
      @UI.identification: [{ position: 15, label: 'Müşteri No' }]
      @UI.selectionField: [{ position: 5 }]
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZPAL_C_CUSTOMER', element: 'CustomerId' } }]
      CustomerId,

      @UI.lineItem: [{ position: 20, label: 'Müşteri Ünvanı', importance: #HIGH }]
      @UI.identification: [{ position: 20, label: 'Müşteri Ünvanı' }]
      @UI.selectionField: [{ position: 10 }]
      @Search.defaultSearchElement: true
      CustomerName,

      @UI.lineItem: [{ position: 30, label: 'Sipariş Tarihi' }]
      @UI.identification: [{ position: 30, label: 'Sipariş Tarihi' }]
      OrderDate,

      @UI.lineItem: [{ position: 40, label: 'Toplam Tutar' }]
      @UI.identification: [{ position: 40, label: 'Toplam Tutar' }]
      @Semantics.amount.currencyCode: 'CurrencyCode'
      TotalAmount,

      CurrencyCode,

      @UI.lineItem: [{ position: 50, label: 'Sipariş Durumu' }]
      @UI.identification: [{ position: 50, label: 'Sipariş Durumu' }]
      @UI.selectionField: [{ position: 20 }]
      OrderStatus,

      @UI.lineItem: [{ position: 60, label: 'Kargo Firması' }]
      @UI.fieldGroup: [{ qualifier: 'ShippingGroup', position: 10, label: 'Kargo Firması' }]
      ShippingCarrier,

      @UI.lineItem: [{ position: 70, label: 'Kargo Takip No' }]
      @UI.fieldGroup: [{ qualifier: 'ShippingGroup', position: 20, label: 'Kargo Takip No' }]
      TrackingNumber,

      @UI.fieldGroup: [{ qualifier: 'ShippingGroup', position: 30, label: 'Teslimat Adresi' }]
      DeliveryAddress,

      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,

      _Items : redirected to composition child ZC_SD_SO_ITEM,
      _Customer : redirected to ZPAL_C_CUSTOMER
}

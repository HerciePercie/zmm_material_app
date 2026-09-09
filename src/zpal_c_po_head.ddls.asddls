@EndUserText.label: 'Satin Alma Siparis Baslik - UI'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
@ObjectModel.semanticKey: ['PoId']
@UI.headerInfo: {
    typeName: 'Satın Alma Siparişi',
    typeNamePlural: 'Satın Alma Siparişleri',
    title: { type: #STANDARD, value: 'PoId' },
    description: { value: 'VendorName' }
}
define root view entity ZPAL_C_PO_HEAD
  provider contract transactional_query
  as projection on ZPAL_I_PO_HEAD
{
      @UI.facet: [
          { id: 'General', purpose: #STANDARD, type: #IDENTIFICATION_REFERENCE, label: 'Sipariş Genel Bilgileri', position: 10 },
          { id: 'Items', purpose: #STANDARD, type: #LINEITEM_REFERENCE, targetElement: '_Items', label: 'Sipariş Kalemleri', position: 20 }
      ]

      @UI.lineItem: [
          { position: 10, importance: #HIGH },
          { type: #FOR_ACTION, dataAction: 'approvePO', label: 'Siparişi Onayla', position: 1 },
          { type: #FOR_ACTION, dataAction: 'receiveGoods', label: 'Mal Kabul', position: 2 },
          { type: #FOR_ACTION, dataAction: 'cancelPO', label: 'İptal Et', position: 3 }
      ]
      @UI.identification: [{ position: 10 }]
      @Search.defaultSearchElement: true
  key PoId,

      @UI.lineItem: [{ position: 20, importance: #HIGH }]
      @UI.identification: [{ position: 20 }]
      @UI.selectionField: [{ position: 10 }]
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZPAL_C_VENDOR', element: 'VendorId' } }]
      VendorId,

      @UI.lineItem: [{ position: 30, importance: #HIGH }]
      @UI.identification: [{ position: 30 }]
      @Search.defaultSearchElement: true
      VendorName,

      @UI.lineItem: [{ position: 40 }]
      @UI.identification: [{ position: 40 }]
      OrderDate,

      @UI.lineItem: [{ position: 50 }]
      @UI.identification: [{ position: 50 }]
      @Semantics.amount.currencyCode: 'CurrencyCode'
      TotalAmount,

      CurrencyCode,

      @UI.lineItem: [{ position: 60 }]
      @UI.identification: [{ position: 60 }]
      @UI.selectionField: [{ position: 20 }]
      PoStatus,

      @UI.identification: [{ position: 70 }]
      DeliveryNote,

      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,

      _Items  : redirected to composition child ZPAL_C_PO_ITEM,
      _Vendor : redirected to ZPAL_C_VENDOR
}

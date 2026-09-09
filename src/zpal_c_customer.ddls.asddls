@EndUserText.label: 'Musteri Ana Verisi - UI Projection'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
@ObjectModel.semanticKey: ['CustomerId']
@UI.headerInfo: {
    typeName: 'Müşteri',
    typeNamePlural: 'Müşteriler',
    title: { type: #STANDARD, value: 'Name' },
    description: { value: 'CustomerId' }
}
define root view entity ZPAL_C_CUSTOMER
  provider contract transactional_query
  as projection on ZPAL_I_CUSTOMER
{
      @UI.facet: [
          { id: 'General', purpose: #STANDARD, type: #IDENTIFICATION_REFERENCE, label: 'Genel Bilgiler', position: 10 },
          { id: 'Contact', purpose: #STANDARD, type: #FIELDGROUP_REFERENCE, targetQualifier: 'ContactGroup', label: 'İletişim', position: 20 },
          { id: 'Address', purpose: #STANDARD, type: #FIELDGROUP_REFERENCE, targetQualifier: 'AddressGroup', label: 'Adres', position: 30 }
      ]

      @UI.lineItem: [{ position: 10, importance: #HIGH, label: 'Müşteri No' }]
      @UI.identification: [{ position: 10, label: 'Müşteri No' }]
      @UI.selectionField: [{ position: 10 }]
      @Search.defaultSearchElement: true
  key CustomerId,

      @UI.lineItem: [{ position: 20, importance: #HIGH, label: 'Ünvan' }]
      @UI.identification: [{ position: 20, label: 'Ünvan' }]
      @UI.selectionField: [{ position: 20 }]
      @Search.defaultSearchElement: true
      Name,

      @UI.lineItem: [{ position: 30, label: 'Vergi No' }]
      @UI.identification: [{ position: 30, label: 'Vergi No' }]
      TaxNumber,

      @UI.lineItem: [{ position: 40, label: 'Müşteri Grubu' }]
      @UI.identification: [{ position: 40, label: 'Müşteri Grubu' }]
      @UI.selectionField: [{ position: 30 }]
      CustomerGroup,

      @UI.identification: [{ position: 50, label: 'E-Posta' }]
      @UI.fieldGroup: [{ qualifier: 'ContactGroup', position: 10, label: 'E-Posta' }]
      @Semantics.eMail.address: true
      Email,

      @UI.identification: [{ position: 60, label: 'Telefon' }]
      @UI.fieldGroup: [{ qualifier: 'ContactGroup', position: 20, label: 'Telefon' }]
      Phone,

      @UI.fieldGroup: [{ qualifier: 'AddressGroup', position: 10, label: 'Sokak / Cadde' }]
      Street,

      @UI.lineItem: [{ position: 50, label: 'Şehir' }]
      @UI.fieldGroup: [{ qualifier: 'AddressGroup', position: 20, label: 'Şehir' }]
      City,

      @UI.fieldGroup: [{ qualifier: 'AddressGroup', position: 30, label: 'Posta Kodu' }]
      PostalCode,

      @UI.fieldGroup: [{ qualifier: 'AddressGroup', position: 40, label: 'Ülke' }]
      Country,

      @UI.lineItem: [{ position: 60, label: 'Sipariş Bloğu' }]
      @UI.identification: [{ position: 70, label: 'Sipariş Bloğu' }]
      OrderBlock,

      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt
}

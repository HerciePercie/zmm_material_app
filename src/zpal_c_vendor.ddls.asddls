@EndUserText.label: 'Tedarikci Ana Verisi - UI Projection'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
@ObjectModel.semanticKey: ['VendorId']
@UI.headerInfo: {
    typeName: 'Tedarikçi',
    typeNamePlural: 'Tedarikçiler',
    title: { type: #STANDARD, value: 'Name' },
    description: { value: 'VendorId' }
}
define root view entity ZPAL_C_VENDOR
  provider contract transactional_query
  as projection on ZPAL_I_VENDOR
{
      @UI.facet: [
          { id: 'General', purpose: #STANDARD, type: #IDENTIFICATION_REFERENCE, label: 'Genel Bilgiler', position: 10 },
          { id: 'Contact', purpose: #STANDARD, type: #FIELDGROUP_REFERENCE, targetQualifier: 'ContactGroup', label: 'İletişim', position: 20 },
          { id: 'Address', purpose: #STANDARD, type: #FIELDGROUP_REFERENCE, targetQualifier: 'AddressGroup', label: 'Adres', position: 30 }
      ]

      @UI.lineItem: [{ position: 10, importance: #HIGH }]
      @UI.identification: [{ position: 10 }]
      @UI.selectionField: [{ position: 10 }]
      @Search.defaultSearchElement: true
  key VendorId,

      @UI.lineItem: [{ position: 20, importance: #HIGH }]
      @UI.identification: [{ position: 20 }]
      @UI.selectionField: [{ position: 20 }]
      @Search.defaultSearchElement: true
      Name,

      @UI.lineItem: [{ position: 30 }]
      @UI.identification: [{ position: 30 }]
      TaxNumber,

      @UI.lineItem: [{ position: 40 }]
      @UI.identification: [{ position: 40 }]
      @UI.selectionField: [{ position: 30 }]
      VendorGroup,

      @UI.identification: [{ position: 50 }]
      @UI.fieldGroup: [{ qualifier: 'ContactGroup', position: 10 }]
      @Semantics.eMail.address: true
      Email,

      @UI.identification: [{ position: 60 }]
      @UI.fieldGroup: [{ qualifier: 'ContactGroup', position: 20 }]
      Phone,

      @UI.fieldGroup: [{ qualifier: 'AddressGroup', position: 10 }]
      Street,

      @UI.lineItem: [{ position: 50 }]
      @UI.fieldGroup: [{ qualifier: 'AddressGroup', position: 20 }]
      City,

      @UI.fieldGroup: [{ qualifier: 'AddressGroup', position: 30 }]
      PostalCode,

      @UI.fieldGroup: [{ qualifier: 'AddressGroup', position: 40 }]
      Country,

      @UI.lineItem: [{ position: 60 }]
      @UI.identification: [{ position: 70 }]
      PurchaseBlock,

      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt
}

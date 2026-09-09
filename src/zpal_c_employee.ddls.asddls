@EndUserText.label: 'Personel - UI'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
@ObjectModel.semanticKey: ['EmpId']
@UI.headerInfo: {
    typeName: 'Personel',
    typeNamePlural: 'Personeller',
    title: { type: #STANDARD, value: 'FullName' },
    description: { value: 'EmpId' }
}
define root view entity ZPAL_C_EMPLOYEE
  provider contract transactional_query
  as projection on ZPAL_I_EMPLOYEE
{
      @UI.facet: [
          { id: 'General', purpose: #STANDARD, type: #IDENTIFICATION_REFERENCE, label: 'Kişisel Bilgiler', position: 10 },
          { id: 'Job', purpose: #STANDARD, type: #FIELDGROUP_REFERENCE, targetQualifier: 'JobGroup', label: 'Görev & Ücret', position: 20 }
      ]

      @UI.lineItem: [{ position: 10, importance: #HIGH }]
      @UI.identification: [{ position: 10 }]
      @UI.selectionField: [{ position: 10 }]
      @Search.defaultSearchElement: true
  key EmpId,

      @UI.lineItem: [{ position: 20, importance: #HIGH }]
      @UI.identification: [{ position: 20 }]
      @Search.defaultSearchElement: true
      FirstName,

      @UI.lineItem: [{ position: 30, importance: #HIGH }]
      @UI.identification: [{ position: 30 }]
      @Search.defaultSearchElement: true
      LastName,

      FullName,

      @UI.lineItem: [{ position: 40 }]
      @UI.identification: [{ position: 40 }]
      @UI.selectionField: [{ position: 20 }]
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZPAL_I_DEPARTMENT', element: 'DeptId' } }]
      DepartmentId,

      @UI.lineItem: [{ position: 50 }]
      @UI.identification: [{ position: 50 }]
      @UI.fieldGroup: [{ qualifier: 'JobGroup', position: 10 }]
      Positionn,

      @UI.fieldGroup: [{ qualifier: 'JobGroup', position: 20 }]
      @UI.identification: [{ position: 60 }]
      HireDate,

      @UI.fieldGroup: [{ qualifier: 'JobGroup', position: 30 }]
      @Semantics.amount.currencyCode: 'CurrencyCode'
      MonthlySalary,

      CurrencyCode,

      @UI.identification: [{ position: 70 }]
      @Semantics.eMail.address: true
      Email,

      @UI.identification: [{ position: 80 }]
      Phone,

      @UI.lineItem: [{ position: 60 }]
      @UI.identification: [{ position: 90 }]
      @UI.selectionField: [{ position: 30 }]
      EmpStatus,

      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt
}

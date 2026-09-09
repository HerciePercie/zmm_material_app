@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Personel - Interface'
define root view entity ZPAL_I_EMPLOYEE
  as select from zpal_employee
  association [0..1] to ZPAL_I_DEPARTMENT as _Department on $projection.DepartmentId = _Department.DeptId
{
  @EndUserText.label: 'Personel No'
  key emp_id                as EmpId,

      @EndUserText.label: 'Ad'
      first_name            as FirstName,

      @EndUserText.label: 'Soyad'
      last_name             as LastName,

      @EndUserText.label: 'Ad Soyad'
      concat_with_space( first_name, last_name, 1 ) as FullName,

      @EndUserText.label: 'Departman'
      @ObjectModel.foreignKey.association: '_Department'
      department_id         as DepartmentId,

      @EndUserText.label: 'Pozisyon'
      positionn              as Positionn,

      @EndUserText.label: 'İşe Giriş Tarihi'
      hire_date             as HireDate,

      @EndUserText.label: 'E-Posta'
      email                 as Email,

      @EndUserText.label: 'Telefon'
      phone                 as Phone,

      @EndUserText.label: 'Aylık Maaş'
      @Semantics.amount.currencyCode: 'CurrencyCode'
      monthly_salary        as MonthlySalary,

      @EndUserText.label: 'Para Birimi'
      currency_code         as CurrencyCode,

      @EndUserText.label: 'Durum'
      emp_status            as EmpStatus,

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

      _Department
}

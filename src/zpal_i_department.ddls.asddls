@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Departman'
@ObjectModel.representativeKey: 'DeptId'
@Search.searchable: true
define view entity ZPAL_I_DEPARTMENT
  as select from zpal_department
{
      @EndUserText.label: 'Departman'
      @Search.defaultSearchElement: true
  key dept_id     as DeptId,

      @EndUserText.label: 'Departman Adı'
      @Semantics.text: true
      @Search.defaultSearchElement: true
      dept_name   as DeptName,

      @EndUserText.label: 'Masraf Yeri'
      cost_center as CostCenter
}

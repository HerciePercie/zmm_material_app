@EndUserText.label: 'SD Kargoya Verme Parametreleri'
define abstract entity ZD_SD_SHIP_PARAM
{
  @EndUserText.label: 'Kargo Firması (Örn: Yurtiçi, Aras, DHL)'
  @UI.defaultValue: 'Yurtiçi Kargo'
  shipping_carrier : abap.char(30);

  @EndUserText.label: 'Kargo Takip / Barkod Numarası'
  tracking_number  : abap.char(40);
}

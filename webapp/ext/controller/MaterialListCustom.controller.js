sap.ui.define([
    "sap/ui/core/mvc/ControllerExtension",
    "sap/m/MessageBox",
    "sap/m/MessageToast",
    "sap/m/Dialog",
    "sap/m/Button",
    "sap/m/Label",
    "sap/m/Input",
    "sap/m/Select",
    "sap/ui/core/Item",
    "sap/ui/layout/form/SimpleForm"
], function (ControllerExtension, MessageBox, MessageToast, Dialog, Button, Label, Input, Select, Item, SimpleForm) {
    "use strict";

    return ControllerExtension.extend("pala.erp.zmmmaterialapp.ext.controller.MaterialListCustom", {

        override: {
            onInit: function () {
            }
        },

        onOpenCreateDialog: function () {
            var oView = this.base.getView();
            var oModel = oView.getModel();
            var that = this;

            var oInpMatId = new Input({ placeholder: "Örn: MAT-300010" });
            var oInpMatDesc = new Input({ placeholder: "Örn: Slim Fit Polo Yaka T-Shirt" });
            var oSelMatType = new Select({
                items: [
                    new Item({ key: "FERT", text: "FERT - Mamul (Satılabilir Ürün)" }),
                    new Item({ key: "ROH", text: "ROH - Hammadde" }),
                    new Item({ key: "HALB", text: "HALB - Yarı Mamul" })
                ],
                selectedKey: "FERT"
            });
            var oInpUnit = new Select({
                items: [
                    new Item({ key: "ST", text: "ST - Adet" }),
                    new Item({ key: "M", text: "M - Metre" }),
                    new Item({ key: "KG", text: "KG - Kilogram" })
                ],
                selectedKey: "ST"
            });
            var oInpStock = new Input({ type: "Number", value: "100" });
            var oInpPrice = new Input({ type: "Number", value: "450.00" });

            var oDialog = new Dialog({
                title: "Yeni Malzeme Tanımla (MM Depo Girişi)",
                contentWidth: "460px",
                content: [
                    new SimpleForm({
                        editable: true,
                        layout: "ResponsiveGridLayout",
                        content: [
                            new Label({ text: "Malzeme Kodu", required: true }),
                            oInpMatId,

                            new Label({ text: "Malzeme Açıklaması", required: true }),
                            oInpMatDesc,

                            new Label({ text: "Malzeme Tipi" }),
                            oSelMatType,

                            new Label({ text: "Ölçü Birimi" }),
                            oInpUnit,

                            new Label({ text: "Mevcut Stok Miktarı", required: true }),
                            oInpStock,

                            new Label({ text: "Birim Satış Fiyatı (TRY)", required: true }),
                            oInpPrice
                        ]
                    })
                ],
                beginButton: new Button({
                    text: "Kaydet ve Depoya Al",
                    type: "Emphasized",
                    press: function () {
                        that.onSaveMaterial(oDialog, oModel, oInpMatId, oInpMatDesc, oSelMatType, oInpUnit, oInpPrice, oInpStock);
                    }
                }),
                endButton: new Button({
                    text: "İptal",
                    press: function () {
                        oDialog.close();
                    }
                }),
                afterClose: function () {
                    oDialog.destroy();
                }
            });

            oView.addDependent(oDialog);
            oDialog.open();
        },

        onSaveMaterial: function (oDialog, oModel, oInpMatId, oInpMatDesc, oSelMatType, oInpUnit, oInpPrice, oInpStock) {
            var sMatId   = oInpMatId.getValue().trim().toUpperCase();
            var sMatDesc = oInpMatDesc.getValue().trim();
            var sMatType = oSelMatType.getSelectedKey();
            var sUnit    = oInpUnit.getSelectedKey();
            var fPrice   = parseFloat(oInpPrice.getValue());
            var fStock   = parseFloat(oInpStock.getValue()) || 0;

            if (!sMatId || !sMatDesc || isNaN(fPrice)) {
                MessageBox.error("Lütfen Malzeme Kodu, Açıklama ve Geçerli Bir Fiyat girin!");
                return;
            }

            var oNewEntry = {
                MatId: sMatId,
                MatDesc: sMatDesc,
                MatType: sMatType,
                BaseUnit: sUnit,
                StockQty: fStock.toString(),
                UnitPrice: fPrice.toString(),
                Currency: "TRY"
            };

            var oListBinding = oModel.bindList("/Material");
            var oContext = oListBinding.create(oNewEntry);

            oContext.created().then(function () {
                MessageToast.show("Malzeme veritabanına başarıyla kaydedildi: " + sMatId);
                oDialog.close();
                setTimeout(function () {
                    window.location.reload();
                }, 500);
            }).catch(function (oError) {
                MessageBox.error("Kayıt hatası: " + (oError.message || "Bu malzeme kodu zaten kayıtlı olabilir!"));
            });
        }

    });
});
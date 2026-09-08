sap.ui.define([
    "sap/ui/core/mvc/Controller",
    "sap/m/MessageBox"
], function (Controller, MessageBox) {
    "use strict";

    return Controller.extend("pala.erp.zmmmaterialapp.controller.Home", {
        
        onInit: function () {
            // Ana sayfa yüklendi
        },

        // MM Modülüne Tıklanınca Malzeme Listesine Git
        onNavToMM: function () {
            var oRouter = this.getOwnerComponent().getRouter();
            oRouter.navTo("MaterialList");
        },

        // Diğer Modüllere Tıklanınca Uyarı Ver
        onDisabledModule: function (oEvent) {
            var sTitle = oEvent.getSource().getHeader();
            MessageBox.information(
                sTitle + " şu anda geliştirme aşamasındadır.\nAktif Modül: MM (Malzeme Yönetimi)",
                {
                    title: "Pala Giyim ERP - Modül Bilgilendirmesi"
                }
            );
        }
    });
});
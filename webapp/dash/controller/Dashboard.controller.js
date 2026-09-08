sap.ui.define([
    "sap/ui/core/mvc/Controller",
    "sap/ui/model/json/JSONModel",
    "sap/ui/core/format/NumberFormat",
    "sap/m/MessageToast"
], function (Controller, JSONModel, NumberFormat, MessageToast) {
    "use strict";

    var STATUS_TEXT = {
        "01": "01 - Yeni / Taslak",
        "02": "02 - Onaylandi",
        "03": "03 - Kargolandi",
        "04": "04 - Iptal"
    };

    return Controller.extend("pala.erp.zpaldashapp.controller.Dashboard", {

        onInit: function () {
            var oDash = new JSONModel({
                kpi: { orderCount: "0", revenue: "0", stockValue: "0", debit: "0" },
                sd: [], sales: [], stock: [], fin: []
            });
            this.getView().setModel(oDash, "dash");

            this._num = NumberFormat.getFloatInstance({ groupingEnabled: true, decimals: 2 });
            this._int = NumberFormat.getIntegerInstance({ groupingEnabled: true });

            this._loadData();
        },

        _getOData: function () {
            return this.getView().getModel()
                || (this.getOwnerComponent() && this.getOwnerComponent().getModel());
        },

        _readList: function (oModel, sPath) {
            var oBinding = oModel.bindList(sPath);
            return oBinding.requestContexts(0, 500).then(function (aCtx) {
                return aCtx.map(function (c) { return c.getObject(); });
            });
        },

        _pct: function (fVal, fMax) {
            if (!fMax || fMax <= 0) { return 0; }
            var p = (Number(fVal || 0) / fMax) * 100;
            if (p < 0) { p = 0; }
            if (p > 100) { p = 100; }
            return p;
        },

        _loadData: function () {
            var that = this;
            var oDash = this.getView().getModel("dash");
            var oModel = this._getOData();

            if (!oModel) {
                console.error("Dashboard: OData modeli bulunamadi (manifest 'mainService').");
                MessageToast.show("Dashboard: servis modeli yuklenemedi.");
                return;
            }

            Promise.all([
                this._readList(oModel, "/DashSd"),
                this._readList(oModel, "/DashSales"),
                this._readList(oModel, "/DashStock"),
                this._readList(oModel, "/DashFin")
            ]).then(function (aRes) {
                var aSd = aRes[0], aSales = aRes[1], aStock = aRes[2], aFin = aRes[3];

                var iOrders = 0, fRevenue = 0, fStock = 0, fDebit = 0;
                var fMaxRevenue = 0, fMaxStock = 0;

                aSales.forEach(function (r) {
                    var v = Number(r.Revenue || 0);
                    if (v > fMaxRevenue) { fMaxRevenue = v; }
                });
                aStock.forEach(function (r) {
                    var v = Number(r.StockValue || 0);
                    if (v > fMaxStock) { fMaxStock = v; }
                });

                aSd.forEach(function (r) {
                    r.OrderStatusText = STATUS_TEXT[r.OrderStatus] || r.OrderStatus;
                    r.TotalAmountFmt = that._num.format(r.TotalAmount || 0);
                    iOrders += Number(r.OrderCount || 0);
                });

                aSales.forEach(function (r) {
                    r.RevenueFmt = that._num.format(r.Revenue || 0);
                    r.RevenuePct = that._pct(r.Revenue, fMaxRevenue);
                    fRevenue += Number(r.Revenue || 0);
                });

                aStock.forEach(function (r) {
                    r.StockQtyFmt = that._num.format(r.StockQty || 0);
                    r.UnitPriceFmt = that._num.format(r.UnitPrice || 0);
                    r.StockValueFmt = that._num.format(r.StockValue || 0);
                    r.StockValuePct = that._pct(r.StockValue, fMaxStock);
                    fStock += Number(r.StockValue || 0);
                });

                aFin.forEach(function (r) {
                    r.TotalDebitFmt = that._num.format(r.TotalDebit || 0);
                    fDebit += Number(r.TotalDebit || 0);
                });

                oDash.setData({
                    kpi: {
                        orderCount: that._int.format(iOrders),
                        revenue: that._num.format(fRevenue),
                        stockValue: that._num.format(fStock),
                        debit: that._num.format(fDebit)
                    },
                    sd: aSd,
                    sales: aSales,
                    stock: aStock,
                    fin: aFin
                });
            }).catch(function (oErr) {
                console.error("Dashboard veri yukleme hatasi:", oErr);
                MessageToast.show("Dashboard verileri yuklenemedi: " + (oErr && oErr.message));
            });
        }
    });
});
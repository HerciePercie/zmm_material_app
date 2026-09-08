sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"pala/erp/zmmmaterialapp/test/integration/pages/MaterialList.gen",
	"pala/erp/zmmmaterialapp/test/integration/pages/MaterialObjectPage.gen",
	"pala/erp/zmmmaterialapp/test/integration/pages/StockMovementObjectPage.gen"
], function (JourneyRunner, MaterialListGenerated, MaterialObjectPageGenerated, StockMovementObjectPageGenerated) {
    'use strict';

    const runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('pala/erp/zmmmaterialapp') + '/test/flp.html#app-preview',
        pages: {
			onTheMaterialListGenerated: MaterialListGenerated,
			onTheMaterialObjectPageGenerated: MaterialObjectPageGenerated,
			onTheStockMovementObjectPageGenerated: StockMovementObjectPageGenerated
        },
        async: true
    });

    return runner;
});


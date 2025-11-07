sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"appmngpmyroperty/test/integration/pages/PropertiesList",
	"appmngpmyroperty/test/integration/pages/PropertiesObjectPage"
], function (JourneyRunner, PropertiesList, PropertiesObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('appmngpmyroperty') + '/test/flp.html#app-preview',
        pages: {
			onThePropertiesList: PropertiesList,
			onThePropertiesObjectPage: PropertiesObjectPage
        },
        async: true
    });

    return runner;
});


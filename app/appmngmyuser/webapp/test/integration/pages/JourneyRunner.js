sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"appmngmyuser/test/integration/pages/UsersObjectPage"
], function (JourneyRunner, UsersObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('appmngmyuser') + '/test/flp.html#app-preview',
        pages: {
			onTheUsersObjectPage: UsersObjectPage
        },
        async: true
    });

    return runner;
});


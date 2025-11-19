sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"appmnguserprofiles/test/integration/pages/UsersList",
	"appmnguserprofiles/test/integration/pages/UsersObjectPage"
], function (JourneyRunner, UsersList, UsersObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('appmnguserprofiles') + '/test/flp.html#app-preview',
        pages: {
			onTheUsersList: UsersList,
			onTheUsersObjectPage: UsersObjectPage
        },
        async: true
    });

    return runner;
});


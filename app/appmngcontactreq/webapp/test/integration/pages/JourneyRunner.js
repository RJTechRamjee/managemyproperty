sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"appmngcontactreq/test/integration/pages/ContactRequestsList",
	"appmngcontactreq/test/integration/pages/ContactRequestsObjectPage",
	"appmngcontactreq/test/integration/pages/ConactReqMessagesObjectPage"
], function (JourneyRunner, ContactRequestsList, ContactRequestsObjectPage, ConactReqMessagesObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('appmngcontactreq') + '/test/flp.html#app-preview',
        pages: {
			onTheContactRequestsList: ContactRequestsList,
			onTheContactRequestsObjectPage: ContactRequestsObjectPage,
			onTheConactReqMessagesObjectPage: ConactReqMessagesObjectPage
        },
        async: true
    });

    return runner;
});


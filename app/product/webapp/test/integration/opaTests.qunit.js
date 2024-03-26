sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'alfa/product/test/integration/FirstJourney',
		'alfa/product/test/integration/pages/ProductsList',
		'alfa/product/test/integration/pages/ProductsObjectPage',
		'alfa/product/test/integration/pages/ReviewsObjectPage'
    ],
    function(JourneyRunner, opaJourney, ProductsList, ProductsObjectPage, ReviewsObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('alfa/product') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onTheProductsList: ProductsList,
					onTheProductsObjectPage: ProductsObjectPage,
					onTheReviewsObjectPage: ReviewsObjectPage
                }
            },
            opaJourney.run
        );
    }
);
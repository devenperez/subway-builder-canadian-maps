(function () {
    const api = window.SubwayBuilderAPI;

    if (!api) {
        console.error('[Canadian Cities] SubwayBuilderAPI not found!');
        return;
    }

    console.log('[Canadian Cities] Loaded!');

    const cityData = [
        {
            "code": "TOR",
            "name": "Toronto",
            "description": "Shuttle workers from condo developments to downtown in Canada's largest city",
            "bbox": [
                -80.01272,
                43.29424,
                -78.67409,
                44.17387
            ],
            "population": 6202225,
        },
        {
            "code": "MON",
            "name": "Montreal",
            "description": "Link mid-river islands to build a network worthy of the Paris of North America",
            "bbox": [
                -74.33165,
                45.25121,
                -73.21233,
                45.89545
            ],
            "population": 4291732,
        },
        {
            "code": "VAN",
            "name": "Vancouver",
            "description": "Connect dense TOD clusters to downtown with elevated light metro in this wet Pacific coast metropolis",
            "bbox": [
                -123.37615,
                49.00190,
                -122.38436,
                49.43041
            ],
            "population": 2642825,
        },
        {
            "code": "OTT",
            "name": "Ottawa",
            "description": "Shuttle bilingual bureaucrats around the fast growing Canadian capital",
            "bbox": [
                -76.41776,
                44.91732,
                -75.18226,
                45.64402
            ],
            "population": 1488307,
        },
        {
            "code": "CGY",
            "name": "Calgary",
            "description": "Show that transit can find success even in the oil capital of Canada",
            "bbox": [
                -114.44704,
                50.75993,
                -113.72713,
                51.29567
            ],
            "population": 1481806,
        },
        {
            "code": "EDM",
            "name": "Edmonton",
            "description": "Build grand river bridges to link planned suburbs with Universities and Malls",
            "bbox": [
                -113.85599,
                53.25303,
                -113.12874,
                53.80092
            ],
            "population": 1418118,
        },
        {
            "code": "QC",
            "name": "Quebec City",
            "description": "Build a metro fit for the historic provincial capital",
            "bbox": [
                -71.61498,
                46.52724,
                -70.92852,
                47.02689
            ],
            "population": 839311,
        },
        {
            "code": "WPG",
            "name": "Winnipeg",
            "description": "Plan a network across the gateway to the west",
            "bbox": [
                -97.48573,
                49.62521,
                -96.81898,
                50.08236
            ],
            "population": 783099,
        },
    ]

    cityData.forEach(city => {
        api.registerCity({
            code: city.code,
            name: city.name,
            description: city.description,
            population: city.population,
            initialViewState: {
                zoom: 13.5,
                latitude: city.bbox[1] + (city.bbox[3] - city.bbox[1]) / 2,
                longitude: city.bbox[0] + (city.bbox[2] - city.bbox[0]) / 2,
                bearing: 0
            },
        });

        api.map.setTileURLOverride({
            cityCode: city.code,
            tilesUrl: `http://localhost:24575/${city.code}/{z}/{x}/{y}.mvt`,
            foundationTilesUrl: `http://localhost:24575/${city.code}/{z}/{x}/{y}.mvt`,
            maxZoom: 15
        });


        api.cities.setCityDataFiles(city.code, {
            buildingsIndex: `/data/${city.code}/buildings_index.json.gz`,
            demandData: `/data/${city.code}/demand_data.json.gz`,
            roads: `/data/${city.code}/roads.geojson.gz`,
            runwaysTaxiways: `/data/${city.code}/runways_taxiways.geojson.gz`,
            // oceanDepthIndex: `/data/${city.code}/ocean_depth_index.json.gz` // Optional
        });

        api.map.setDefaultLayerVisibility(city.code, {
            buildingFoundations: false,
            oceanFoundations: false
        });

        console.log('[Canadian Cities] Added city:', city.name + ' (' + city.code + ')');
    });

    api.cities.registerTab({
        id: 'canada',
        label: 'Canada',
        emoji: '🇨🇦',
        cityCodes: cityData.map(city => city.code)
    });
    console.log('[Canadian Cities] Added cities to Canada tab');

})();
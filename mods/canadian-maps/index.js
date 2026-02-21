(function () {
    const api = window.SubwayBuilderAPI;

    if (!api) {
        console.error('[Canadian Cities] SubwayBuilderAPI not found!');
        return;
    }

    api.cities.registerTab({
        id: 'canada',
        label: 'Canada',
        emoji: '🇨🇦',
        cityCodes: cityData.map(city => city.code)
    });
    console.log('[Canadian Cities] Added cities to Canada tab');

})();
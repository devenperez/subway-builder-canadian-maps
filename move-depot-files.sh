#/bin/bash

for CITY_DIR in cities/*; do
  [ -d "$CITY_DIR" ] || continue
  CITY="${CITY_DIR##*/}"

  rm cities/${CITY}/{buildings_index.*,roads.geojson*,runways_taxiways.geojson*,$CITY.pmtiles,${CITY}_foundations.pmtiles,ocean_depth_index.json*,ocean_foundations.geojson*}
  cp depot/out/${CITY}/{buildings_index.json.gz,buildings_index.bin.gz,roads.geojson,runways_taxiways.geojson,$CITY.pmtiles,${CITY}_foundations.pmtiles,ocean_depth_index.json.gz} cities/$CITY/
done

cd "$(dirname "$0")" || exit

gzip cities/*/roads.geojson
gzip cities/*/runways_taxiways.geojson
gzip cities/*/demand_data.json
gzip cities/*/buildings_index.json
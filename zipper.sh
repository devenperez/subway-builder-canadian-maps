#!/bin/bash

# Navigate to the directory containing the city subdirectories
cd "$(dirname "$0")/cities" || exit
cities_dir="$(pwd)"
rm -rf ../cities-out
mkdir -p ../cities-out

# Loop through each subdirectory
for city_code in */; do
    dir="$cities_dir/$city_code"
    echo "Processing $dir..."
    # Check if it's a directory
    if [ -d "$dir" ]; then
        echo "Creating zip for $dir..."
        cd $dir
        cp -r . "../../cities-out/${city_code%/}"
        cd "../../cities-out/${city_code%/}"
        gzip -drq .
        zip -r "../${city_code%/}.zip" demand_data.json buildings_index.json roads.geojson runways_taxiways.geojson *.pmtiles config.json
        rm -rf "../${city_code%/}"
        cd "$cities_dir"
    fi
done
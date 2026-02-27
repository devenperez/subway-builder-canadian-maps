#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <version>"
    exit 1
fi

VERSION="$1"
VERSION_NUMBER=$(echo "$VERSION" | tr -d 'v')

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

        ZIP_FILENAME="../${city_code%/}.zip"
        zip -r "$ZIP_FILENAME" demand_data.json buildings_index.json roads.geojson runways_taxiways.geojson *.pmtiles config.json
        rm -rf "../${city_code%/}"

        # Update update.json for Railyard
        update_file="../../railyard/${city_code%/}-update.json"
        echo "Looking for update file at $(pwd)/$update_file..."
        if [ -f "$update_file" ]; then
            echo "Updating $update_file..."

            TODAYS_DATE=$(date +%F)
            SHA256=$(shasum -a 256 -U "${ZIP_FILENAME}" | cut -d ' ' -f 1)

            JQ_QUERY=".version = \"$VERSION_NUMBER\" 
                    | .game_version = \">=1.0.0\" 
                    | .date = \"$TODAYS_DATE\" 
                    | .changelog = \"Updated map files.\"
                    | .download = \"https://github.com/devenperez/subway-builder-canadian-maps/releases/download/$VERSION/${city_code%/}.zip\"
                    | .sha256 = \"$SHA256\""

            NEW_VERSION=$(echo "{}" | jq "$JQ_QUERY")

            if [ -f "$update_file" ]; then
                echo "Updating $update_file..."
                echo "$(jq ".versions |= [$NEW_VERSION] + ." "$update_file")" > "$update_file"
            else
                echo "Update file $update_file not found."
            fi
        fi

        cd "$cities_dir"
    fi
done

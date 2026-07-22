#!/bin/bash

CITY_CODE=""
CHANGELOG_MESSAGE="Updated map files."

usage() {
    echo "Usage: $0 [-c <CITY_CODE>] [-m <MESSAGE>|--message <MESSAGE>] <version>"
    exit 1
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        -c)
            if [ $# -lt 2 ]; then
                echo "Error: option -c requires an argument." >&2
                usage
            fi
            CITY_CODE="$2"
            shift 2
            ;;
        -m|--message)
            if [ $# -lt 2 ]; then
                echo "Error: option $1 requires an argument." >&2
                usage
            fi
            CHANGELOG_MESSAGE="$2"
            shift 2
            ;;
        --help|-h)
            usage
            ;;
        --)
            shift
            break
            ;;
        -*)
            echo "Error: invalid option $1." >&2
            usage
            ;;
        *)
            break
            ;;
    esac
done

if [ $# -ne 1 ]; then
    usage
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
    city_name="${city_code%/}"
    dir="$cities_dir/$city_code"

    if [ -n "$CITY_CODE" ] && [ "$city_name" != "$CITY_CODE" ]; then
        continue
    fi

    echo "Processing $dir..."
    # Check if it's a directory
    if [ -d "$dir" ]; then
        echo "Creating zip for $dir..."
        cd "$dir"
        cp -r . "../../cities-out/${city_name}"
        cd "../../cities-out/${city_name}"
        gzip -drq .

        if [ -f "config.json" ]; then
            jq --arg version "$VERSION_NUMBER" '.version = $version' config.json > config.json.tmp
            rm config.json
            mv config.json.tmp config.json
        fi

        ZIP_FILENAME="../${city_name}.zip"
        zip -r "$ZIP_FILENAME" *.bin *.json *.geojson *.pmtiles
        rm -rf "../${city_name}"

        # Update update.json for Railyard
        update_file="../../railyard/${city_name}-update.json"
        echo "Looking for update file at $(pwd)/$update_file..."
        if [ -f "$update_file" ]; then
            echo "Updating $update_file..."

            TODAYS_DATE=$(date +%F)
            SHA256=$(shasum -a 256 -U "${ZIP_FILENAME}" | cut -d ' ' -f 1)



            NEW_VERSION=$(jq -n \
                --arg version "$VERSION_NUMBER" \
                --arg game_version ">=1.0.0" \
                --arg date "$TODAYS_DATE" \
                --arg changelog "$CHANGELOG_MESSAGE" \
                --arg download "https://github.com/devenperez/subway-builder-canadian-maps/releases/download/$VERSION/${city_name}.zip" \
                --arg sha256 "$SHA256" \
                '{
                    version: $version,
                    game_version: $game_version,
                    date: $date,
                    changelog: $changelog,
                    download: $download,
                    sha256: $sha256
                }')

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

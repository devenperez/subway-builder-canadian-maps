OS=$(uname -s)
ARCH=$(uname -m)
PORT=24575

if [[ "$OS" == "Linux" ]]; then
    if [[ "$ARCH" == "aarch64" || "$ARCH" == "arm64" ]]; then
        echo "Linux ARM64"

        ./pmtiles-exec/Linux_arm64/pmtiles serve ./map_tiles --port $PORT --cors=*
    elif [[ "$ARCH" == "x86_64" ]]; then
        echo "Linux x86_64"

        ./pmtiles-exec/Linux_x86_64/pmtiles serve ./map_tiles --port $PORT --cors=*
    else
        echo "Linux unknown arch: $ARCH"
    fi
elif [[ "$OS" == "Darwin" ]]; then
    if [[ "$ARCH" == "arm64" ]]; then
        echo "macOS ARM64 (Apple Silicon)"

        ./pmtiles-exec/Darwin_arm64/pmtiles serve ./map_tiles --port $PORT --cors=*
    elif [[ "$ARCH" == "x86_64" ]]; then
        echo "macOS x86_64 (Intel)"

        ./pmtiles-exec/Darwin_x86_64/pmtiles serve ./map_tiles --port $PORT --cors=*
    else
        echo "macOS unknown arch: $ARCH"
    fi
else
    echo "Unsupported OS: $OS"
fi
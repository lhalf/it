set shell := ["bash", "-euc"]

export:
    mkdir -p build
    godot --headless --export-release "Web" "build/index.html"

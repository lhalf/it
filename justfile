set shell := ["bash", "-euc"]

export:
    mkdir build
    godot --headless --verbose --export-release "Web" "build/index.html"

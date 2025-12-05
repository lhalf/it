set shell := ["bash", "-euc"]

export:
    mkdir -p build
    godot --headless --export-release "Web" "build/index.html"

deploy USER HOST:
    scp build/client/* {{USER}}@{{HOST}}:/var/www/client
    ssh {{USER}}@{{HOST}} rm /opt/godot/*
    scp build/server/* {{USER}}@{{HOST}}:/opt/godot
    ssh {{USER}}@{{HOST}} systemctl restart server

status USER HOST:
    ssh {{USER}}@{{HOST}} systemctl status server

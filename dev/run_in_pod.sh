#!/usr/bin/env bash

set -eu

container=godot_dev

podman kill ${container} > /dev/null 2>&1 || true
podman rm ${container} > /dev/null 2>&1 || true

echo "building pod..."
podman build --quiet --file dev/Dockerfile --format=docker --tag ${container} . > /dev/null

podman run \
    -it \
    --replace \
    --security-opt unmask=/proc \
    --name ${container} \
    -v "$(pwd):$(pwd):Z" \
    ${container} \
    /bin/bash -c "cd \"$(pwd)\" && $1"
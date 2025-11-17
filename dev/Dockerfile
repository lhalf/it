FROM docker.io/barichello/godot-ci:4.5.1

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y just fontconfig && \
    rm -rf /var/lib/apt/lists/*
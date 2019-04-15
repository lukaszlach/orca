#!/usr/bin/env bash
log()       { printf "\e[96m[Orca]\e[39m $@\n"; }
log_error() { printf "\e[91m[Orca]\e[39m $@\n"; }
log "Orca"
DOCKER_VERSION=$(docker -v)
if [[ "$DOCKER_VERSION" == *"version 18.09."* ]] || [[ "$DOCKER_VERSION" == *"version 19."* ]]; then
    log "Running on supported Docker version"
    log "$DOCKER_VERSION"
else
    log_error "Docker version not supported (18.09 or newer is required)"
    log_error "$DOCKER_VERSION"
    exit 1
fi

log "Checking dependencies"
set -e
git --version
curl --version | head -n 1
make --version | head -n 1
watch --version || true

log "Pulling Docker images"
docker_pull() {
    log "Pulling $1"
    docker pull "$1" &>/dev/null || (
        log_error "Failed to pull Docker image"
        exit 1
    )
}
docker_pull golang:1.12-alpine
docker_pull mysql:5.7
docker_pull bretfisher/netshoot
docker_pull tecnativa/tcp-proxy
#docker_pull registry:2
#docker_pull lukaszlach/kali-desktop:xfce-top10

echo
log "You are now fully prepared for the workshop (even when offline)"
log "Project repository: https://github.com/lukaszlach/orca"
echo
exit 0
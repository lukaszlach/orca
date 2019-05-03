#!/usr/bin/env bash
log()         { printf "\e[37m[Notice]\e[39m $@\n"; }
log_error()   { printf "\e[91m[Error]\e[39m $@\n"; }
log_success() { printf "\e[92m[Success]\e[39m $@\n"; }
cat <<'banner'
 ____  ____  ____  ____
/  _ \/  __\/   _\/  _ \
| / \||  \/||  /  | / \|
| \_/||    /|  \_ | |-||
\____/\_/\_\\____/\_/ \|

Docker workshop
Łukasz Lach <llach@llach.pl>
https://lach.dev/orca

This script will prepare your machine for the workshop.
It will not install anything, just check Docker and Compose versions and dependent
tools, also pull required Docker images.

Remember that you can always first download the script, review it and run locally:
$ curl -sSfL https://lach.dev/orca-sh -o orca.sh
$ bash orca.sh

Starting in 10 seconds...
banner
sleep 10s

log "Checking Docker and Compose versions"
DOCKER_VERSION=$(docker -v)
if [[ "$DOCKER_VERSION" == *"version 18.09."* ]] || [[ "$DOCKER_VERSION" == *"version 19."* ]]; then
    log_success "Running on supported Docker version"
    log "$DOCKER_VERSION"
else
    log_error "Docker version not supported (18.09 or newer is required)"
    log_error "$DOCKER_VERSION"
    exit 1
fi
DOCKER_COMPOSE_VERSION=$(docker-compose -v)
if [[ "$DOCKER_COMPOSE_VERSION" == *"version 1.22."* ]] || \
    [[ "$DOCKER_COMPOSE_VERSION" == *"version 1.23."* ]] || \
    [[ "$DOCKER_COMPOSE_VERSION" == *"version 1.24."* ]]; then
    log_success "Running on supported Compose version"
    log "$DOCKER_COMPOSE_VERSION"
else
    log_error "Compose version not supported (1.22.0 or newer is required)"
    log_error "$DOCKER_COMPOSE_VERSION"
    exit 1
fi

log "Checking dependencies"
set -e
git --version
curl --version | head -n 1
make --version | head -n 1
watch --version || true
bash --version | head -n 1
#pwsh --version
log_success "All required dependencies are met"

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
docker_pull registry:2
docker_pull lukaszlach/confsubst
docker_pull subfuzion/envtpl
docker_pull moncho/dry
docker_pull portainer/portainer
docker_pull hadolint/hadolint
docker_pull lukaszlach/docker-tc
#docker_pull lukaszlach/kali-desktop:xfce-top10
log_success "Pulled all Docker images"

printf "\n"
log_success "You are now fully prepared for the workshop"
printf "\n"
exit 0
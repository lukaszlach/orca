#!/usr/bin/env bash
log()         { printf "\e[37m[Notice]\e[39m $@\n"; }
log_error()   { printf "\e[91m[Error]\e[39m $@\n"; }
log_success() { printf "\e[92m[Success]\e[39m $@\n"; }
if [ ! -n "$BASH" ]; then
    log_error "Invalid shell, run this script with bash"
    exit 1
fi
cat <<'banner'
 ____  ____  ____  ____    _____ ____  _  _____  ____  ____ 
/  _ \/  __\/   _\/  _ \  /  __//  _ \/ \/__ __\/  _ \/  __\
| / \||  \/||  /  | / \|  |  \  | | \|| |  / \  | / \||  \/|
| \_/||    /|  \__| |-||  |  /_ | |_/|| |  | |  | \_/||    /
\____/\_/\_\\____/\_/ \|  \____\\____/\_/  \_/  \____/\_/\_\

banner

PROJECT_PWD=$(pwd)
cat <<banner
Docker workshop | Editor
Łukasz Lach <llach@llach.pl>
https://lach.dev/orca

This script will pull and run the Orca Editor Docker image.
It is based on Code Server (https://github.com/cdr/code-server) and VS Code projects,
includes all the tools (like git, curl, watch, docker client, docker-compose)
and files (including the lukaszlach/orca repository itself).

Remember that you can always download the script first, review it and run locally:
$ curl -sSfL https://lach.dev/orca-editor -o orca-editor.sh
$ bash orca-editor.sh

The project files will be persisted on your host filesystem.
Running under base path:
  ${PROJECT_PWD}

Starting in 10 seconds...
banner
sleep 10s

set -e
log "Pulling lukaszlach/code-container"
docker pull lukaszlach/code-container &>/dev/null
log "Running lukaszlach/code-container"
docker rm -f orca-editor &>/dev/null || true
docker run -d \
    --name orca-editor \
    --hostname orca \
    --pid host \
    --net host \
    -e EDITOR_UID -e EDITOR_GID \
    -e EDITOR_PASSWORD \
    -e "EDITOR_BANNER=Orca" \
    -e "EDITOR_PORT=${EDITOR_PORT:-8443}" \
    -v "${PROJECT_PWD}:/files" \
    -v /var/run/docker.sock:/var/run/docker.sock \
    lukaszlach/code-container

log_success "Editor is running"
log "Visit http://localhost:$EDITOR_PORT/ in your web browser"
log "All your changes will be persisted under $PROJECT_PWD"
exit 0
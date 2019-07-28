#!/usr/bin/env bash
set -e
if [ ! -n "$BASH" ]; then
    log_error "Invalid shell, run this script with bash"
    exit 1
fi
if [ -z "$VPS_ID" ]; then
    echo "Error: VPS_ID environment variable is not set empty"
    exit 1
fi
docker rm -f orca-tunnel &>/dev/null || true
docker run -d --name orca-tunnel --restart always \
    -p 4040:4040 \
    -p 5000:5000 \
    -p 8000:8000 -p 8080:8080 -p 8081:8081 -p 8443:8443 \
    -p 9000:9000 \
    -p 10080:10080 \
    -e SSH_USER=d -e SSH_PASSWORD=docker -e SSH_PORT=80 \
    lukaszlach/orca-tunnel "vps$VPS_ID.cmd.cat" 4040 5000 8000 8080 8081 8443 9000 10080
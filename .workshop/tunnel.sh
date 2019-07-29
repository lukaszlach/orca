#!/usr/bin/env bash
set -e
cat <<'banner'
 ____  ____  ____  ____    _____  _     _      _      _____ _
/  _ \/  __\/   _\/  _ \  /__ __\/ \ /\/ \  /|/ \  /|/  __// \
| / \||  \/||  /  | / \|    / \  | | ||| |\ ||| |\ |||  \  | |
| \_/||    /|  \_ | |-||    | |  | \_/|| | \||| | \|||  /_ | |_/\
\____/\_/\_\\____/\_/ \|    \_/  \____/\_/  \|\_/  \|\____\\____/

banner
echo -n "Enter your VPS ID: "
read VPS_ID
if [ -z "$VPS_ID" ]; then
    echo "Error: VPS_ID cannot be empty"
    exit 1
fi
echo "Pulling lukaszlach/orca-tunnel"
docker pull -q lukaszlach/orca-tunnel
echo "Running lukaszlach/orca-tunnel through vps$VPS_ID.cmd.cat"
docker rm -f orca-tunnel &>/dev/null || true
docker run -d --name orca-tunnel --restart always \
    -p 4040:4040 \
    -p 5000:5000 \
    -p 8000:8000 -p 8080:8080 -p 8081:8081 -p 8443:8443 \
    -p 9000:9000 \
    -p 10080:10080 \
    -e SSH_USER=d -e SSH_PASSWORD=docker -e SSH_PORT=80 \
    lukaszlach/orca-tunnel "vps$VPS_ID.cmd.cat" 4040 5000 8000 8080 8081 8443 9000 10080

echo
echo "Orca Tunnel up and running"
exit 0
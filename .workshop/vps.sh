#!/usr/bin/env bash
# Docker
curl -sSfL get.docker.com | bash
curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
apt-get install -y bash bash-completion curl wget make jq net-tools procps htop vim git fail2ban socat
curl https://raw.githubusercontent.com/docker/docker-ce/master/components/cli/contrib/completion/bash/docker \
    -o /etc/bash_completion.d/docker.sh

# cntr
wget 'https://github.com/Mic92/cntr/releases/download/1.2.0/cntr-bin-1.2.0-x86_64-unknown-linux-musl' -O /usr/bin/cntr
chmod +x /usr/bin/cntr

# Workshop user
D_UID=12345
D_GID=12345
groupadd -g "$D_GID" d
useradd -m -u "$D_UID" -g "$D_GID" -s /bin/bash d
echo d:docker | chpasswd
adduser d docker
adduser d sudo
mkdir -p /home/d/project
chown d:d /home/d

# SSHd
sed -i "s/.*PasswordAuthentication.*/PasswordAuthentication yes/g" /etc/ssh/sshd_config
sed -i "s/.*Port.*/Port 80/g" /etc/ssh/sshd_config
#sed -i "s/.*ClientAliveInterval.*/ClientAliveInterval 60/g" /etc/ssh/sshd_config
#sed -i "s/.*ClientAliveCountMax.*/ClientAliveCountMax 10/g" /etc/ssh/sshd_config
service sshd restart

# Workshop project
(
    cd /home/d/project
    git clone https://github.com/lukaszlach/orca.git orca/
    chown -R d:d /home/d/project
)

# Workshop preparation script
curl -sSfL lach.dev/orca-sh | bash

# Workshop editor
(
    cd /home/d
    export EDITOR_PORT=18080
    export EDITOR_PASSWORD=docker
    export EDITOR_UID="$D_UID"
    export EDITOR_GID="$D_GID"
    #export EDITOR_CLONE=https://github.com/lukaszlach/orca.git
    curl -sSfL lach.dev/orca-editor | bash
)
docker run -d --name orca-editor-proxy \
    --net host \
    -e LISTEN=:443 -e TALK=127.0.0.1:18080 \
    tecnativa/tcp-proxy
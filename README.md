# Orca

> The killer whale or orca is a toothed whale belonging to the oceanic dolphin family, of which it is the largest member.
> -- Wikipedia

```bash
git clone https://github.com/lukaszlach/orca
cd orca/
```

## Introduction

<details><summary>Install Docker on Linux</summary>
<p>

```bash
# Install Docker 19.03
curl -fsSL https://get.docker.com | VERSION=19.03 CHANNEL=stable sh

# Install Docker under your $HOME as a non-root
curl -fsSL https://get.docker.com/rootless | sh
```

</p>
</details>

<details><summary>Install Docker helpers</summary>
<p>

```bash
# Windows
$ Set-ExecutionPolicy RemoteSigned
$ Install-Module posh-docker
$ Import-Module posh-docker

# Mac
$ brew tap homebrew/completions
$ brew install docker-completion
$ brew install docker-compose-completion

# Linux
$ apt install bash-completion
$ curl https://raw.githubusercontent.com/docker/docker-ce/master/components/cli/contrib/completion/bash/docker -o /etc/bash_completion.d/docker.sh
```

</p>
</details>

<details><summary>Connect to your workshop VPS</summary>
<p>

SSH server listens on ports `6667` and `80`.

```bash
ssh -p 6667 d@vpsX.cmd.cat
```

```bash
ssh -p 6667 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null d@vpsX.cmd.cat
```

</p>
</details>

<details><summary>Start Orca Tunnel</summary>
<p>

Orca Tunnel allows you to tunnel all ports used on the workshop through a SSH connection on port 80 to your VPS.

Run the tunnel with automated scripts or manually using Docker **on your laptop/PC**.
When the tunnel is running you can access all workshop services running on your VPS by using `localhost`. 
In this case you can also access your VPS shell on `http://localhost:8022`.

Start using the automated script:

```bash
# Linux and Mac
# replace with your VPS_ID
bash <(curl -sSfL lach.dev/orca-tunnel) VPS_ID

# Windows
iex ((New-Object System.Net.WebClient).DownloadString('https://lach.dev/orca-tunnel.ps'))
```

Start manually with Docker:

```bash
docker run -d --name orca-tunnel \
    --restart always 
    -p 4040:4040 -p 5000:5000 -p 6080:6080 -p 8000:8000 -p 8022:8022 \
    -p 8080:8080 -p 8081:8081 -p 8443:8443 -p 9000:9000 -p 10080:10080 \
    -e SSH_USER=d -e SSH_PASSWORD=docker -e SSH_PORT=80 \
    lukaszlach/orca-tunnel vpsX.cmd.cat \
    4040 5000 6080 8000 8022 8080 8081 8443 9000 10080
```

</p>
</details>

## Workshop

### Beginner

* [Training](docs/TRAINING.md)

### Intermediate

* [Level 1](docs/LEVEL1.md)
* [Level 2](docs/LEVEL2.md)
* [Level 3](docs/LEVEL3.md)
* [Level 4](docs/LEVEL4.md)

### High

* [Level 5](docs/LEVEL5.md)
* [Level 6](docs/LEVEL6.md)
* [Level 7](docs/LEVEL7.md)

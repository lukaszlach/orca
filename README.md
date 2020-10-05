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

<details><summary>Connect to the workshop VPS</summary>
<p>

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

```bash
# Linux and Mac
# replace with your VPS_ID
bash <(curl -sSfL lach.dev/orca-tunnel) VPS_ID

# Windows
iex ((New-Object System.Net.WebClient).DownloadString('https://lach.dev/orca-tunnel.ps'))
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

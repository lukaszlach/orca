# Orca

> The killer whale or orca is a toothed whale belonging to the oceanic dolphin family, of which it is the largest member.
> -- Wikipedia

```bash
git clone https://github.com/lukaszlach/orca
cd orca/
bash workshop.sh
bash editor.sh
```

## Introduction

<details><summary>Install Docker on Linux</summary>
<p>

```bash
# Install Docker 18.09
curl -fsSL https://get.docker.com | VERSION=18.09 CHANNEL=stable sh

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

<details><summary>Enter Linux virtual machine</summary>
<p>

```bash
# Windows and Mac
$ docker run -it --rm --privileged --pid=host justincormack/nsenter1

# Mac
$ screen ~/Library/Containers/com.docker.docker/Data/vms/0/tty
```

</p>
</details>

## Workshop

* [Level 1](LEVEL1.md)
* [Level 2](LEVEL2.md)
* [Level 3](LEVEL3.md)
* [Level 4](LEVEL4.md)
* [Level 5](LEVEL5.md)
* [Level 6](LEVEL6.md)
* [Level 7](LEVEL7.md)

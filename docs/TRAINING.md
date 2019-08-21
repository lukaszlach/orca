# Orca - Training

<details><summary>Enter Linux virtual machine</summary>
<p>

```bash
# Windows and Mac
docker run -it --rm --privileged --pid=host justincormack/nsenter1

# Mac
screen ~/Library/Containers/com.docker.docker/Data/vms/0/tty
```

</p>
</details>

<details><summary>Run official Docker documentation locally</summary>
<p>

```bash
git clone --recursive \
    https://github.com/docker/docker.github.io.git
cd docker.github.io/
docker-compose up
```

</p>
</details>

<details><summary>Dump Docker Engine communication</summary>
<p>

```bash
socat -d -d -t100 \
   -lf /dev/stdout \
   -v UNIX-LISTEN:/var/run/docker.debug,mode=777,reuseaddr,fork \
      UNIX-CONNECT:/var/run/docker.sock
```

```bash
DOCKER_HOST=unix:///var/run/docker.debug docker ps
```

</p>
</details>

<details><summary>Send HTTP request to a Docker Engine</summary>
<p>

```bash
curl -sSf --unix-socket /var/run/docker.sock 0/containers/json
```

</p>
</details>
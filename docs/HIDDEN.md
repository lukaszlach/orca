# Orca - Hidden Levels

## Challenge: Go deep

<details><summary>Extract Docker image to a directory</summary>
<p>

Extract the image contents to the `/tmp/orca` directory.

```bash
mkdir /tmp/orca
docker save orca:latest | tar -C /tmp/orca/ -xv
```

```bash
ls -lach /tmp/orca
```

</p>
</details>

<details><summary>View the formatted manifest file</summary>
<p>

Display formatted JSON of the image manifest.

```bash
jq '.' < /tmp/orca/manifest.json
```

</p>
</details>

<details><summary>View the configuration file</summary>
<p>

Display the configuration file name.

```bash
jq -r '.[0].Config' < /tmp/orca/manifest.json
```

Display the formatted configuration file.

```bash
jq '.' < /tmp/orca/$(jq -r '.[0].Config' < /tmp/orca/manifest.json)
```

Display formatted JSON for the image history.

```bash
jq '.history' < /tmp/orca/$(jq -r '.[0].Config' < /tmp/orca/manifest.json)
```

</p>
</details>

<details><summary>Extract the image layer to a directory</summary>
<p>

Display the selected layer archive file.

```bash
jq -r '.[0].Layers[1]' < /tmp/orca/manifest.json
```

Extract the layer archive to the `/tmp/orca/layer` directory:

```bash
mkdir /tmp/orca/layer
tar -C /tmp/orca/layer -xvf /tmp/orca/$(jq -r '.[0].Layers[1]' < /tmp/orca/manifest.json)
```

</p>
</details>

<details><summary>Explore the image filesystem</summary>
<p>

Display all image layers in order.

```bash
jq -r '.[0].Layers' < /tmp/orca/manifest.json
```

Extract all the layers to the `/tmp/orca/filesystem` directory.

```bash
mkdir /tmp/orca/filesystem
jq -r '.[0].Layers | .[]' < /tmp/orca/manifest.json | xargs -n1 -I{} tar -C /tmp/orca/filesystem -xvf "/tmp/orca/{}"
```

</p>
</details>

<details><summary>Run the application on the host system</summary>
<p>

```bash
cd /tmp/orca/filesystem
./orca version
```

Show details about the application binary.

```bash
cd /tmp/orca/filesystem
file orca
ldd orca
```

Install required dependencies.

```bash
sudo apt-get install -y musl
```

</p>
</details>

## Challenge: Shell

<details><summary>Solution 1 - install it</summary>
<p>

```bash
docker exec -it orca sh
```

```bash
apk --no-cache add bash
bash
```

</p>
</details>

<details><summary>Solution 2 - `pid` and `net` container modes</summary>
<p>

```bash
docker run -it --net container:orca --pid container:orca debian:stretch bash
```

</p>
</details>

<details><summary>Solution 3 - `pid` and `net` container modes with `cmd.cat` registry</summary>
<p>

```bash
docker run -it --net container:orca --pid container:orca cmd.cat/bash/ngrep/htop bash
```

</p>
</details>

<details><summary>Access container filesystem</summary>
<p>

```bash
docker run -it --pid container:orca --cap-add SYS_PTRACE debian:stretch bash
```

```bash
ls /proc/1/root/
```

</p>
</details>


<details><summary>Solution 4 - use `cntr`</summary>
<p>

```bash
sudo cntr attach orca
```

</p>
</details>

<details><summary>Run host tools on a container</summary>
<p>

```bash
export ORCA_PID=$(docker inspect -f '{{.State.Pid}}' orca)
```

```bash
# Network
$ sudo nsenter -t $ORCA_PID -n ngrep -d eth0
```

```bash
# Process
$ sudo nsenter -t $ORCA_PID -m ps aux
```

```bash
# Filesystem (only container)
$ sudo nsenter -t $ORCA_PID -m ls /
# Filesystem (both container and host)
$ sudo ls -la /proc/${ORCA_PID}/root/
```

</p>
</details>

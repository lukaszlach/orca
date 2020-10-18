# Orca - Level 2

## Challenge: Networking

<details><summary>Dockerfile</summary>
<p>

```Dockerfile
FROM golang:1.12-alpine AS build
WORKDIR /orca
ENV GOPATH=/orca
COPY . .
RUN go build .

FROM alpine:3.9
COPY --from=build /orca/orca /orca/bin/start.sh /
CMD ["sh", "/start.sh"]
EXPOSE 8080/tcp
```

</p>
</details>

<details><summary>docker-compose.yml</summary>
<p>

```yaml
version: '3.7'

services:
  orca:
    image: orca
    build: .
    container_name: orca
    ports: ["8080:8080"]
```

</p>
</details>

## Challenge: Misbehaving container

<details><summary>bin/start.sh</summary>
<p>

```bash
#!/usr/bin/env sh
set -e
chmod +x ./orca
set -x
exec ./orca --no-daemon
```

</p>
</details>

## Challenge: Root

<details><summary>Dockerfile</summary>
<p>

```Dockerfile
FROM golang:1.12-alpine AS build
WORKDIR /orca
ENV GOPATH=/orca
COPY . .
RUN go build .

FROM alpine:3.9
RUN addgroup -g 10000 -S orca && \
    adduser  -u 10000 -S orca -G orca -H -s /bin/false && \
    apk --no-cache add su-exec
COPY --from=build --chown=orca:orca \
        /orca/orca /orca/bin/start.sh /
CMD ["su-exec", "orca", "sh", "/start.sh"]
EXPOSE 8080/tcp
```

</p>
</details>

## Challenge: Logs

<details><summary>Dockerfile</summary>
<p>

```Dockerfile
FROM golang:1.12-alpine AS build
WORKDIR /orca
ENV GOPATH=/orca
COPY . .
RUN go build .

FROM alpine:3.9
RUN addgroup -g 10000 -S orca && \
    adduser  -u 10000 -S orca -G orca -H -s /bin/false && \
    apk --no-cache add su-exec
COPY --from=build --chown=orca:orca \
        /orca/orca /orca/bin/start.sh /
CMD ["su-exec", "orca", "sh", "/start.sh"]
EXPOSE 8080/tcp
RUN ln -sf /dev/stdout /tmp/orca.log && \
    ln -sf /dev/stderr /tmp/orca-error.log
```

</p>
</details>

<details><summary>Inspect logging details</summary>
<p>

```bash
docker inspect --format '{{.HostConfig.LogConfig.Type}}' orca
```

```bash
docker inspect --format='{{.LogPath}}' orca
```

</p>
</details>

## Challenge: Configuration

<details><summary>docker-compose.yml</summary>
<p>

```yaml
version: '3.7'

services:
  orca:
    image: orca
    build: .
    container_name: orca
    ports: ["8080:8080"]
    depends_on: ["mysql"]
    environment: ["ORCA_MYSQL"]
  mysql:
    image: mysql:5.7
    environment: ["MYSQL_ALLOW_EMPTY_PASSWORD=true"]
```

</p>
</details>

<details><summary>.env</summary>
<p>

```bash
ORCA_MYSQL=mysql:3306
```

</p>
</details>

## Challenge: State

<details><summary>Dockerfile</summary>
<p>

```Dockerfile
FROM golang:1.12-alpine AS build
WORKDIR /orca
ENV GOPATH=/orca
COPY . .
RUN go build .

FROM alpine:3.9
RUN addgroup -g 10000 -S orca && \
    adduser  -u 10000 -S orca -G orca -H -s /bin/false && \
    apk --no-cache add su-exec
COPY --from=build --chown=orca:orca \
        /orca/orca /orca/bin/start.sh /
CMD ["su-exec", "orca", "sh", "/start.sh"]
EXPOSE 8080/tcp
RUN ln -sf /dev/stdout /tmp/orca.log && \
    ln -sf /dev/stderr /tmp/orca-error.log && \
    mkdir -p /tmp/orca && \
    chown orca:orca /tmp/orca
VOLUME /tmp/orca
```

</p>
</details>

<details><summary>List container mounts</summary>
<p>

```bash
docker inspect \
    --format '{{json .Mounts}}' \
    orca
```

</p>
</details>

## Challenge: Optimize

<details><summary>.dockerignore</summary>
<p>

```
.git
Dockerfile
Makefile
docker-compose.yml
.env
*.md
docs
.workshop
```

</p>
</details>

## Challenge: Persist

<details><summary>Run local image registry</summary>
<p>

```bash
docker volume create registry_data
docker run -d \
   -v registry_data:/var/lib/registry \
   -p 5000:5000 \
   registry:2
```

</p>
</details>


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
jq -r '.[0].Layers
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
cd /tmp/orca-filesystem
./orca version
```

Show details about the application binary.

```bash
cd /tmp/orca-filesystem
file orca
ldd orca
```

Install required dependencies.

```bash
sudo apt-get install -y musl
```

</p>
</details>

# Orca

> The killer whale or orca is a toothed whale belonging to the oceanic dolphin family, of which it is the largest member.
> -- Wikipedia

```bash
git clone https://github.com/lukaszlach/orca
cd orca
bash workshop-prepare.sh
```

## Objective: Containerize

<details><summary>Dockerfile</summary>
<p>

```Dockerfile
FROM golang:1.12-alpine
WORKDIR /orca
ENV GOPATH=/orca
COPY . .
RUN go build .
CMD ["sh", "/orca/bin/start.sh"]
```

</p>
</details>

## Challenge: Optimize

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
```

</p>
</details>

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
    mkdir -p /var/lib/orca && \
    chown orca:orca /var/lib/orca
VOLUME /var/lib/orca
```

</p>
</details>

<details><summary>List the container mounts</summary>
<p>

```bash
docker inspect \
    --format '{{ json .Mounts }}' \
    orca
```

</p>
</details>

## Challenge: Crash

<details><summary>Netshoot</summary>
<p>

https://hub.docker.com/r/bretfisher/netshoot/

```bash
docker run -it --net container:orca bretfisher/netshoot \
    ngrep -d eth0 -x -q
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
    depends_on: ["mysql"]
    environment: ["ORCA_MYSQL"]
  mysql:
    image: mysql:5.7
    environment: ["MYSQL_ROOT_PASSWORD=orc4"]
```

</p>
</details>

<details><summary>Kali Linux</summary>
<p>

https://github.com/lukaszlach/kali-desktop

```bash
docker run -d \
    --cap-add NET_ADMIN \
    --net container:orca_mysql_1 \
    lukaszlach/kali-desktop:xfce-top10
docker run -d \
    -p 6080:6080 \
    --net orca_default \
    -e LISTEN=:6080 -e TALK=mysql:6080 \
    tecnativa/tcp-proxy
```

</p>
</details>

## Objective: Orchestrate

<details><summary>Initialize a one-node Swarm</summary>
<p>

```bash
docker swarm init
```

in case you are asked to pick a specific network interface:

```bash
ifconfig

# for example if eth1 was picked
docker swarm init --advertise-addr eth1
```

</p>
</details>

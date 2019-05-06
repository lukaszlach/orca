# Orca - Level 3

## Challenge: Crash

<details><summary>Run ngrep in container network mode</summary>
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

## Challenge: Configuration

<details><summary>entrypoint.sh</summary>
<p>

```bash
envsubst < orca.conf.tpl > /etc/orca.conf
exec "$@"
```

</p>
</details>

<details><summary>orca.conf.tpl</summary>
<p>

```
orca_cache=$ORCA_CACHE
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
    environment: ["ORCA_MYSQL", "ORCA_CACHE"]
  mysql:
    image: mysql:5.7
    environment: ["MYSQL_ROOT_PASSWORD=orc4"]
```

</p>
</details>

<details><summary>.env</summary>
<p>

```
ORCA_MYSQL=mysql:3306
ORCA_CACHE=1
```

</p>
</details>

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
RUN apk --no-cache add gettext
COPY entrypoint.sh orca.conf.tpl /
ENTRYPOINT ["sh", "/entrypoint.sh"]
```

</p>
</details>

<details><summary>Alternatives examples</summary>
<p>

https://hub.docker.com/r/lukaszlach/confsubst

```bash
echo '${GREETING:-Hello} ${NAME:-World}' | \
    docker run -i -e NAME=Docker lukaszlach/confsubst \
    envsubst
```

https://github.com/subfuzion/envtpl

```bash
echo 'Hello {{ .NAME | title }}' | \
    docker run -i -e NAME=world subfuzion/envtpl
```

</p>
</details>

## Challenge: Inspect

<details><summary>Inspect a single container</summary>
<p>

```bash
docker inspect \
    --format '{{ json .State.Status }}' orca
```

```bash
docker inspect \
    --format '{{ print .Path }} {{ join .Args " " }}' orca
```

```bash
docker inspect \
    --format '{{range .Mounts}}{{ .Source }}{{end}}' orca
```

</p>
</details>

<details><summary>Inspect all containers</summary>
<p>

```bash
docker inspect -f \
    '{{if ne 0 .State.ExitCode}}{{.Name}} {{.State.ExitCode}}{{end}}' \
    $(docker ps -aq) \
    | grep .
```

</p>
</details>

<details><summary>dry</summary>
<p>

https://github.com/moncho/dry

```bash
docker run -it \
    -v /var/run/docker.sock:/var/run/docker.sock \
    moncho/dry
```

</p>
</details>

<details><summary>Portainer</summary>
<p>

https://www.portainer.io

```bash
docker volume create portainer_data
docker run -d \
    -p 9000:9000 \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v portainer_data:/data \
    portainer/portainer
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
ENTRYPOINT ["sh", "/entrypoint.sh"]
CMD ["su-exec", "orca", "sh", "/start.sh"]
EXPOSE 8080/tcp
VOLUME /tmp/orca
RUN addgroup -g 10000 -S orca && \
    adduser  -u 10000 -S orca -G orca -H -s /bin/false && \
    apk --no-cache add su-exec gettext && \
    ln -sf /dev/stdout /tmp/orca.log && \
    ln -sf /dev/stderr /tmp/orca-error.log && \
    mkdir -p /tmp/orca && \
    chown orca:orca /tmp/orca
COPY --from=build --chown=orca:orca \
     /orca/orca /orca/bin/start.sh /orca/orca.conf.tpl /orca/entrypoint.sh /
```

</p>
</details>

<details><summary>hadolint</summary>
<p>

https://github.com/hadolint/hadolint

```bash
docker run -i hadolint/hadolint < Dockerfile
```

</p>
</details>
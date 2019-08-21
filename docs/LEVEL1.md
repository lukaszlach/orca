# Orca - Level 1

## Challenge: Containerize

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

<details><summary>Build the image with Buildkit</summary>
<p>

```bash
DOCKER_BUILDKIT=1 docker build -t orca .
```

</p>
</details>

<details><summary>Explore the image layers</summary>

https://github.com/wagoodman/dive

<p>

```Dockerfile
docker run --rm -it \
    -v /var/run/docker.sock:/var/run/docker.sock \
    wagoodman/dive orca
```

</p>
</details>

## Challenge: Compose

<details><summary>Composerize</summary>
<p>

https://github.com/magicmark/composerize

```Dockerfile
docker run lukaszlach/composerize \
    docker run --name orca orca
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

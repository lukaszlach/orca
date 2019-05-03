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
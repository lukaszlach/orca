# Orca - Level 5

## Challenge: Development version

<details><summary>Dockerfile.dev</summary>
<p>

```Dockerfile
FROM orca AS orca-deps
RUN apk -U add curl bash && \
    curl -sSfL https://i.jpillora.com/webproc | bash

FROM orca AS orca-dev
CMD ["/webproc", "--port", "8081", "--config", "/etc/orca.conf", "--", "su-exec", "orca", "sh", "/start.sh"]
EXPOSE 8081/tcp
COPY --from=orca-deps /webproc /webproc
```

</p>
</details>

## Challenge: Unit test

<details><summary>goss.yaml</summary>
<p>

```yaml
group:
  orca:
    exists: true
    gid: 10000

user:
  orca:
    exists: true
    uid: 10000
    gid: 10000

file:
  /orca:
    exists: true
    filetype: file
    mode: "0755"

command:
  "/orca version":
    exit-status: 0
    timeout: 1000
```

</p>
</details>

<details><summary>Dockerfile.ci</summary>
<p>

```Dockerfile
FROM orca AS structure-test
COPY goss.yaml goss.yaml
RUN apk --no-cache add curl && \
    curl -fsSL https://goss.rocks/install | sh && \
    goss validate && \
    echo "Structure test successful"
```

</p>
</details>

## Challenge: Security scan

<details><summary>Get the access token</summary>
<p>

```bash
docker run --rm -it aquasec/microscanner \
    --register your@email.com
```

</p>
</details>

<details><summary>Dockerfile.ci</summary>
<p>

```Dockerfile
FROM orca AS structure-test
COPY goss.yaml goss.yaml
RUN apk --no-cache add curl && \
    curl -fsSL https://goss.rocks/install | sh && \
    goss validate && \
    echo "Structure test successful"

FROM orca AS security-test
ADD https://get.aquasec.com/microscanner .
RUN apk --no-cache add ca-certificates && \
    chmod +x ./microscanner && \
    ./microscanner YourAccessToken && \
    echo "No vulnerabilities found"
```

</p>
</details>

## Challenge: Respawn

<details><summary>.gitlab-ci.yml</summary>
<p>

```yaml
before_script:
  - docker login registry.local.cmd.cat:8000 -u root -p passw0rd

stages:
  - build

build:
  stage: build
  artifacts:
    untracked: true
  script:
    - docker build --no-cache -t orca .
    - docker build --no-cache -t orca-ci -f Dockerfile.ci .
    - docker cp $(docker create orca):/orca . && docker rm -f $(docker ps -lq)
    - docker tag orca registry.local.cmd.cat:8000/root/orca:$CI_JOB_ID
    - docker push registry.local.cmd.cat:8000/root/orca:$CI_JOB_ID
```

</p>
</details>

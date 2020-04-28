# Orca - Level 4

## Challenge: Automate

<details><summary>Run GitLab</summary>
<p>

Run on local computer.

```bash
docker network create orca-gitlab-network
docker run -d --name gitlab \
    --net orca-gitlab-network -p 8000:8000 \
    --network-alias gitlab.local.cmd.cat \
    --network-alias registry.local.cmd.cat \
    -e "GITLAB_DOMAIN=local.cmd.cat" \
    lukaszlach/orca-gitlab
```

Run on a workshop VPS server (replace `XX` with your server number).

**Notice**: Change `local` to `vpsXX` in all further code snippets if needed.

```bash
docker network create orca-gitlab-network
docker run -d --name gitlab \
    --net orca-gitlab-network -p 8000:8000 \
    --network-alias gitlab.vpsXX.cmd.cat \
    --network-alias registry.vpsXX.cmd.cat \
    -e "GITLAB_DOMAIN=vpsXX.cmd.cat" \
    lukaszlach/orca-gitlab
```


</p>
</details>

<details><summary>Run GitLab Runner</summary>
<p>

```bash
docker run -d --name gitlab-runner \
    --net orca-gitlab-network \
    -v /var/run/docker.sock:/var/run/docker.sock \
    lukaszlach/orca-gitlab-runner
```

</p>
</details>


<details><summary>Add git remote pointing local GitLab</summary>
<p>

```bash
git remote add local http://gitlab.local.cmd.cat:8000/root/orca.git
```

```bash
git config --global user.name "Docker Workshop"
git config --global user.email workshop@docker.com
```

</p>
</details>

<details><summary>.gitlab-ci.yml</summary>
<p>

```yaml
before_script:
  - docker login registry.local.cmd.cat:8000 -u root -p passw0rd

stages:
  - build

build:
  stage: build
  script:
    - docker build --no-cache -t orca .
```

</p>
</details>

<details><summary>Add an insecure registry</summary>
<p>

```bash
sudo echo '{"insecure-registries":["registry.local.cmd.cat:8000"]}' > /etc/docker/daemon.json
sudo kill -HUP $(pidof dockerd)
```

</p>
</details>

## Challenge: Release

<details><summary>.gitlab-ci.yml - Binary</summary>
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
    - docker cp $(docker create orca):/orca . && docker rm -f $(docker ps -lq)
```

</p>
</details>

<details><summary>.gitlab-ci.yml - Docker image</summary>
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
    - docker cp $(docker create orca):/orca . && docker rm -f $(docker ps -lq)
    - docker tag orca registry.local.cmd.cat:8000/root/orca:$CI_JOB_ID
    - docker push registry.local.cmd.cat:8000/root/orca:$CI_JOB_ID
```

</p>
</details>

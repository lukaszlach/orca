# Orca - Level 6

## Challenge: Orchestrate

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

<details><summary>Deploy a Docker Swarm service</summary>
<p>

```bash
docker-compose stop
docker stack deploy -c docker-compose.yml orca
```

```bash
docker service ls
docker service ps orca_orca
```

```bash
docker service scale orca_orca=3
```

```bash
docker stack rm orca
```

</p>
</details>

## Challenge: Cuddle

<details><summary>Run Kubernetes in Docker</summary>
<p>

https://github.com/bsycorp/kind

```bash
docker run --rm --name kind -it \
    --privileged \
    -p 8443:8443 -p 10080:10080 \
    -p 8080:30080 \
    bsycorp/kind:latest-1.23
```

</p>
</details>

<details><summary>Set up kubectl alias</summary>
<p>

```bash
alias kubectl='docker exec -it kind kubectl'
```

</p>
</details>

<details><summary>Transfer the Docker image</summary>
<p>

```bash
docker save orca | docker exec -i kind docker load
```

```bash
docker exec kind docker images orca
```

</p>
</details>

<details><summary>kompose</summary>
<p>

https://github.com/kubernetes/kompose

```bash
cat docker-compose.yml | \
    docker run --rm -i lukaszlach/kompose -f - -o - convert
```

</p>
</details>

<details><summary>orca-k8s.yml</summary>
<p>

```yaml
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: orca
spec:
  selector:
    matchLabels:
      app: orca
  replicas: 3
  template:
    metadata:
      labels:
        app: orca
    spec:
      containers:
      - name: orca
        image: orca:latest
        imagePullPolicy: Never
        ports:
        - containerPort: 8080

---
apiVersion: v1
kind: Service
metadata:
  name: orca
spec:
  ports:
  - name: http
    protocol: TCP
    port: 8080
    targetPort: 8080
    nodePort: 30080
  selector:
    app: orca
  type: LoadBalancer
```

</p>
</details>

<details><summary>Deploy</summary>
<p>

```bash
docker cp orca-k8s.yml kind:/
```

```bash
docker exec kind kubectl apply -f /orca-k8s.yml
```

```bash
docker exec kind kubectl get all
```

</p>
</details>

## Challenge: Prepare for chaos

<details><summary>Run Docker Traffic Control daemon</summary>
<p>

https://github.com/lukaszlach/docker-tc

```bash
docker run -d \
    --name docker-tc \
    --network host \
    --cap-add NET_ADMIN \
    --restart always \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /var/docker-tc:/var/docker-tc \
    lukaszlach/docker-tc
```

</p>
</details>

<details><summary>Run ping command</summary>
<p>

```bash
docker network create test
docker run -it --name ping \
    --net test \
    --label "com.docker-tc.enabled=1" \
    --label "com.docker-tc.delay=100ms" \
    --label "com.docker-tc.loss=50%" \
    --label "com.docker-tc.duplicate=50%" \
    busybox \
    ping google.com
```

</p>
</details>

<details><summary>Alter traffic control rules</summary>
<p>

```bash
curl -d'delay=300ms' localhost:4080/ping
```

</p>
</details>

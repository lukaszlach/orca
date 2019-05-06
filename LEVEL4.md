# Orca - Level 4

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
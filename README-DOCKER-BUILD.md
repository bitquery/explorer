# Build

```
docker build \
   -t nexus.bitq.dev/repository/bitquery/explorer:`git rev-parse --short HEAD` .
```

# Make an alias latest
```
docker image tag \
   nexus.bitq.dev/repository/bitquery/explorer:`git rev-parse --short HEAD` \
   nexus.bitq.dev/repository/bitquery/explorer:latest
```

# Login to registry

```
apt install gnupg2 pass
docker login -u <login> https://nexus.bitq.dev
```

# Push image tags

```
docker image push nexus.bitq.dev/repository/bitquery/explorer:`git rev-parse --short HEAD`
docker image push nexus.bitq.dev/repository/bitquery/explorer:latest
```

# Run container

```
export IMAGE_TAG="latest"

docker run -d \
   --name staging-explorer \
   --restart unless-stopped \
   --dns 10.0.0.254 \
   --dns-search api-cluster.local \
   --dns-opt ndots:2 \
   -p 127.0.0.1:3000:3000 \
   -e SECRET_KEY_BASE="" \
   -e EXPLORER_API_KEY="" \
   nexus.bitq.dev/repository/bitquery/explorer:${IMAGE_TAG}
```

# README

## New Docker Registry

Create a new Docker Registry using docker.

```bash
$./new-docker-registry.sh
```

Edit your local hostname config /etc/hosts

```bash
127.0.0.1 registry.local
```

## Test the registry

```bash
docker pull containous/whoami
docker tag  containous/whoami registry.local:5000/containous/whoami:latest
docker push registry.local:5000/containous/whoami:latest
```

## New K3S Cluster

Create new K3S cluster using the docker registry created previously.

Edit `new-local-cluster.sh` and set the value for

* CLUSTER_NAME
* K3S_HOME

```bash
$./new-local-cluster.sh
```

## Test k3s configuration

Apply the following configuration

```bash
kubectl apply -f k3s/test-k3s-traefik-contif.yaml
```

and check with your browser you can connect to `https://localhost:80/whoami/` or running

```bash
curl -k https://localhost:80/whoami/
```


## Build the application

```bash
mvn package -B -Dcontainer.image.name="bmoussaud/bookstore-advanced" -Dcontainer.image.registry="registry.local:5000" -Dsha1="-0.0.1"
```

this command will

* build the war artifact,
* put it into a Docker container `docker build`,
* tag the images `docker tag bmoussaud/bookstore-advanced registry.local:5000/bmoussaud/bookstore-advanced`
* push it into the docker registry `docker push registry.local:5000/bmoussaud/bookstore-advanced`

## Build the database

```bash
cd database
export SHA1="0.0.1"
export DB_VERSION="1.0.0-$SHA1"
docker build . --tag bmoussaud/bookstore-advanced-database:$DB_VERSION --build-arg version=$DB_VERSION
docker tag bmoussaud/bookstore-advanced-database:$DB_VERSION registry.local:5000/bmoussaud/bookstore-advanced-database:$DB_VERSION
docker push registry.local:5000/bmoussaud/bookstore-advanced-database:$DB_VERSION
```

## Digital.ai Deploy

Install a brand new Deploy Server if you don't have one



## References:

* https://codeburst.io/creating-a-local-development-kubernetes-cluster-with-k3s-and-traefik-proxy-7a5033cb1c2d
* https://k33g.gitlab.io/articles/2020-02-27-K3S-05-REGISTRY.html
* https://k3d.io/usage/guides/registries
* https://blog.ruanbekker.com/blog/2020/02/21/persistent-volumes-with-k3d-kubernetes/




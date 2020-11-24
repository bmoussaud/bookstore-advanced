# README

## New Docker Registry

Create a new Docker Registry using docker.

```
$./new-docker-registry.sh
```

## Test the registry

````
docker pull containous/whoami
docker tag  containous/whoami registry.local:5000/whoami:latest
docker push registry.local:5000/whoami:latest
````

## New K3S Cluster

Create new K3S cluster using the docker registry created previously.

Edit `new-local-cluster.sh` and set the value for

* CLUSTER_NAME
* K3S_HOME

```
$./new-local-cluster.sh
```

## Test k3s configuration

Apply the following configuration
```
kubectl apply -f k3s/test-k3s-traefik-contif.yaml
```

and check with your browser you can connect to `https://localhost:80/whoami/`


# Reference:

* https://codeburst.io/creating-a-local-development-kubernetes-cluster-with-k3s-and-traefik-proxy-7a5033cb1c2d
*  https://k33g.gitlab.io/articles/2020-02-27-K3S-05-REGISTRY.html
* https://k3d.io/usage/guides/registries




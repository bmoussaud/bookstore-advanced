#Based on https://codeburst.io/creating-a-local-development-kubernetes-cluster-with-k3s-and-traefik-proxy-7a5033cb1c2d


CLUSTER_NAME="book-cluster"
K3S_HOME="/Users/bmoussaud/Workspace/bmoussaud/bookstore-advanced/k3s"

k3d cluster create $CLUSTER_NAME --api-port 127.0.0.1:6443 -p 80:80@loadbalancer -p 443:443@loadbalancer --k3s-server-arg "--no-deploy=traefik" --volume "$K3S_HOME/k3d-registries.yaml:/etc/rancher/k3s/registries.yaml"
k3d kubeconfig get $CLUSTER_NAME
# https://k3d.io/usage/guides/registries/#using-a-local-registry
docker network connect k3d-$CLUSTER_NAME registry.local

kubectl cluster-info
helm repo add traefik https://containous.github.io/traefik-helm-chart
helm install traefik traefik/traefik

# access to the traefix dashboard
#kubectl port-forward $(kubectl get pods --selector "app.kubernetes.io/name=traefik" --output=name) 9000:9000
#open http://localhost:9000/dashboard/#/
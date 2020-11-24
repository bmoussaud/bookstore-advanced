docker volume create local_registry
docker container run -d --name registry.local -v local_registry:/var/lib/registry --restart always -p 5000:5000 registry:2

#curl http://registry.local:5000/v2/nginx/tags/list



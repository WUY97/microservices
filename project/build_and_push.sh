#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <version>"
    exit 1
fi

version=$1

services=("logger-service" "broker-service" "listener-service" "mail-service" "authentication-service")

for service in "${services[@]}"; do
    cd ..
    cd "./$service" || exit

    docker build -f "${service}.dockerfile" -t "yitong6577/${service}:${version}" .
    docker push "yitong6577/${service}:${version}"
done

cd ..
cd ./project || exit
docker buildx build -f caddy.production.dockerfile -t "yitong6577/micro-caddy-server:${version}" .
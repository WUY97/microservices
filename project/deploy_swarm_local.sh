#!/bin/bash

# deploy
# docker stack deploy -c swarm.yml myapp

# This help solve mailhog issue
docker stack deploy -c swarm.yml --resolve-image never myapp

# docker service ls

# docker service ps myapp_mailhog

# docker service logs myapp_mailhog

# docker service update --force myapp_mailhog

# scale service
docker service scale myapp_listener-service=3

# update service
# cd ..
# cd logger-service || exit
# docker build -f logger-service.dockerfile -t yitong6577/logger-service:1.0.1 .
# docker push yitong6577/logger-service:1.0.1
# cd ..
# cd project || exit
# docker service ls
# docker service scale myapp_logger-service=2
# docker service ls
# docker service update --image yitong6577/logger-service:1.0.1 myapp_logger-service
# docker service update --image yitong6577/logger-service:1.0.0 myapp_logger-service

# stop docker swarm
# docker service ls
# docker service scale myapp_broker-service=0
# docker stack rm myapp
# docker service ls

# build frontend
docker build -f front-end.dockerfile -t yitong6577/front-end:1.0.0 .
docker push yitong6577/front-end:1.0.0

# build caddy
docker build -f caddy.dockerfile -t yitong6577/micro-caddy:1.0.0 .
docker push yitong6577/micro-caddy:1.0.0

sudo vi /etc/hosts
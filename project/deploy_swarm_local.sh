#!/bin/bash

# docker stack deploy -c swarm.yml myapp

# This help solve mailhog issue
docker stack deploy -c swarm.yml --resolve-image never myapp

# docker stack rm myapp

# docker service ls

# docker service ps myapp_mailhog

# docker service logs myapp_mailhog

# docker service update --force myapp_mailhog
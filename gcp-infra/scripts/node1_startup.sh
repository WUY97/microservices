#!/bin/bash

sudo apt-get update
sudo apt-get upgrade -y
sudo apt install docker.io docker-compose -y
sudo docker swarm init --advertise-addr "$(hostname -i)"

WORKER_JOIN_TOKEN=$(sudo docker swarm join-token worker -q)
echo "Storing the Docker Swarm join token in Secret Manager..."
echo -n "$WORKER_JOIN_TOKEN" > /tmp/worker_join_token.txt
gcloud secrets create swarm-worker-join-token --replication-policy="automatic" --data-file=/tmp/worker_join_token.txt
rm /tmp/worker_join_token.txt

MANAGER_IP=$(curl -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip)
echo "Storing the manager IP in Secret Manager..."
echo -n "$MANAGER_IP" > /tmp/manager_ip.txt
gcloud secrets create swarm-manager-ip --replication-policy="automatic" --data-file=/tmp/manager_ip.txt
rm /tmp/manager_ip.txt

echo "Creating Caddy folers..."
sudo mkdir -p /swarm/caddy_data
sudo mkdir -p /swarm/caddy_config
sudo mkdir -p /swarm/db-data/mongo
sudo mkdir -p /swarm/db-data/postgres
cat <<EOF > /swarm/swarm.yml
${swarm_yml}
EOF

echo "Deploying the application stack..."
sudo docker stack deploy -c /swarm/swarm.yml myapp

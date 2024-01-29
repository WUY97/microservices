#!/bin/bash

sudo apt-get update
sudo apt-get upgrade -y
sudo apt install docker.io docker-compose -y

# Loop to retry fetching the worker join token
for i in {1..10}; do
    echo "Trying to retrieve the Docker Swarm join token from Secret Manager (Attempt $i)..."
    WORKER_JOIN_TOKEN=$(gcloud secrets versions access latest --secret="swarm-worker-join-token")
    
    if [ -n "$WORKER_JOIN_TOKEN" ]; then
        echo "Join token retrieved successfully."
        break
    fi
    echo "Waiting before retry..."
    sleep 10
done

if [ -z "$WORKER_JOIN_TOKEN" ]; then
    echo "Failed to retrieve the join token after multiple attempts."
    exit 1
fi

# Delete the worker join token secret after use
echo "Deleting worker join token from Secret Manager..."
gcloud secrets delete swarm-worker-join-token --quiet

# Loop to retry fetching the manager IP
for i in {1..10}; do
    echo "Trying to retrieve the manager IP from Secret Manager (Attempt $i)..."
    MANAGER_IP=$(gcloud secrets versions access latest --secret="swarm-manager-ip")
    
    if [ -n "$MANAGER_IP" ]; then
        echo "Manager IP retrieved successfully."
        break
    fi
    echo "Waiting before retry..."
    sleep 10
done

if [ -z "$MANAGER_IP" ]; then
    echo "Failed to retrieve the manager IP after multiple attempts."
    exit 1
fi

# Delete the manager IP secret after use
echo "Deleting manager IP from Secret Manager..."
gcloud secrets delete swarm-manager-ip --quiet

echo "Joining the Docker Swarm as a worker..."
sudo docker swarm join --token "$WORKER_JOIN_TOKEN" "$MANAGER_IP":2377
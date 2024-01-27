resource "google_compute_instance" "node-1" {
  name         = "node-1"
  machine_type = "e2-small"
  zone         = "us-west1-b"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }

  service_account {
    email = "sa-gomicro-tf-mac@t-pulsar-412422.iam.gserviceaccount.com"
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  metadata_startup_script = <<-EOH
    #!/bin/bash
    sudo apt-get update
    sudo apt-get upgrade -y
    sudo apt install docker.io docker-compose -y
    sudo docker swarm init --advertise-addr $(hostname -i)

    WORKER_JOIN_TOKEN=$(sudo docker swarm join-token worker -q)
    echo "Storing the Docker Swarm join token in Secret Manager..."
    echo -n $WORKER_JOIN_TOKEN > /tmp/worker_join_token.txt
    gcloud secrets create swarm-worker-join-token --replication-policy="automatic" --data-file=/tmp/worker_join_token.txt
    rm /tmp/worker_join_token.txt

    MANAGER_IP=$(curl -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip)
    echo "Storing the manager IP in Secret Manager..."
    echo -n $MANAGER_IP > /tmp/manager_ip.txt
    gcloud secrets create swarm-manager-ip --replication-policy="automatic" --data-file=/tmp/manager_ip.txt
    rm /tmp/manager_ip.txt
  EOH

  tags = ["docker-vm-v4", "docker-vm-v6"]
}

resource "google_compute_instance" "node-2" {
  name         = "node-2"
  machine_type = "e2-small"
  zone         = "us-west1-b"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }

  service_account {
    email = "sa-gomicro-tf-mac@t-pulsar-412422.iam.gserviceaccount.com"
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  metadata_startup_script = <<-EOH
    #!/bin/bash
    sudo apt-get update
    sudo apt-get upgrade -y
    sudo apt install docker.io docker-compose -y

    # Loop to retry fetching the worker join token
    for i in {1..10}; do
      echo "Trying to retrieve the Docker Swarm join token from Secret Manager (Attempt $i)..."
      WORKER_JOIN_TOKEN=$(gcloud secrets versions access latest --secret="swarm-worker-join-token")
      
      if [ ! -z "$WORKER_JOIN_TOKEN" ]; then
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
      
      if [ ! -z "$MANAGER_IP" ]; then
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
    sudo docker swarm join --token $WORKER_JOIN_TOKEN $MANAGER_IP:2377
  EOH

  tags = ["docker-vm-v4", "docker-vm-v6"]
}

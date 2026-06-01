# Configuration Guide: Deploying and Initializing Apache AGE with Docker

## Objective
This guide provides a step-by-step procedure to deploy a PostgreSQL database equipped with the **Apache AGE** graph extension using Docker Compose, initialize the environment, and manage the infrastructure using fundamental Docker commands.

---

## 1. Prerequisites and Environment Setup

### Starting Docker Desktop
* Open the **Docker Desktop** application on your workstation and wait for the initialization phase to complete.
* Ensure that the indicator in the bottom-left corner of the interface displays **"Engine running"** before proceeding.

---

## 2. Project Setup and Deployment

### Repository Structure
To use this guide, your local repository or directory should contain the following files:
* `docker-compose.yml` (Defines the PostgreSQL container with Apache AGE)
* `init.sql` (Automates the initial graph extension setup)

### Instantiating the Docker Infrastructure
Open a terminal in your project root directory and execute the following command to download the required images and start the environment in detached mode:

```bash
docker compose up -d
```

## 3. Database Connection and Apache AGE Initialization

### Accessing the PostgreSQL Container
Once the infrastructure is successfully running, connect to the interactive shell of the database management system using the following command:

```bash
docker exec -it apache_age_container psql -U postgres -d graph_db
```

### Loading the Graph Extension
As soon as the interactive database prompt (`graph_db=#`) appears, execute the following SQL statement block to explicitly load the Apache AGE extension and dynamically configure the required search path:

```SQL
LOAD 'age';
SET search_path = ag_catalog, "$user", public;
```

## 4. Cheat Sheet: Useful Docker Commands
Below is a summary of fundamental commands required to manage the lifecycle of your containers and persistent storage volumes:

| Docker Command | Description / Use Case |
| :--- | :--- |
| `docker compose down` | Stops and removes active containers and networks. |
| `docker compose down -v` | Same as above, but also deletes persistent storage volumes (Warning: data loss). |
| `docker stop <container_id>` | Pauses/stops a running container. |
| `docker start <container_id>` | Restarts a previously stopped container. |
| `docker rm <container_id>` | Permanently deletes a stopped container from the system. |
| `docker rmi <image_id>` | Purges a locally stored Docker image. |
| `docker volume ls` | Lists all detected virtual storage volumes. |
| `docker volume rm <volume_name>` | Deletes a specific unused storage volume. |
| `docker stats` | Displays a live stream of container resource consumption statistics (CPU, RAM, Network). |

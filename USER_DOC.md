# Inception - User & Administrator Documentation (`USER_DOC.md`)

Welcome to the **Inception** service stack user guide. This document explains how to operate, monitor, and manage the services provided by this infrastructure.

---

## 1. Services Provided by the Stack

The infrastructure runs three main containerized services:
1. **NGINX (Ters Proxy / Gateway)**: Secure entry point handling HTTPS requests on port 443 with TLS 1.2/1.3 encryption.
2. **WordPress (Web Application)**: Content Management System (CMS) running PHP-FPM 8.2.
3. **MariaDB (Database)**: Relational SQL database storing WordPress site data, pages, and users.

---

## 2. Starting and Stopping the Infrastructure

### Starting Services
To start all services:
```bash
make
# or
make up
```

### Stopping Services
To stop services without deleting persistent data:
```bash
make down
```

### Cleaning Services & Volumes
To stop and remove containers and volumes:
```bash
make clean
```

---

## 3. Accessing the Website and Administration Panel

### Domain Setup
Ensure your local system resolves `nakbas.42.fr` to `127.0.0.1`.
In `/etc/hosts`:
```text
127.0.0.1 nakbas.42.fr
```

### Main Website
Open your web browser and navigate to:
```text
https://nakbas.42.fr
```
*Note: Because self-signed certificates are used for local development, accept the security warning in your browser.*

### WordPress Administrator Dashboard
To log in as administrator:
```text
https://nakbas.42.fr/wp-admin
```

---

## 4. Locating and Managing Credentials

All credentials and sensitive secrets are managed locally via **Docker Secrets** in the `secrets/` directory:
- Database User Password: `secrets/db_password.txt`
- Database Root Password: `secrets/db_root_password.txt`
- WordPress Admin Password: `secrets/credentials.txt`

To change a password:
1. Edit the desired file in `secrets/`.
2. Re-deploy the stack:
   ```bash
   make re
   ```

---

## 5. Checking Service Health and Logs

### Check Container Status
Run the following command to see if containers are `Up`:
```bash
docker compose -f srcs/docker-compose.yml ps
```

### View Live Logs
To view realtime logs from all services:
```bash
docker compose -f srcs/docker-compose.yml logs -f
```

To view logs for a specific service:
```bash
docker compose -f srcs/docker-compose.yml logs -f nginx
docker compose -f srcs/docker-compose.yml logs -f wordpress
docker compose -f srcs/docker-compose.yml logs -f mariadb
```

# Inception - Developer Documentation (`DEV_DOC.md`)

This document provides technical instructions for developers extending, debugging, or rebuilding the **Inception** Docker stack.

---

## 1. Setting Up the Environment from Scratch

### Prerequisites
Ensure the target system (Debian 12 Bookworm recommended) has Docker and Docker Compose installed:
```bash
docker --version
docker compose version
```

### Initial Configuration Files & Secrets Setup
1. Clone the project repository.
2. Verify host domain routing in `/etc/hosts`:
   ```text
   127.0.0.1 nakbas.42.fr
   ```
3. Prepare secret files in `secrets/`:
   ```bash
   mkdir -p secrets
   echo "my_db_password" > secrets/db_password.txt
   echo "my_root_password" > secrets/db_root_password.txt
   echo "my_admin_password" > secrets/credentials.txt
   ```
4. Verify environment file `srcs/.env`:
   ```env
   DOMAIN_NAME=nakbas.42.fr
   MYSQL_DATABASE=wordpress_db
   MYSQL_USER=wp_user
   WP_TITLE=Inception 42 Nakbas
   WP_ADMIN_USER=nakbas_admin
   WP_ADMIN_EMAIL=nakbas@student.42.fr
   WP_USER=student
   WP_USER_EMAIL=student@student.42.fr
   ```

---

## 2. Building and Launching with Makefile & Docker Compose

### Build and Launch Stack
```bash
make
```
Under the hood, `make` executes:
- Creates `/home/nakbas/data/wordpress` and `/home/nakbas/data/mariadb` on the host.
- Runs `docker compose -f srcs/docker-compose.yml up -d --build`.

---

## 3. Developer Commands for Container & Volume Management

### Inspecting Running Containers
```bash
docker compose -f srcs/docker-compose.yml ps
```

### Executing Shell Inside Containers
- NGINX:
  ```bash
  docker exec -it nginx sh
  ```
- WordPress:
  ```bash
  docker exec -it wordpress bash
  ```
- MariaDB:
  ```bash
  docker exec -it mariadb bash
  ```

### Inspecting Networks and Volumes
- **Networks**:
  ```bash
  docker network ls
  docker network inspect inception_inception-network
  ```
- **Volumes**:
  ```bash
  docker volume ls
  docker volume inspect inception_wordpress-data
  docker volume inspect inception_mariadb-data
  ```

---

## 4. Data Storage and Persistence Mechanics

Per 42 Inception subject requirements, persistent data resides on the host machine in:
- **WordPress Web Files**: `/home/nakbas/data/wordpress` (Mounted to `/var/www/html` in containers).
- **MariaDB SQL Database**: `/home/nakbas/data/mariadb` (Mounted to `/var/lib/mysql` in container).

Docker Volume definitions in `srcs/docker-compose.yml` bind host paths dynamically using the `local` driver:
```yaml
volumes:
  wordpress-data:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: /home/nakbas/data/wordpress
  mariadb-data:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: /home/nakbas/data/mariadb
```
This ensures that restarting or removing containers (`docker compose down`) does **not** erase your WordPress site or database tables.

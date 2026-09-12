*This project has been created as part of the 42 curriculum by nakbas.*

# Inception - Infrastructure with Docker

## Description
The **Inception** project at 42 School aims to broaden systemic knowledge by setting up a complete web hosting infrastructure using Docker and Docker Compose. Rather than relying on pre-packaged images, each service (NGINX, WordPress with PHP-FPM, and MariaDB) is built using custom `Dockerfile`s based on `debian:bookworm`.

The infrastructure enforces strict security guidelines:
- **NGINX** is the sole entry point, handling incoming requests exclusively over **HTTPS (Port 443)** using **TLSv1.2 or TLSv1.3**.
- **WordPress** and **MariaDB** run in separate containers, communicating via a private internal Docker bridge network.
- **Data Persistence** is managed using Docker volumes mapped to local host directories.
- **Sensitive Credentials** (database passwords, admin logins) are managed using **Docker Secrets** rather than hardcoding or plaintext environment variables.

---

## Instructions

### Prerequisites
- Operating System: Linux / Debian VM
- Tools: `docker`, `docker compose`, `make`, `sudo`

### Domain Name Setup
Map the domain name `nakbas.42.fr` to local loopback IP in `/etc/hosts`:
```bash
echo "127.0.0.1 nakbas.42.fr" | sudo tee -a /etc/hosts
```

### Running the Stack
To build and launch all services:
```bash
make
# or
make up
```

### Stopping the Stack
```bash
make down
```

### Cleaning Up
To remove containers, images, and volumes:
```bash
make clean    # Stops and removes containers and volume networks
make fclean   # Performs full prune and removes host data directories
```

---

## Project Description & Architectural Choices

### Overview & Service Architecture
1. **NGINX Container**: Serves as a Reverse Proxy listening on Port 443 with custom SSL/TLS certificates. It routes FastCGI PHP requests to the WordPress container on port 9000.
2. **WordPress + PHP-FPM Container**: Runs PHP-FPM and WP-CLI. Automatically downloads and initializes WordPress upon first start and connects to MariaDB.
3. **MariaDB Container**: Runs the MariaDB SQL database server. Listens on port 3306 internally and initializes the WordPress database and user accounts securely via Docker Secrets.

### Technical Comparisons

#### 1. Virtual Machines vs. Docker Containers
| Feature | Virtual Machines (VMs) | Docker Containers |
| :--- | :--- | :--- |
| **Architecture** | Emulates full hardware & guest OS via Hypervisor | Shares host OS kernel; isolates processes in user space |
| **Performance** | High overhead; slow boot times | Lightweight; near-native execution speed; sub-second startup |
| **Resource Usage**| Allocates fixed RAM & CPU per VM | Dynamically uses only required host resources |
| **Portability** | Heavy VM disk images (GBs) | Modular, small container images (MBs) defined by code |

#### 2. Secrets vs. Environment Variables
| Feature | Environment Variables (`.env`) | Docker Secrets |
| :--- | :--- | :--- |
| **Security** | Stored in plain text in memory or process tree | Encrypted in transit & at rest; mounted as in-memory files |
| **Visibility** | Visible via `docker inspect` or `env` commands | Restricted to `/run/secrets/<secret_name>` in container |
| **Risk** | High risk of accidental git commits | High security; decoupling credentials from application code |

#### 3. Docker Network vs. Host Network
| Feature | Docker Network (Bridge) | Host Network |
| :--- | :--- | :--- |
| **Isolation** | High isolation; containers communicate via private DNS | No isolation; container shares host IP stack directly |
| **Port Exposure**| Only explicitly published ports (e.g. 443) are visible | All open ports are directly bound on host interface |
| **Security** | Zero-trust inter-container isolation | Potential port conflict and vulnerability exposure |

#### 4. Docker Volumes vs. Bind Mounts
| Feature | Docker Named Volumes | Bind Mounts |
| :--- | :--- | :--- |
| **Management** | Managed entirely by Docker (`/var/lib/docker/volumes`) | Explicit host file path bound to container path |
| **Portability** | High portability across environments | Dependent on specific host directory path structure |
| **Use Case in Inception** | Persistent volume driver configured with host bind directory `/home/nakbas/data/` | Direct host data mapping for 42 subject persistence rules |

---

## Resources
- [Docker Official Documentation](https://docs.docker.com/)
- [Docker Compose Reference](https://docs.docker.com/compose/)
- [NGINX Beginner's Guide](https://nginx.org/en/docs/beginners_guide.html)
- [MariaDB Knowledge Base](https://mariadb.com/kb/en/)
- [WP-CLI Documentation](https://make.wordpress.org/cli/handbook/)

### AI Usage Declaration
AI assistance (Antigravity by Google DeepMind) was used during this project for:
1. **Architectural Planning**: Structuring Docker Compose setup to comply with 42 subject v5.4.
2. **Script Automation**: Drafting `mariadb-setup.sh`, `wp-setup.sh`, and `nginx-setup.sh` entrypoints.
3. **Documentation Generation**: Structuring `README.md`, `USER_DOC.md`, and `DEV_DOC.md` in standard Markdown format.

FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    mariadb-server \
    mariadb-client \
    bash \
    && rm -rf /var/lib/apt/lists/*

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY tools/mariadb-setup.sh /usr/local/bin/mariadb-setup.sh

RUN chmod +x /usr/local/bin/mariadb-setup.sh

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/mariadb-setup.sh"]

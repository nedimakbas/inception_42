FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    bash \
    && rm -rf /var/lib/apt/lists/*

COPY conf/nginx.conf /etc/nginx/conf.d/default.conf
COPY tools/nginx-setup.sh /usr/local/bin/nginx-setup.sh

RUN chmod +x /usr/local/bin/nginx-setup.sh

EXPOSE 443

ENTRYPOINT ["/usr/local/bin/nginx-setup.sh"]

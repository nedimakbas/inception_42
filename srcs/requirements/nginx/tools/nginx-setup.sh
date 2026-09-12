#!/bin/bash
set -e

# SSL Dizini Oluştur
mkdir -p /etc/nginx/ssl

# Sertifika yoksa oluştur
if [ ! -f /etc/nginx/ssl/inception.crt ]; then
    echo "Self-Signed SSL sertifikası üretiliyor..."
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/nginx/ssl/inception.key \
        -out /etc/nginx/ssl/inception.crt \
        -subj "/C=TR/ST=Istanbul/L=Istanbul/O=42School/OU=Inception/CN=${DOMAIN_NAME:-nakbas.42.fr}"
    echo "SSL sertifikası başarıyla üretildi."
fi

echo "NGINX ön planda (foreground) çalıştırılıyor..."
exec nginx -g "daemon off;"

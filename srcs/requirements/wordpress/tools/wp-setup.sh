#!/bin/bash
set -e

# Secrets dosyasından şifreleri oku
if [ -f /run/secrets/db_password ]; then
    MYSQL_PASSWORD=$(cat /run/secrets/db_password)
fi

if [ -f /run/secrets/credentials ]; then
    WP_ADMIN_PASSWORD=$(cat /run/secrets/credentials)
else
    WP_ADMIN_PASSWORD="AdminPassword123!"
fi

cd /var/www/html

# MariaDB servisinin hazır olmasını bekle
echo "MariaDB bağlantısı bekleniyor..."
while ! mariadb-admin ping -h mariadb -u "${MYSQL_USER}" --password="${MYSQL_PASSWORD}" --silent; do
    sleep 2
done
echo "MariaDB hazır!"

# WordPress kurulmamışsa indir ve yapılandır
if [ ! -f wp-config.php ]; then
    echo "WordPress indiriliyor ve yapılandırılıyor..."
    
    wp core download --allow-root

    wp config create \
        --dbname="${MYSQL_DATABASE}" \
        --dbuser="${MYSQL_USER}" \
        --dbpass="${MYSQL_PASSWORD}" \
        --dbhost="mariadb:3306" \
        --allow-root

    wp core install \
        --url="https://${DOMAIN_NAME}" \
        --title="${WP_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --skip-email \
        --allow-root

    wp user create "${WP_USER}" "${WP_USER_EMAIL}" \
        --user_pass="${MYSQL_PASSWORD}" \
        --role=author \
        --allow-root

    echo "WordPress kurulumu tamamlandı."
fi

# Dosya izinlerini düzelt
chown -R www-data:www-data /var/www/html

mkdir -p /run/php

echo "PHP-FPM başlatılıyor..."
exec php-fpm8.2 -F

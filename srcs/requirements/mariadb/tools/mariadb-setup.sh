#!/bin/bash
set -e

# Secrets dosyasından şifreleri oku
if [ -f /run/secrets/db_password ]; then
    MYSQL_PASSWORD=$(cat /run/secrets/db_password)
fi

if [ -f /run/secrets/db_root_password ]; then
    MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
fi

# Gerekli dizin izinlerini ayarla
mkdir -p /run/mysqld /var/lib/mysql
chown -R mysql:mysql /run/mysqld /var/lib/mysql

# Veritabanı henüz ilklendirilmediyse
if [ ! -d "/var/lib/mysql/$MYSQL_DATABASE" ]; then
    echo "MariaDB ilklendiriliyor..."

    mariadb-install-db --user=mysql --datadir=/var/lib/mysql > /dev/null

    # SQL ilklendirme komutları dosyası oluştur
    TMP_FILE=$(mktemp)
    cat << EOF > "$TMP_FILE"
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

    # Bootstrapping modunda MariaDB SQL komutlarını çalıştır
    mariadbd --user=mysql --bootstrap < "$TMP_FILE"
    rm -f "$TMP_FILE"

    echo "MariaDB veritabanı ve kullanıcılar başarıyla oluşturuldu."
fi

# MariaDB servis olarak ön planda (foreground) çalıştırılır
echo "MariaDB başlatılıyor..."
exec mariadbd --user=mysql

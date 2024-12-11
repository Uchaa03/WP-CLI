#!/bin/bash

# Importación de variables de entorno recordatorio de que se tiene que generar el propio
source .env.local

# Instalación de WP-CLI
echo "Descargando WP-CLI..."
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

echo "Dando permisos de ejecución a WP-CLI..."
sudo chmod +x wp-cli.phar

echo "Moviendo WP-CLI al directorio correcto..."
sudo mv wp-cli.phar /usr/local/bin/wp

# Descarga de WordPress
echo "Descargando WordPress..."
sudo wp core download --locale=es_ES --path=/var/www/html --allow-root

# Creación de la base de datos y el usuario en MySQL
echo "Creando base de datos y usuario en MySQL..."
mysql -u root -p$MYSQL_ROOT_PASSWORD <<EOF
CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE USER 'wp_user'@'localhost' IDENTIFIED BY '$DB_USER_WORDPRESS';
GRANT ALL PRIVILEGES ON wordpress.* TO 'wp_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;
EOF

# Creación del archivo de configuración de PHP para WordPress
echo "Creando el archivo de configuración de WordPress..."
sudo wp config create \
  --dbname=wordpress \
  --dbuser=wp_user \
  --dbpass=$DB_USER_WORDPRESS \
  --dbhost=localhost \
  --path=/var/www/html \
  --allow-root

# Instalación de WordPress
echo "Instalando WordPress..."
sudo wp core install \
  --url=$WP_URL \
  --title="$WP_TITLE" \
  --admin_user=$WP_ADMIN_USER \
  --admin_password=$WP_ADMIN_PASSWORD \
  --admin_email=$WP_ADMIN_EMAIL \
  --path=/var/www/html \
  --allow-root

echo "Instalación de WordPress completa."

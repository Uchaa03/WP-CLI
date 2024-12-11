# Administración de Wordpress con la utilidad WP-CLI

Vamos a realizar un script para la instalación y administración de wordpress con **WP-CLI**, para ello primero 
instalaremos LAMP con el script de instalación `install_lamp.sh`, recordar que tenemos que generar nuestro archivo 
`.env.local` utilizando la referencia de `.env.example`.

## Configuración de certificado SSL/TLS en el servidor Apache
Lo primero es tener apache instalado, que lo tendremos ya con el script comentado anterioremente. Y ahora lo siguiente
sería instalar **Certbot**:
````shell
apt install -y certbot python3-certbot-apache 
````

Habilitamos el módulo ssl y su sitio de confiugración:
````shell
a2enmod ssl

a2ensite default-ssl.conf
````

Copiamos los archivos de configuración para poder habilitar apache SSl/TLS.
````shell
sudo cp ./conf/000-default.conf /etc/apache2/sites-available/000-default.conf
sudo cp ./conf/default-ssl.conf /etc/apache2/sites-available/default-ssl.conf
````

Obtenemos el certificado SSL/TLS para el dominio que hayamos configurado en el archivo.
````shell
sudo certbot --apache --non-interactive --agree-tos --email $EMAIL -d $DOMAIN

# Habilitamos la renovación automñatica del certificado SSL
sudo systemctl enable certbot.timer && sudo systemctl start certbot.timer
````

Y siemrpe reinciar el servicio, importante que nuestro dns redirija a la ip correspondiente asociada al dns desde 
`/etc/hosts`.

## Instalación de WP-CLI en LAMP
Para instalarlo, necesitaremos un archivo de configuración `.phar` son similares a los de java, estos.

````shell
# Descargamos el paquete
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

# Le damos permisos
sudo chmod +x wp-cli.phar

# Movemos al directorio correcto
sudo mv wp-cli.phar /usr/local/bin/wp
````

Una vez finalizado ya podemos utilizar el comando `wp` para trabajar con wordpress

## Instalación de WordPress con WP-CLI
Descargamos el código fuente
````shell
# Comando para instalarlo en directorio directo y con el idioma seleccionado
sudo  wp core download --locale=es_ES --path=/var/www/html --allow-root
````

## Creación de la base de datos en MySQLServer
Comandos en el que creamos la base de datos y configuramos un usuario para wordpress
````shell
mysql -u root -p$MYSQL_ROOT_PASSWORD <<EOF
CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE USER 'wp_user'@'localhost' IDENTIFIED BY $DB_USER_WORDPRESS;
GRANT ALL PRIVILEGES ON wordpress.* TO 'wp_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;
EOF
````

### Creación de archivo de configuración de PHP
Utilizamos el comando wp para la instalación del archivo php
````shell
# Instalación con condifuración
sudo wp config create \
  --dbname=wordpress \
  --dbuser=wp_user \
  --dbpass=$DB_USER_WORDPRESS \
  --dbhost=localhost \
  --path=/var/www/html \
  --allow-root
````

### Instalación de WordPress
````shell
wp core install \
  --url=practica-wordpress.ddns.net \
  --title="UCHA" \
  --admin_user=admin \
  --admin_password=$DB_USER_WORDPRESS \
  --admin_email=test@test.com \
  --path=/var/www/html \
  --allow-root 
````

Al instalarlo usando sudo todo tenemos que cambiar el usuario del directorio al que pertenece al de apache
````shell
sudo chown -R www-data:www-data /var/www/html
````

### Comandos para actualización de los paquetes de WordPress
````shell

# Actualización de plugins a la última versión
wp plugin update --all

# Actualicación de temas
wp theme update --all

# Comprueba la version del core
wp core check-update

# Lo actualiza a la ultima versión
wp core update
````

Y con esto ya estaría todo configurado
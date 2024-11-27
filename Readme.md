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

#!/bin/bash
# La utilización de barras invertidas es para mejorar la legibilidad del script

# Importación de variables de entorno recordatorio de que se tiene que generar el propio
source .env.local

# Actualización de paquetes del sistema
sudo apt update && \
sudo apt upgrade -y && \
echo "" && \
echo "Sistema actualizado correctamente"
sleep 2  # Espera 2 segundos para que de tiempo a leer los echo

# Instalación de Apache
sudo apt install apache2 -y && \
echo "" && \
echo "Apache fue instalado correctamente"
sleep 2

# Cambiar la contraseña de root de mysql utilizando nuestras variables de entorno
mysql -u root -p"$ROOT_PASSWORD" <<EOF
  ALTER USER 'root'@'localhost' IDENTIFIED WITH caching_sha2_password BY "$MYSQL_ROOT_PASSWORD";
  FLUSH PRIVILEGES;
  # Para salir del mysql con el eof
EOF

echo "" && \
echo "La contraseña de root de MySQL fue cambiada con éxito"
sleep 3


# Instalación de PHP y sus módulos
sudo apt install php libapache2-mod-php php-mysql -y && \
echo "" && echo "PHP se instaló exitosamente"
# Copiamos el fichero creado
sudo cp ../php/info.php /var/www/html/info.php
# Le damos permisos al usuario de apache para que lo muestre correctamente
sudo chown www-data:www-data /var/www/html/info.php && echo "" && echo "Fichero copiado"
sudo systemctl restart apache2 && echo "" && echo "Módulos cargados"
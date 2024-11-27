# Configuración script de SSL/TLS en apache

# Importación de variables de entorno recordatorio de que se tiene que generar el propio
source .env.local

# Instalación de certbot
sudo apt install -y certbot python3-certbot-apache && echo ""
echo "Certbot instalado correctamente"
sleep 2

# Habilitación de módulo de encriptado SSL/TLS de apache
a2enmod ssl && a2ensite default-ssl.conf $$ echo ""
echo "Módulo SSL/TLS habilitado correctamente"
sleep 2

# Copia de archivos de configuración de Apache con SSL
sudo cp ./conf/000-default.conf /etc/apache2/sites-available/000-default.conf
sudo cp ./conf/default-ssl.conf /etc/apache2/sites-available/default-ssl.conf
echo "" && echo "Archivos de configuración copaidos"
sleep 2

# Obtención de certificado SSL

sudo certbot --apache --non-interactive --agree-tos --email $EMAIL -d $DOMAIN && echo ""
echo "Certificado SSL generado"
sleep 2

sudo systemctl enable certbot.timer && sudo systemctl start certbot.timer && echo ""
echo "Configurada la renovación automática del certificado SSL..."

sudo systemctl restart apache2 && echo "Apache con ssl configurado"
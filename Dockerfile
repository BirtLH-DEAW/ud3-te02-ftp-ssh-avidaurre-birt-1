# Utilizamos una imagen oficial de Ubuntu
FROM ubuntu:latest

# Damos información sobre la imagen que estamos creando
LABEL \
    version="1.0" \
    description="Ubuntu + Apache2 + virtual host" \
    maintainer="usuarioBIRT <usuarioBIRT@birt.eus>"

# Actualizamos la lista de paquetes e instalamos nano y apache2
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y nano apache2 && \
    rm -rf /var/lib/apt/lists/*

# Creamos directorios para los sitios web y configuraciones
RUN mkdir -p /var/www/html/sitioprimero /var/www/html/sitiosegundo

# Copiamos archivos al contenedor
COPY index1.html index2.html sitioprimero.conf sitiosegundo.conf sitioprimero.key sitioprimero.cer /

# Movemos los archivos a sus ubicaciones adecuadas
RUN mv /index1.html /var/www/html/sitioprimero/index.html && \
    mv /index2.html /var/www/html/sitiosegundo/index.html && \
    mv /sitioprimero.conf /etc/apache2/sites-available/sitioprimero.conf && \
    mv /sitiosegundo.conf /etc/apache2/sites-available/sitiosegundo.conf && \
    mv /sitioprimero.key /etc/ssl/private/sitioprimero.key && \
    mv /sitioprimero.cer /etc/ssl/certs/sitioprimero.cer
# Habilitamos los sitios y el módulo SSL
RUN a2ensite sitioprimero.conf && \
    a2ensite sitiosegundo.conf && \
    a2enmod ssl

#1 AVIDAURRE1 FTP
RUN apt-get install proftpd --yes
RUN useradd -m -d /var/www/html/sitioPrimero / -s /usr/sbin/nologin -p $(openssl passwd 	-1 avidaurre1) avidaurre1
RUN chown avidaurre1 /var/www/html/sitioPrimero 

COPY ftp/proftpd.conf /etc/proftpd/proftpd.conf
COPY ftp/tls.conf /etc/proftpd/tls.conf
COPY ftp/proftpd.crt /etc/ssl/certs/proftpd.crt
COPY ftp/proftpd.key /etc/ssl/private/proftpd.key

#2 AVIDAURRE2 SSH
RUN apt-get install ssh --yes
RUN useradd -m -d /var/www/html/sitioSegundo/ -p $(openssl passwd -1 avidaurre2) avidaurre2
RUN chown avidaurre2 /var/www/html/sitioSegundo

# Exponemos los puertos
EXPOSE 80
EXPOSE 443



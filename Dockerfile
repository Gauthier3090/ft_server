# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: gpladet <gpladet.student.s19.be>           +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/05/13 13:58:05 by gpladet           #+#    #+#              #
#    Updated: 2020/05/22 17:35:25 by gpladet          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM debian:buster

RUN apt-get update && apt-get upgrade;

RUN apt-get install -y nginx;

RUN apt-get install -y php-fpm php-mysql php-json;

RUN apt-get install -y wget unzip php-mbstring php-zip php-gd;

RUN apt-get install -y php-dom php-simplexml php-ssh2 php-xml php-xmlreader php-curl \
php-exif php-ftp php-iconv php-imagick php-posix php-sockets php-tokenizer

RUN apt-get install -y mariadb-server mariadb-client;

RUN mkdir /utils

RUN wget https://files.phpmyadmin.net/phpMyAdmin/4.9.5/phpMyAdmin-4.9.5-all-languages.zip

RUN wget https://wordpress.org/latest.zip

RUN unzip phpMyAdmin-4.9.5-all-languages.zip

RUN unzip latest.zip

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-subj "/C=BE/ST=Uccle/L=Brussels/O=19/CN=gpladet" \
    -keyout /etc/ssl/private/nginx.key -out /etc/ssl/certs/nginx.crt

COPY /srcs/default /etc/nginx/sites-available/default

RUN mv phpMyAdmin-4.9.5-all-languages/ /var/www/html/phpmyadmin

RUN mv wordpress /var/www/html/wordpress

RUN chown -R www-data:www-data /var/www/html/phpmyadmin

RUN chmod -R 755 /var/www/html/phpmyadmin

RUN chown -R www-data:www-data /var/www/html/wordpress

RUN chmod -R 755 /var/www/html/wordpress

COPY /srcs/config.inc.php /var/www/html/phpmyadmin/config.inc.php

RUN rm /var/www/html/phpmyadmin/config.sample.inc.php

COPY /srcs/wp-config.php /var/www/html/wordpress

RUN rm /var/www/html/wordpress/wp-config-sample.php

COPY /srcs/init.sql /utils

RUN service mysql start && mysql -u root -p && mysql < /utils/init.sql \
&& mysql < /var/www/html/phpmyadmin/sql/create_tables.sql -u root --password=root

COPY /srcs/launch.sh /utils

COPY /srcs/infos.php /var/www/html

EXPOSE 80 443

CMD ["bash", "utils/launch.sh"]

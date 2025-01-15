FROM php:8.4-fpm-alpine

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN apk update && apk upgrade

# Install dependencies
RUN apk add mariadb-client ca-certificates postgresql-dev libssh-dev zip libzip-dev libxml2-dev jpegoptim optipng pngquant gifsicle libxslt-dev rabbitmq-c-dev icu-dev oniguruma-dev gmp-dev

RUN apk add freetype-dev libjpeg-turbo-dev libpng-dev jpeg-dev libwebp-dev

RUN apk add supervisor bash curl unzip git

# RUN apk add --update linux-headers
# RUN apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
#     && pecl install xdebug \
#     && docker-php-ext-enable xdebug \
#     && apk del -f .build-deps
RUN apk add --update linux-headers

RUN apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
    # Manually download and install Xdebug compatible with PHP 8.4
    && mkdir -p /usr/src/php/ext/xdebug \
    && curl -fsSL https://xdebug.org/files/xdebug-3.4.0beta1.tgz | tar xvz -C /usr/src/php/ext/xdebug --strip 1 \
    && docker-php-ext-install xdebug \
    && git clone https://github.com/phpredis/phpredis.git /usr/src/php/ext/redis \
    && cd /usr/src/php/ext/redis \
    && phpize \
    && ./configure \
    && make \
    && make install \
    && docker-php-ext-enable redis \
    && apk del .build-deps

# Install extensions
RUN chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions zip opcache pdo_mysql pdo_pgsql mysqli bcmath sockets xsl exif intl gmp pcntl gd


#RUN docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg --with-webp && docker-php-ext-install gd

WORKDIR /var/www

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]

RUN set -eux; \
	version='6.7.1'; \
	sha1='dfb745d4067368bb9a9491f2b6f7e8d52d740fd1'; \
	\
	curl -o wordpress.tar.gz -fL "https://wordpress.org/wordpress-$version.tar.gz"; \
	echo "$sha1 *wordpress.tar.gz" | sha1sum -c -; \
	\
# upstream tarballs include ./wordpress/ so this gives us /usr/src/wordpress
	tar -xzf wordpress.tar.gz -C /usr/src/; \
	rm wordpress.tar.gz; \
	\
# https://wordpress.org/support/article/htaccess/
	[ ! -e /usr/src/wordpress/.htaccess ]; \
	{ \
		echo '# BEGIN WordPress'; \
		echo ''; \
		echo 'RewriteEngine On'; \
		echo 'RewriteRule .* - [E=HTTP_AUTHORIZATION:%{HTTP:Authorization}]'; \
		echo 'RewriteBase /'; \
		echo 'RewriteRule ^index\.php$ - [L]'; \
		echo 'RewriteCond %{REQUEST_FILENAME} !-f'; \
		echo 'RewriteCond %{REQUEST_FILENAME} !-d'; \
		echo 'RewriteRule . /index.php [L]'; \
		echo ''; \
		echo '# END WordPress'; \
	} > /usr/src/wordpress/.htaccess; \
	\
	chown -R www-data:www-data /usr/src/wordpress; \
# pre-create wp-content (and single-level children) for folks who want to bind-mount themes, etc so permissions are pre-created properly instead of root:root
# wp-content/cache: https://github.com/docker-library/wordpress/issues/534#issuecomment-705733507
	mkdir wp-content; \
	for dir in /usr/src/wordpress/wp-content/*/ cache; do \
		dir="$(basename "${dir%/}")"; \
		mkdir "wp-content/$dir"; \
	done; \
	chown -R www-data:www-data wp-content; \
	chmod -R 1777 wp-content

VOLUME /var/www/html

COPY --chown=www-data:www-data wp-config-docker.php /usr/src/wordpress/
COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["php-fpm"]

# Add WP CLI
RUN curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar   && chmod +x /usr/local/bin/wp

FROM php:8.4-fpm-alpine

# Cài đặt các dependencies và PHP extensions trong một layer
RUN set -eux; \
    # Cài đặt docker-php-extension-installer
    curl -sSLf https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions \
        -o /usr/local/bin/install-php-extensions && \
    chmod +x /usr/local/bin/install-php-extensions && \
    # Cài đặt các dependencies cần thiết
    apk add --no-cache bash ghostscript && \
    # Cài đặt PHP extensions
    install-php-extensions bcmath exif gd intl mysqli zip imagick && \
    # Cấu hình PHP
    docker-php-ext-enable opcache && \
    echo 'opcache.memory_consumption=128' > /usr/local/etc/php/conf.d/opcache-recommended.ini && \
    echo 'opcache.interned_strings_buffer=8' >> /usr/local/etc/php/conf.d/opcache-recommended.ini && \
    echo 'opcache.max_accelerated_files=4000' >> /usr/local/etc/php/conf.d/opcache-recommended.ini && \
    echo 'opcache.revalidate_freq=2' >> /usr/local/etc/php/conf.d/opcache-recommended.ini && \
    # Cấu hình error logging
    echo 'error_reporting = E_ERROR | E_WARNING | E_PARSE | E_CORE_ERROR | E_CORE_WARNING | E_COMPILE_ERROR | E_COMPILE_WARNING | E_RECOVERABLE_ERROR' > /usr/local/etc/php/conf.d/error-logging.ini && \
    echo 'display_errors = Off' >> /usr/local/etc/php/conf.d/error-logging.ini && \
    echo 'display_startup_errors = Off' >> /usr/local/etc/php/conf.d/error-logging.ini && \
    echo 'log_errors = On' >> /usr/local/etc/php/conf.d/error-logging.ini && \
    echo 'error_log = /dev/stderr' >> /usr/local/etc/php/conf.d/error-logging.ini && \
    echo 'log_errors_max_len = 1024' >> /usr/local/etc/php/conf.d/error-logging.ini && \
    echo 'ignore_repeated_errors = On' >> /usr/local/etc/php/conf.d/error-logging.ini && \
    echo 'ignore_repeated_source = Off' >> /usr/local/etc/php/conf.d/error-logging.ini && \
    echo 'html_errors = Off' >> /usr/local/etc/php/conf.d/error-logging.ini && \
    # Cài đặt WordPress
    WP_VERSION='6.7.1' && \
    WP_SHA1='dfb745d4067368bb9a9491f2b6f7e8d52d740fd1' && \
    curl -o wordpress.tar.gz -fL "https://wordpress.org/wordpress-$WP_VERSION.tar.gz" && \
    echo "$WP_SHA1 *wordpress.tar.gz" | sha1sum -c - && \
    tar -xzf wordpress.tar.gz -C /usr/src/ && \
    rm wordpress.tar.gz && \
    # Cấu hình WordPress
    echo '# BEGIN WordPress\nRewriteEngine On\nRewriteRule .* - [E=HTTP_AUTHORIZATION:%{HTTP:Authorization}]\nRewriteBase /\nRewriteRule ^index\.php$ - [L]\nRewriteCond %{REQUEST_FILENAME} !-f\nRewriteCond %{REQUEST_FILENAME} !-d\nRewriteRule . /index.php [L]\n# END WordPress' > /usr/src/wordpress/.htaccess && \
    # Thiết lập thư mục WordPress
    chown -R www-data:www-data /usr/src/wordpress && \
    mkdir -p wp-content && \
    cd /usr/src/wordpress/wp-content && \
    for dir in */ cache; do \
        mkdir -p "/var/www/html/wp-content/$(basename "${dir%/}")"; \
    done && \
    chown -R www-data:www-data /var/www/html/wp-content && \
    chmod -R 1777 /var/www/html/wp-content && \
    # Cài đặt WP-CLI
    curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x /usr/local/bin/wp && \
    # Dọn dẹp
    rm -rf /var/cache/apk/* /tmp/* /var/tmp/*

VOLUME /var/www/html
COPY --chown=www-data:www-data wp-config-docker.php /usr/src/wordpress/
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["php-fpm"]

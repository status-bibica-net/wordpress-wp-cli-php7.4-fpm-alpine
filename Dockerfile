FROM wordpress:php8.3-fpm-alpine

# Add WP CLI
RUN curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar   && chmod +x /usr/local/bin/wp

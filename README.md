# wordpress-wp-cli-php7.4-fpm-alpine

## Introduction
I created a version based on the [Dockerfile](https://github.com/docker-library/wordpress/blob/0015d465b4115ade0e0f98b3df8b5c17ec4a98e4/latest/php8.3/fpm-alpine/Dockerfile) structure from WordPress.

PHP 7.4 + WordPress with Composer and WP-CLI

## Features

- Uses [docker-php-extension-installer](https://github.com/mlocati/docker-php-extension-installer) to install extensions .
- Keeps all extensions as in the original, adds `Composer` and `WP-CLI`.
- Supports two common platforms: `amd64` and `arm64`.
- Updated once a day at 12:00 AM Vietnam time (UTC +7), ensuring the use of the latest versions.

```
php -v
PHP 7.4.33 (cli) (built: Nov 12 2022 05:16:49) ( NTS )
Copyright (c) The PHP Group
Zend Engine v3.4.0, Copyright (c) Zend Technologies
    with Zend OPcache v7.4.33, Copyright (c), by Zend Technologies
```
```
WP-CLI 2.11.0
Composer version 2.8.4 2024-12-11 11:57:47
PHP version 7.4.33 (/usr/local/bin/php)
[PHP Modules]
bcmath
Core
ctype
curl
date
dom
exif
fileinfo
filter
ftp
gd
hash
iconv
intl
json
libxml
mbstring
mysqli
mysqlnd
openssl
pcre
PDO
pdo_sqlite
Phar
posix
readline
Reflection
session
SimpleXML
sodium
SPL
sqlite3
standard
tokenizer
xml
xmlreader
xmlwriter
Zend OPcache
zip
zlib
```

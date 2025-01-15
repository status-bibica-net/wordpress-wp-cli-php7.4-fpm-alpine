# wordpress-php8.4-fpm-alpine

Cập nhập PHP8.4 cho [Docker-LCMP-Multisite](https://github.com/bibicadotnet/Docker-LCMP-Multisite-WordPress-Minimal)

```docker pull bibica/wordpress-wp-cli-php8.4-fpm-alpine:latest```

Không rõ lắm lý do vì sao WordPress chưa làm bản images cho PHP 8.4, nên làm dựa cấu trúc Dockerfile các bản cũ hơn của WordPress

* Giữ nguyên mọi extensions như bản gốc và bổ xung thêm WP-CLI 2.11.0
* Sử dụng [docker-php-extension-installer](https://github.com/mlocati/docker-php-extension-installer) để cài đặt các extensions
* Duy trì trên 2 nền tảng thông dụng amd64 và arm64

```
PHP 8.4.2 (cli) (built: Jan  8 2025 19:12:14) (NTS)
Copyright (c) The PHP Group
Built by https://github.com/docker-library/php
Zend Engine v4.4.2, Copyright (c) Zend Technologies
    with Zend OPcache v8.4.2, Copyright (c), by Zend Technologies
```
```
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
gd
hash
iconv
imagick
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
random
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

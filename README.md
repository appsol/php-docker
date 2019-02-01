# php-docker
Docker image for quick and easy PHP development.

## Configuration

Out of the box PHP is installed with the following modules:

- bcmath
- Core
- ctype
- curl
- date
- dom
- fileinfo
- filter
- ftp
- gd
- hash
- iconv
- intl
- json
- libxml
- mbstring
- mcrypt
- mysqli
- mysqlnd
- openssl
- pcre
- PDO
- pdo_mysql
- pdo_sqlite
- Phar
- posix
- readline
- redis
- Reflection
- session
- SimpleXML
- soap
- SPL
- sqlite3
- standard
- tokenizer
- xdebug
- xml
- xmlreader
- xmlwriter
- xsl
- Zend OPcache
- zip
- zlib


### Apache

Available in the following tagged PHP versions:

- 5.6 (appsol/php-docker:5.6-apache)
- 7.0 (appsol/php-docker:7.0-apache)
- 7.1 (appsol/php-docker:7.1-apache)
- 7.2 (appsol/php-docker:7.2-apache)

Create a default site configuration file as shown in docker-compose/apache/docker-compose.yml to change the site hosting parameters (Document Root, environment variables, etc)

### FPM

Avaliable in the following tagged PHP versions:

- 7.1 (appsol/php-docker:7.1-fpm)
- 7.2 (appsol/php-docker:7.2-fpm)

Create a Nginx configuration file as demonstrated in docker-compose/fpm/docker-compose.yml. This also shows the PHP FPM and Nginx services running in seperate containers.

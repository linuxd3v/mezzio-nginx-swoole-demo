FROM ubuntu:22.04
LABEL author="linuxd3v"

#Do not set this as env variable
#https://serverfault.com/questions/618994/when-building-from-dockerfile-debian-ubuntu-package-install-debconf-noninteract
ARG DEBIAN_FRONTEND=noninteractive


# Build time arguments
ARG PROJECT_NAME
ARG ENV_NAME
ARG PHP_VER


#I: Install base requirements
# software-properties-common - for ppa
# ca-certificates - for https curl
RUN apt-get update && \
apt-get install --no-install-recommends --no-install-suggests -y \
gpg-agent \
inotify-tools \
software-properties-common \
locales \
ca-certificates \
less \
curl \
xz-utils \
vim-tiny \
brotli

#I: Set Locale for Docker Container
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && locale-gen
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE en_US:en

#Install openswoole repository
RUN add-apt-repository ppa:openswoole/ppa -y


# Instaling PHP modules
RUN apt-get update && \
apt-get install --no-install-recommends --no-install-suggests -y \
php \
php${PHP_VER}-openswoole \
#php${PHP_VER}-swoole \
php-intl \
php-bcmath \
php-redis \
php-curl \
php-cli \
php-xml \
php-imagick \
php-gd \
php-zip \
php-mbstring \
php-mysql \
php-uuid \
php-common \
php-php-gettext \
&& apt-get -y --purge autoremove && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/{man,doc}


#PHP: configuring
#RUN mv /etc/php/${PHP_VER}/fpm/php.ini /etc/php/${PHP_VER}/fpm/php.ini.bak
RUN mv /etc/php/${PHP_VER}/cli/php.ini /etc/php/${PHP_VER}/cli/php.ini.bak

#ADD php${PHP_VER}/php.ini  /etc/php/${PHP_VER}/fpm/php.ini
ADD php${PHP_VER}/php_cli.ini /etc/php/${PHP_VER}/cli/php.ini
#ADD php${PHP_VER}/zz-docker.conf /etc/php/${PHP_VER}/fpm/pool.d/zz-docker.conf


#Any custom code 
ADD php${PHP_VER}/custom.sh /tmp/custom.sh
RUN chmod +x /tmp/custom.sh
RUN /tmp/custom.sh


#Configuration overrides:
#RUN sed -i "s/ENV_PROJECT_NAME/${PROJECT_NAME}/" /etc/php/${PHP_VER}/fpm/php.ini
RUN sed -i "s/ENV_PROJECT_NAME/${PROJECT_NAME}/" /etc/php/${PHP_VER}/cli/php.ini


#External volumes
VOLUME ["/app"]
VOLUME ["/appdata"]

EXPOSE 8080

WORKDIR /app

# Launch mezzio/openswoole application
ENTRYPOINT ["./mezzio/vendor/bin/laminas", "mezzio:swoole:start"]
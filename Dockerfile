FROM ubuntu:20.04
WORKDIR /tmp
ARG BSS_VERSION=6.0.2
ARG APT_MIRROR=mirrors.ustc.edu.cn
ARG APT_SECURITY_MIRROR=mirrors.ustc.edu.cn
RUN sed -i "s@http://.*archive.ubuntu.com@http://${APT_MIRROR}@g" /etc/apt/sources.list && sed -i "s@http://.*security.ubuntu.com@http://${APT_SECURITY_MIRROR}@g" /etc/apt/sources.list
RUN apt update && apt install wget -y
RUN wget -c http://mirrors.linuxeye.com/oneinstack-full.tar.gz && tar xzf oneinstack-full.tar.gz && ./oneinstack/install.sh --nginx_option 1 --php_option 12 --phpcache_option 1 --php_extensions fileinfo,memcached --memcached
ENV PATH=/usr/local/nginx/bin:/usr/local/php/bin:$PATH
WORKDIR /www/bss
RUN curl -o /tmp/bss.zip https://github.com/bs-community/blessing-skin-server/releases/download/${BSS_VERSION}/blessing-skin-server-${BSS_VERSION}.zip && \
    mv /tmp/bss.zip . && unzip bss.zip && rm bss.zip
RUN cp .env.example .env && /usr/local/php/bin/php artisan key:generate
CMD systemctl start nginx && systemctl start php-fpm
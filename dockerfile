FROM nextcloud:apache

RUN mkdir -p /usr/share/man/man1 \
    && apt-get update && apt-get install -y \
        supervisor \
        ffmpeg \
        libbz2-dev \
        libgmp3-dev \
        libc-client-dev \
        libkrb5-dev \
        smbclient \
        libsmbclient-dev \
        libreoffice \
        wget \
        vim \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && ln -s "/usr/include/$(dpkg-architecture --query DEB_BUILD_MULTIARCH)/gmp.h" /usr/include/gmp.h \
    && docker-php-ext-install bz2 gmp imap \
    && pecl install smbclient \
    && docker-php-ext-enable smbclient \
    && mkdir /var/log/supervisord /var/run/supervisord

RUN wget http://raw.githubusercontent.com/nextcloud/docker/master/.examples/dockerfiles/full/apache/supervisord.conf -O /etc/supervisor/supervisord.conf

RUN wget http://github.com/dewmon689/nextclouddockerfiles/blob/master/smb.conf -O /etc/samba/smb.conf

ENV NEXTCLOUD_UPDATE=1

CMD ["/usr/bin/supervisord"]

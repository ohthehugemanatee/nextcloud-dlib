FROM linuxserver/nextcloud

# Install prereq dlib shared library.
RUN apk add -X http://dl-cdn.alpinelinux.org/alpine/edge/testing dlib

# Install dlib PHP extension source
# RUN wget https://github.com/goodspb/pdlib/archive/master.zip \
#   && mkdir -p /usr/src/php/ext/ \
#   && unzip -d /usr/src/php/ext/ master.zip \
#   && rm master.zip
# Install build deps for php7-pdlib
RUN apk add --no-cache --virtual=build-dependencies --upgrade \
	autoconf \
	automake \
	file \
	g++ \
	gcc \
	make \
	php7-dev
# Compile and install php7-pdlib version in use for facerecognition
RUN wget -c -q https://github.com/matiasdelellis/pdlib/archive/master.zip \
    && unzip master.zip \
    && mv pdlib-* pdlib \
    && cd pdlib \
    && phpize \
    && ./configure \
    && make \
    && make install
RUN echo "extension=pdlib.so" > /etc/php7/conf.d/pdlib.ini
# Remove those build deps again
RUN apk del \
        autoconf \
        automake \
        file \
        g++ \
        gcc \
        make \
        php7-dev

RUN apk add bzip2-dev

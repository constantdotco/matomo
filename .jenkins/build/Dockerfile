FROM php:7.4-fpm-alpine as builder

RUN apk add --no-cache curl \
    git \
    zip \
    git-lfs

ENV SUBMODULES_PACKAGED_WITH_CORE='log-analytics|plugins/Morpheus/icons|plugins/TagManager|plugins/Provider|plugins/CustomVariables'

COPY ./.jenkins/build/build-package.sh /build/build-package.sh

WORKDIR /app
COPY . /app

RUN /build/build-package.sh

FROM php:7.4-fpm-alpine

LABEL maintainer="pierre@piwik.org"

RUN set -ex; \
	\
	apk add --no-cache --virtual .build-deps \
		$PHPIZE_DEPS \
		autoconf \
		freetype-dev \
		icu-dev \
		libjpeg-turbo-dev \
		libpng-dev \
		libzip-dev \
		openldap-dev \
		pcre-dev \
	; \
	\
	docker-php-ext-configure gd --with-freetype --with-jpeg; \
	docker-php-ext-configure ldap; \
	docker-php-ext-install -j "$(nproc)" \
		gd \
		ldap \
		mysqli \
		opcache \
		pdo_mysql \
		zip \
	; \
	\
# pecl will claim success even if one install fails, so we need to perform each install separately
	pecl install APCu-5.1.20; \
	pecl install redis-5.3.4; \
	\
	docker-php-ext-enable \
		apcu \
		redis \
	; \
	rm -r /tmp/pear; \
	\
	runDeps="$( \
		scanelf --needed --nobanner --format '%n#p' --recursive /usr/local/lib/php/extensions \
		| tr ',' '\n' \
		| sort -u \
		| awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
	)"; \
	apk add --virtual .matomo-phpext-rundeps $runDeps; \
	apk del .build-deps

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=2'; \
		echo 'opcache.fast_shutdown=1'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini

COPY --from=builder /app /usr/src/matomo

COPY .jenkins/build/php.ini /usr/local/etc/php/conf.d/php-matomo.ini

# https://blog.maxmind.com/2019/12/18/significant-changes-to-accessing-and-using-geolite2-databases/
#RUN set -ex; \
#	curl -fsSL -o GeoIPCity.tar.gz \
#		"https://geolite.maxmind.com/download/geoip/database/GeoLite2-City.tar.gz"; \
#	curl -fsSL -o GeoIPCity.tar.gz.md5 \
#		"https://geolite.maxmind.com/download/geoip/database/GeoLite2-City.tar.gz.md5"; \
#	echo "$(cat GeoIPCity.tar.gz.md5)  GeoIPCity.tar.gz" | md5sum -c -; \
#	mkdir /usr/src/GeoIPCity; \
#	tar -xf GeoIPCity.tar.gz -C /usr/src/GeoIPCity --strip-components=1; \
#	mv /usr/src/GeoIPCity/GeoLite2-City.mmdb /usr/src/matomo/misc/GeoLite2-City.mmdb; \
#	rm -rf GeoIPCity*

COPY .jenkins/build/docker-entrypoint.sh /entrypoint.sh

# WORKDIR is /var/www/html (inherited via "FROM php")
# "/entrypoint.sh" will populate it at container startup from /usr/src/matomo
VOLUME /var/www/html

ENTRYPOINT ["/entrypoint.sh"]
CMD ["php-fpm"]

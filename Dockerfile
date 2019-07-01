FROM ubuntu:18.04


ENV DEBIAN_FRONTEND noninteractive
ENV UNBOUND_VERSION 1.9.0
ENV UNBOUND_SHA256 415af94b8392bc6b2c52e44ac8f17935cc6ddf2cc81edfb47c5be4ad205ab917

RUN set -x \
	&& apt update \
	&& apt -y upgrade \
	&& apt -y install build-essential libssl-dev libexpat-dev libsodium-dev libevent-dev openssl wget  knot-dnsutils \
	&& groupadd -g 88 unbound \
	&& useradd -c "Unbound DNS resolver" -d /var/lib/unbound -u 88 -g unbound -s /bin/false unbound \
	&& wget http://www.unbound.net/downloads/unbound-${UNBOUND_VERSION}.tar.gz \
	&& echo "${UNBOUND_SHA256}  unbound-${UNBOUND_VERSION}".tar.gz | sha256sum --check \
	&& tar -xvf unbound* \
	&& cd unbound-1.*/ \
	&& ./configure --with-libevent --enable-dnscrypt --prefix=/usr --sysconfdir=/etc --disable-static --with-pidfile=/run/unbound.pid \
	&& make \
	&& make install \
	&& mv -v /usr/sbin/unbound-host /usr/bin/ \
	&& unbound-anchor /etc/unbound/root.key  ; true\
	&& unbound-control-setup \
	&& unbound-checkconf \
	&& rm -rf /unbound-${UNBOUND_VERSION}.tar.gz \
	&& rm -rf unbound-* \
	&& rm -rf /var/lib/apt/lists/* \
  && apt-get clean

ADD ./unbound.conf /etc/unbound/unbound.conf
#ADD ./privkey.pem /etc/unbound/privkey.pem
#ADD ./fullchain.pem /etc/unbound/fullchain.pem
ADD ./unbound.sh /unbound.sh
RUN chmod u+x /unbound.sh
WORKDIR /etc/unbound/

EXPOSE 853

CMD ["/unbound.sh"]

FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

RUN set -x \
	&& apt update \
	&& apt -y upgrade \
    && apt -y install openssl wget lsb-release \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean


ADD ./install-dnss.sh /install-dnss.sh
RUN chmod u+x /install-dnss.sh
CMD ["/install-dnss.sh"]

WORKDIR /etc/dns/
CMD ["./start.sh"]
#EXPOSE 853



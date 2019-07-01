FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

RUN set -x \
	&& apt update \
	&& apt -y upgrade \
    && apt -y install openssl wget lsb-release \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean


ADD ./install-ubuntu.sh /install-ubuntu.sh
RUN chmod u+x /install-ubuntu.sh
WORKDIR /

#EXPOSE 853

CMD ["/install-ubuntu.sh"]
CMD ["sleep","999"]

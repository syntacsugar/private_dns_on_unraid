FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

RUN set -x \
	&& apt update \
	&& apt -y upgrade \
    && apt -y install openssl wget lsb-release libunwind8 icu-devtools apt-transport-https aspnetcore-runtime-2.2\
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p "/etc/dns" \
    && wget -q "https://packages.microsoft.com/config/ubuntu/$(lsb_release -r -s)/packages-microsoft-prod.deb" -O "$dnsDir/packages-microsoft-prod.deb" \
    && dpkg -i "$dnsDir/packages-microsoft-prod.deb"  \
    && sleep 2 \
    && echo "Downloading Technitium DNS Server..." \
    && wget -q https://download.technitium.com/dns/DnsServerPortable.tar.gz -O /etc/dns/DnsServerPortable.tar.gz \
    && tar -zxf /etc/dns/DnsServerPortable.tar.gz -C "/etc/dns" \

CMD ["cat","/etc/dns/install.log"]
WORKDIR /etc/dns/
CMD ["./start.sh"]
CMD ["sleep","9999"]
#EXPOSE 853



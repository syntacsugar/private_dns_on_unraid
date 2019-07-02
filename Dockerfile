FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

RUN set -x apt update\
	&& apt -y upgrade \
    && add-apt-repository universe \
    && apt -y install openssl wget lsb-release libunwind8 icu-devtools apt-transport-https aspnetcore-runtime-2.2\
    && wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.asc.gpg && mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/ && wget -q https://packages.microsoft.com/config/ubuntu/18.04/prod.list && mv prod.list /etc/apt/sources.list.d/microsoft-prod.list && chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg  && chown root:root /etc/apt/sources.list.d/microsoft-prod.list \
    && apt-get install -y apt-transport-https && apt-get update \
    && apt-get install aspnetcore-runtime-2.2 \
    && mkdir -p "/etc/dns" \
    && wget -q "https://packages.microsoft.com/config/ubuntu/$(lsb_release -r -s)/packages-microsoft-prod.deb" -O "/etc/dns/packages-microsoft-prod.deb" \
    && dpkg -i "/etc/dns/packages-microsoft-prod.deb"  \
    && sleep 2 \
    && echo "Downloading Technitium DNS Server..." \
    && wget -q https://download.technitium.com/dns/DnsServerPortable.tar.gz -O /etc/dns/DnsServerPortable.tar.gz \
    && tar -zxf /etc/dns/DnsServerPortable.tar.gz -C "/etc/dns" \

CMD ["cat","/etc/dns/install.log"]
WORKDIR /etc/dns/
CMD ["./start.sh"]
CMD ["sleep","9999"]
#EXPOSE 853



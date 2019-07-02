FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

RUN set -x 
RUN apt update 
RUN apt -y upgrade  
RUN apt -y install openssl wget lsb-release libunwind8 icu-devtools apt-transport-https gpg
RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.asc.gpg && mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/ && wget -q https://packages.microsoft.com/config/ubuntu/18.04/prod.list && mv prod.list /etc/apt/sources.list.d/microsoft-prod.list && chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg  && chown root:root /etc/apt/sources.list.d/microsoft-prod.list  
RUN apt-get install -y apt-transport-https && apt-get update  
RUN apt-get install aspnetcore-runtime-2.2  
RUN mkdir -p "/etc/dns"  
RUN wget -q "https://packages.microsoft.com/config/ubuntu/$(lsb_release -r -s)/packages-microsoft-prod.deb" -O "/etc/dns/packages-microsoft-prod.deb"  
RUN dpkg -i "/etc/dns/packages-microsoft-prod.deb"   
RUN sleep 2  
RUN echo "Downloading Technitium DNS Server..."  
RUN wget -q https://download.technitium.com/dns/DnsServerPortable.tar.gz -O /etc/dns/DnsServerPortable.tar.gz  
RUN tar -zxf /etc/dns/DnsServerPortable.tar.gz -C "/etc/dns"  

CMD ["cat","/etc/dns/install.log"]
WORKDIR /etc/dns/
CMD ["./start.sh"]
CMD ["sleep","9999"]
#EXPOSE 853



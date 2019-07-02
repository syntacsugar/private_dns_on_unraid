FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

RUN set -x 
RUN apt update 
RUN apt -y upgrade  
RUN apt -y install openssl wget lsb-release libunwind8 icu-devtools apt-transport-https gpg
RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.asc.gpg && mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/ && wget -q https://packages.microsoft.com/config/ubuntu/18.04/prod.list && mv prod.list /etc/apt/sources.list.d/microsoft-prod.list && chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg  && chown root:root /etc/apt/sources.list.d/microsoft-prod.list  
RUN apt-get install -y apt-transport-https && apt-get update  
RUN apt-get install -y aspnetcore-runtime-2.2  
RUN mkdir -p "/etc/dns"  
RUN sleep 2   
COPY allfiles.tgz /etc/dns/allfiles.tgz
RUN tar -xvzf /etc/dns/allfiles.tgz -C "/etc/dns"  
RUN dpkg -i "/etc/dns/packages-microsoft-prod.deb" 
WORKDIR /etc/dns/
CMD ["./start.sh"]
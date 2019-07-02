    && mkdir -p "/etc/dns" \
    && wget -q "https://packages.microsoft.com/config/ubuntu/$(lsb_release -r -s)/packages-microsoft-prod.deb" -O "$dnsDir/packages-microsoft-prod.deb" \
    && dpkg -i "$dnsDir/packages-microsoft-prod.deb"  \
    && sleep 2 \
    && echo "Downloading Technitium DNS Server..." \
    && wget -q https://download.technitium.com/dns/DnsServerPortable.tar.gz -O /etc/dns/DnsServerPortable.tar.gz \
    && tar -zxf /etc/dns/DnsServerPortable.tar.gz -C "/etc/dns" \
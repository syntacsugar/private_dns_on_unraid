#!/bin/sh

dnsDir="/etc/dns"
dnsTar="/etc/dns/DnsServerPortable.tar.gz"
dnsUrl="https://download.technitium.com/dns/DnsServerPortable.tar.gz"

mkdir -p $dnsDir
installLog="$dnsDir/install.log"
echo "" > $installLog

echo ""
echo "==============================="
echo "Technitium DNS Server Installer"
echo "==============================="
echo ""

if [ -f "/usr/bin/dotnet" ]
then
	echo ".NET Core Runtime was found installed."
else
	echo "Installing .NET Core Runtime..."

	if wget -q "https://packages.microsoft.com/config/ubuntu/$(lsb_release -r -s)/packages-microsoft-prod.deb" -O "$dnsDir/packages-microsoft-prod.deb"
	then
		dpkg -i "$dnsDir/packages-microsoft-prod.deb">> $installLog 2>&1

		add-apt-repository universe >> $installLog 2>&1

		until apt-get -y update >> $installLog 2>&1 && apt-get -y install libunwind8 icu-devtools apt-transport-https aspnetcore-runtime-2.2 >> $installLog 2>&1
		do
			echo "Trying again.."
			sleep 2
		done

		echo ".NET Core Runtime was installed succesfully."
	else
		echo ""
		echo "Failed to install .NET Core Runtime. Please try again."
		exit 1
	fi
fi

echo ""
echo "Downloading Technitium DNS Server..."

if wget -q "$dnsUrl" -O $dnsTar
then
	if [ -f "/etc/dns/DnsServerApp.dll" ]
	then
		echo "Updating Technitium DNS Server..."
	else
		echo "Installing Technitium DNS Server..."
	fi
	
	tar -zxf $dnsTar -C $dnsDir >> $installLog 2>&1
	
	echo ""
	echo "Technitium DNS Server was installed succesfully!"
	echo "Open http://$(hostname):5380/ to access the web console."
else
	echo ""
	echo "Failed to download Technitium DNS Server from: $dnsUrl"
	exit 1
fi
cd /etc/dns/
sudo ./start.sh

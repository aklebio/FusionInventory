#!/bin/bash
# -------------------------------------------------------------------------
# @Programa 
# 	@name: fusioninstall.sh
#	@versao: 1.0.0
#	@Data 09 de Setembro de 2019
#	@Copyright: Aklebio Ramos - MIBH, 2019
# --------------------------------------------------------------------------
# LICENSE
#
# integraGZ.sh is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# integraGZ.sh is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# If not, see <http://www.gnu.org/licenses/>.
# --------------------------------------------------------------------------
 
#
# Variables Declaration
#

versionDate="Set 09, 2019"
TITULO="M.I - Montreal Informática FusionInstall - v.1.0.0"
BANNER="http://www.montreal.com".br

FUSION_DEB_LINK="http://debian.fusioninventory.org/downloads/fusioninventory-agent_2.5-3_all.deb"


clear

cd /tmp

echo -e "
 _____          _             ___                      _
|  ___|   _ ___(_) ___  _ __ |_ _|_ ____   _____ _ __ | |_ ___  _ __ _   _
| |_ | | | / __| |/ _ \| '_ \ | || '_ \ \ / / _ \ '_ \| __/ _ \| '__| | | |
|  _|| |_| \__ \ | (_) | | | || || | | \ V /  __/ | | | || (_) | |  | |_| |
|_|   \__,_|___/_|\___/|_| |_|___|_| |_|\_/ \___|_| |_|\__\___/|_|   \__, |
                                                                     |___/
                                                  M.I. Montreal Informática
                                                              Aklebio Ramos
                                                                Ramal: 7664
 \n"

sleep 5

cd /tmp/

#
# install fusioninventory-agent
#


#
# Functions
#

# Function setAgentConfig

function setAgentConfig(){
	
	erroDescription="Error to set GLPi Server!"
	GLPI_SERVER=$(whiptail --title "${TITULO}" --backtitle "${BANNER}" --inputbox "Enter the GLPi Server address: eg: https://glpi.mi." --fb 10 60 3>&1 1>&2 2>&3); [ $? -ne 0 ] && erroDetect

	erroDescription="Error to set fusion TAG!"
	FUSION_TAG=$(whiptail --title "${TITULO}" --backtitle "${BANNER}" --inputbox "Enter the fusion TAG to use." --fb 10 60 3>&1 1>&2 2>&3); [ $? -ne 0 ] && erroDetect

	erroDescription="Error to set HTTP TRUSTED HOST!"
	TRUST=$(whiptail --title "${TITULO}" --backtitle "${BANNER}" --inputbox "Enter the http_trust host or network in CIDR format. eg: 127.0.0.1/32 10.2.10.0/24." --fb 10 60 3>&1 1>&2 2>&3); [ $? -ne 0 ] && erroDetect

	erroDescription="Error to create Agent Configuration!"
	echo -e "server = '$GLPI_SERVER/plugins/fusioninventory/'\nlocal = /tmp\ntasks = inventory\ndelaytime = 30\nlazy = 1\nscan-homedirs = 0\nscan-profiles = 0\nhtml = 0\nbackend-collect-timeout = 30\nforce = 0\nadditional-content =\nno-p2p = 0\nno-ssl-check = 0\ntimeout = 180\nno-httpd = 0\nhttpd-port = 62354\nhttpd-trust = $TRUST\nforce = 1\nlogger = syslog\nlogfacility = LOG_DAEMON\ncolor = 0\ntag = $FUSION_TAG\ndebug = 0\n" > /etc/fusioninventory/agent.cfg; [ $? -ne 0 ] && erroDetect

}


# Function erroDetect

function erroDetect(){
	clear
	echo -e "
\033[31m
 ----------------------------------------------------------- 
#                    ERRO DETECTED!!!                       #
 -----------------------------------------------------------\033[0m
  There was an error.
  An error was encountered in the installer and the process 
  was aborted.
  - - -
  \033[1m Error Description:\033[0m
 
  *\033[31m $erroDescription \033[0m
  - - -
  
  \033[1mFor commercial support contact us:\033[0m 
  
  Ramal 7664
  $comercialMail
  $devMail 
  
 ----------------------------------------------------------
  \033[32mM.I - Montreal Informática - http://www.monrteal.com.br\033[0m 
 ----------------------------------------------------------"

		kill $$
	
}

# Function INSTALL
INSTALL ()
{
	clear

	# Test if the systen has which package
	erroDescription="The whiptail package is required to run the integraGZ.sh"
	which whiptail; [ $? -ne 0 ] && erroDetect

	# Test if the user is root
	erroDescription="System administrator privilege is required"
	[ $UID -ne 0 ] && erroDetect

	# Discovery the system version and instanciate variables
	erroDescription="Operating system not supported."
	cat /etc/*-release ; [ $? -ne 0 ] && erroDetect
		
	case $ID in

		debian)
	
			case $VERSION_ID in
		
				9 | 8)
		
					clear
					echo "System GNU/Linux $PRETTY_NAME detect..."
					sleep 2
					echo "Starting fusioninstall.sh by M.I - Aklebio Ramos"
					echo "-----------------"; sleep 1;

					# Download and install fusioninventory-agent
					erroDescription="Erro to get fusioninventory-agent"

					wget -O fusioninventory-agent.deb $FUSION_DEB_LINK; [ $? -ne 0 ] && erroDetect

					dpkg -i fusioninventory-agent.deb
				
					erroDescription="Error to resolve dependencies"
					apt-get -f install -y; [ $? -ne 0 ] && erroDetect
	
				
				;;

			*)
				erroDescription="Operating system not supported."
				erroDetect				
			;;
		
			esac

		;;
		
		centos)
	
			case $VERSION_ID in
		
				6)

					clear
					echo "System GNU/Linux $PRETTY_NAME detect..."
					sleep 2
					echo "Starting fusioninstall.sh by M.I - Aklebio Ramos"
					echo "-----------------"; sleep 1

					# Add perl repository to resolv dependencies
					erroDescription="Erro to  add EPEL repository!"
					yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm; [ $? -ne 0 ] && erroDetect

					# Add fusioninventory repository
					erroDescription="Erro to create fusioninventory repository!"
					echo -e "[trasher-fusioninventory-agent]
name=Copr repo for fusioninventory-agent owned by trasher
baseurl=https://copr-be.cloud.fedoraproject.org/results/trasher/fusioninventory-agent/epel-7-\$basearch/
type=rpm-md
skip_if_unavailable=True
gpgcheck=1
gpgkey=https://copr-be.cloud.fedoraproject.org/results/trasher/fusioninventory-agent/pubkey.gpg
repo_gpgcheck=0
enabled=1
enabled_metadata=1
" > /etc/yum.repos.d/copr.fusion.repo; [ $? -ne 0 ] && erroDetect

					# Install fusioninventory-agent
					yum install -y fusioninventory-agent
				
				;;

				*)
					erroDescription="Operating system not supported."
					erroDetect				
				;;
		
			esac

		;;
	
		ubuntu)

			case $VERSION_ID in

				"16.04" | "16.10" | "17.04" | "17.10" | "18.04" | "18.10")
		
					clear
					echo "System GNU/Linux $PRETTY_NAME detect..."
					sleep 2
					echo "Starting fusioninstall.sh by M.I - Montreal Informática"
					echo "-----------------"; sleep 1;

					# Download and install fusioninventory-agent
					erroDescription="Erro to get fusioninventory-agent"

					wget -O fusioninventory-agent.deb $FUSION_DEB_LINK; [ $? -ne 0 ] && erroDetect

					dpkg -i fusioninventory-agent.deb
				
					erroDescription="Error to resolve dependencies"
					apt-get -f install -y; [ $? -ne 0 ] && erroDetect
				
				;;

				*)
					erroDescription="Operating system not supported."
					erroDetect
	
				;;
			esac

	esac

	clear
	echo "Configuring fusioninventory-agent..."
	sleep 2

	setAgentConfig

	clear
	echo "enable fusioninventory-agent to start with system"
	sleep 1

	erroDescription="Error to enable fusioninventory-agent with SystemCTL"

	sleep 1
	# enable stato with system
	systemctl enable fusioninventory-agent; [ $? -ne 0 ] && erroDetect

	sleep 1
	erroDescription="Error to start fusioninventory-agent"
	# Iniciando o serviço fusioninventory
	systemctl start fusioninventory-agent; [ $? -ne 0 ] && erroDetect

	fusioninventory-agent --force; [ $? -ne 0 ] && erroDetect

}

INSTALL

clear

echo -e "
\033[32m
 ----------------------------------------------------------- 
#                    Congratulations!                       #
 -----------------------------------------------------------\033[0m
|                                                           |
|\033[34m Apparently, everything went well.\033[0m                         |
|\033[34m Know our services and products for you and your company.\033[0m  |
|\033[34m Conheca nossos servicos e produtos.\033[0m                       |
 -----------------------------------------------------------
|\033[32m https://www.montreal.com.br\033[0m                               |
|\033[32m Aklebio Ramos\033[0m                                             |
 -----------------------------------------------------------
"






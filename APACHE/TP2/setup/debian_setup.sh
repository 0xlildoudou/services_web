#!/bin/bash

# Color
GREEN='\033[0;32m'
RED='\033[0;31m'
ORANGE='\033[0;33m'
NC='\033[0m' # No Color

function docker_install()
{   
    apt update -y
    if [ $? == 1 ]
    then
        echo -e "${RED}Erreur lors de l'update du systeme${NC}"
        exit 0
    else
        echo -e "Update [ ${GREEN}OK${NC} ]"
    fi

    apt install docker.io
    if [ $? == 1 ]
    then
        echo -e "${RED}Erreur lors de l'installation de Docker${NC}"
        exit 0
    else
        echo -e "Install Docker [ ${GREEN}OK${NC} ]"
    fi
}

function tp2_environement_make()
 {
    #Site web file 
    mkdir -p ~/docker_partage/site/{site-www,site-blog,site-other}
    chmod 775 -R ~/docker_partage/
    # TO DO git clone the web site in TP1
    echo -e "Site web en www dans Docker OK" > ~/docker_partage/site/site-www/index.html
    echo -e "Site web en blog dans Docker OK" > ~/docker_partage/site/site-blog/index.html
    echo -e "Site web other dans Docker OK" > ~/docker_partage/site/site-other/index.html
    #Nginx configuration file
    mkdir -p ~/docker_partage/config/
    cp ./base_default.conf ~/docker_partage/config/
    echo "Quel est le nom du site en www ?"
    read sitewww
    echo "Quel est le nom du site en blog ?"
    read siteblog
    echo "Quel est le nom du site en ip ?"
    read siteother
    sed -e "s/site01/$sitewww" -e "s/site02/$siteblog" -e "s/ip1/$siteother" base_default.conf >> default.conf
}

function start_web_site()
{
    docker run -it --rm -d -p 80:80 --name web -v /root/docker_partage/site:/usr/share/nginx/html -v /root/docker_partage/config:/etc/nginx/conf.d nginx 
}


### Start Script
echo "Configuration de l'hote"
echo "Interface de l'hote :"
read interface
echo "IP de l'hote :"
read address
echo "Masque de l'hote :"
read netmask
echo "Gateway de l'hote :"
read gateway
mv /etc/network/interfaces /etc/network/interfaces.old
sed 's/^/#/' /etc/network/interfaces.old >> /etc/network/interfaces
echo -e "
auto $interface
iface $interface inet static
    address $address
    netmask $netmask
    gateway $gateway
" >> /etc/network/interfaces
echo "Serveur DNS :"
read dns_server
mv /etc/resolv.conf /etc/resolv.conf.old
echo -e "nameserver $dns_server"


echo "Installation de Docker"
echo "Voulez vous lancer l'installation de Docker sur ce systeme ? [y;n]"
read validation
case $validation in 
    [Yy]*) docker_install 
            echo -e "${GREEN}Docker is installed${NC}";;
    [Nn]*) echo -e " ${ORANGE}Installation cancelled ${NC}"
            exit 1;;
    *) echo -e "${RED}Syntax error${NC}" 
            exit 0 ;;
esac

echo "Voulez vous créer un environement conforme a l'Atelier 2 ? [y;n]"
read validation
case $validation in 
    [Yy]*) tp2_environement_make 
            echo -e "${GREEN}TP2 environement is installed${NC}";;
    [Nn]*) echo -e " ${ORANGE}Installation cancelled ${NC}"
            exit 1;;
    *) echo -e "${RED}Syntax error${NC}"
            exit 0 ;;
esac

echo "Voulez vous lancer le site ? [y;n]"
read validation
case $validation in 
    [Yy]*) start_web_site
            echo -e "${GREEN}Site web is running${NC}";;
    [Nn]*) echo -e " ${ORANGE}Installation cancelled ${NC}"
            exit 1;;
    *) echo -e "${RED}Syntax error${NC}"
            exit 0 ;;
esac
#!/bin/bash
# SSL Cerfificate generator

# Color
GREEN='\033[0;32m'
RED='\033[0;31m'
ORANGE='\033[0;33m'
NC='\033[0m' # No Color

function ssl_install ()
 {
    apt update -y
    apt install openssl -y
    if [ $? == 1 ]
    then 
        echo -e "${RED}Install error${NC}"
        exit $?
    else
        echo -e "Install Openssl [ ${GREEN}OK${NC} ]"
    fi
}

function certificate_gen ()
{
    # Key gen
    if [ -d "/etc/ssl" ]
    then
        openssl genrsa -des3 -out /etc/ssl/"$website.key" 2048
        if [ $? == 1 ]
        then echo -e "${RED}SSL key gen error${NC}"
                exit $?
        else
            echo -e "SSL key gen [ ${GREEN}OK${NC} ]"
        fi
    else
       echo "${RED}Error${NC} : /etc/ssl not found (openssl is not properly installed)"
       exit $?
    fi

    #CSR gen
    if [ -f "/etc/ssl/$website.key" ]
    then
        openssl req -new -key /etc/ssl/"$website.key" -out /etc/ssl/"$website.csr"
        if [ $? == 1 ]
        then echo -e "${RED}CSR gen error${NC}"
                exit $?
        else
            echo -e "CSR gen [ ${GREEN}OK${NC} ]"
        fi
    else
        echo "${RED}Error${NC} : $website.key not found in /etc/ssl"
        exit $?
    fi
}

function unprotect_key ()
{
    openssl req -noout -text -in /etc/ssl/"$website.csr"
    if [ $? == 1 ]
    then
        echo -e "${RED}CSR unprotect error${NC}"
            exit $?
    else
        echo -e "CSR unprotect [ ${GREEN}OK${NC} ]"
    fi

    openssl rsa -in /etc/ssl/"$website.key" -out /etc/ssl/"$website.deprotected.key"
    if [ $? == 1 ]
    then
        echo -e "${RED}Key unprotect error${NC}"
            exit $?
    else
        echo -e "Key unprotect [ ${GREEN}OK${NC} ]"
    fi
}

function x509_crt ()
{
    openssl x509 -req -days 365 -in /etc/ssl/"$website.csr" -signkey /etc/ssl/"$website.deprotected.key" -out /etc/ssl/"$website.crt"
    if [ $? == 1 ]
    then
        echo -e "${RED}x509 crt error${NC}"
            exit $?
    else
        echo -e "x509 crt [ ${GREEN}OK${NC} ]"
    fi
}

echo "Do you want install SSL certificate for website ? [y:n]"
read validation
case $validation in 
    [Yy]*) ssl_install
            echo -e "Name of your website ? :\n"
            read website
            certificate_gen
            echo -e "${GREEN}SSL Certificate is created${NC}";;
    [Nn]*) echo -e " ${ORANGE}Installation cancelled by the user${NC}"
            exit 1;;
    *) echo -e "${RED}Syntax error${NC}" 
            exit 0 ;;
esac

echo "Do you want unprotect the key to allow nginx to restart itself ? [y:n]"
read validation
case $validation in
    [Yy]*) unprotect_key
        echo -e "${GREEN}SSL Certificate is unprotected${NC}";;
    [Nn]*) echo -e "${ORANGE}the key has not been unprotected${NC}";;
    *) echo -e "${RED}Syntax error${NC}" 
        exit 0;;
esac

echo -e "Create x509 certificate"
x509_crt
echo -e "${GREEN}x509 Certificate is created${NC}"
#!/bin/bash

echo 
echo -e " \n THE IP OF$(tput setaf 3) $HOSTNAME $(tput sgr 0)is : $(tput setaf 3)$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/') $(tput sgr 0)\n" > /tmp/ip.txt
cat /tmp/ip.txt 
echo

# geting info about OS
OS=$(cat /etc/*release* | grep -w "ID" | sed 's/\"/''/g' | awk '{print substr($0, 4, 8)}' | tr '[:lower:]' '[:upper:]')
echo
echo "Will install packages for ${OS}"
echo

function centos() {
        #base packages
        PKGS=(wget curl git unzip epel-release yum-utils java-11-openjdk-devel ansible)
        # programs to be installed need base packages
        APPS=(docker-ce docker-ce-cli containerd.io packer jenkins)
        
        clear

        current_user=$(whoami)
        # add dns server
        nmcli con modify System\ eth0 ipv4.dns "192.168.102.1" && systemctl restart NetworkManager

        #  amazon-linux-extras install epel -y

        for value in "${PKGS[@]}"
        do
            echo $value
              yum install -y -q -e 0 $value
        done;
}

function ubuntu() {

        #base packages
        PKGS=(wget curl git unzip ca-certificates gnupg lsb-release apt-transport-https ansible)
        
        # programs to be installed need base packages
        APPS=(docker-ce docker-ce-cli containerd.io kubectl openjdk-11-jdk awscli packer jenkins)

        current_user=$(whoami)

        #  amazon-linux-extras install epel -y

        echo "Installing required packages:\"n"

        for value in "${PKGS[@]}"
        do
            echo "Installing:$(tput setaf 3) ${value}$(tput sgr 0)\"n"
              apt -q install -y $value
        done;

          #sets timezone for EST  
          timedatectl set-timezone America/New_York
          apt update && apt upgrade -y
}          

case $OS in
    "") echo "OS not detected" ;;
    "CENTOS") centos 
            ;;
    "UBUNTU") ubuntu 
            ;;
    *) echo "Unrecognized OS!"
esac  

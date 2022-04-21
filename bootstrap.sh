#!/bin/bash

clear
echo 
echo -e " \n THE IP OF$(tput setaf 3) $HOSTNAME $(tput sgr 0)is : $(tput setaf 3)$(ip a | grep -i 'STATE UP' -A2  | grep inet |awk '{print $2}' | cut -f1  -d'/') $(tput sgr 0)\n" > /tmp/ip.txt
#echo -e " \n THE IP OF$(tput setaf 3) $HOSTNAME $(tput sgr 0)is : $(tput setaf 3)$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/') $(tput sgr 0)\n" > /tmp/ip.txt
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

        apt update -qy && apt dist-upgrade -yq
        
        #base packages
        PKGS=(wget curl git unzip ca-certificates gnupg lsb-release apt-transport-https ansible)
        
        # programs to be installed need base packages
        APPS=( packer )   #(docker-ce docker-ce-cli containerd.io kubectl openjdk-11-jdk awscli packer jenkins)

        current_user=$(whoami)
        shell_cli=$(ps -p $$ | awk {'print $4'} | tail -n 1)
        echo "Current user: ${current_user}"
        echo "Shell: ${shell_cli}"
        #  amazon-linux-extras install epel -y
        
        echo    "##########################################################"
        echo -e "$(tput setaf 3)Installing packages:$(tput sgr 0)"
        echo    "##########################################################"
        
        sleep 3

        for value in "${PKGS[@]}"
        do
            echo "Installing:$(tput setaf 3) ${value}$(tput sgr 0)\"n"
              apt -q install -y $value
        done;

          #sets timezone for EST
          echo "Please wait..."
          timedatectl set-timezone America/New_York
          #apt update -qy && apt dist-upgrade -yq && apt autoremove -yq

	# Other installs:
	#Helm
	curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
	chmod 700 get_helm.sh
	./get_helm.sh
	rm -rf get_helm.sh
        echo "$(tput setaf 3)helm version:"
        helm version
	tput sgr 0

	#Kubectl
	curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
	chmod +x kubectl
        mv ./kubectl /usr/local/bin/kubectl
        echo "$(tput setaf 3)kubectl version:"
        kubectl version --client
        tput sgr 0

        # Awscli
        curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
        if [ -d "/usr/local/aws-cli" ]; then
                rm -rf /usr/local/aws-cli
                rm /usr/local/bin/aws
                rm /usr/local/bin/aws_completer
        fi        
        unzip -qq awscliv2.zip 
        ./aws/install  --update
        rm -rf awscliv2.zip
        rm -rf aws/
        echo "$(tput setaf 3)awscli version:"
        aws --version
        tput sgr 0
}          

case $OS in
    "") echo "OS not detected" ;;
    "CENTOS") centos 
            ;;
    "UBUNTU") ubuntu 
            ;;
    "DEBIAN") ubuntu
            ;;
    *) echo "Unrecognized OS!"
esac  

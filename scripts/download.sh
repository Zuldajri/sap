#!/bin/bash

echo $(date) " - ############## Starting Script ####################"

set -e

export ADMIN_USER=$1
export STORAGE_ACCOUNT_NAME=$2
export STORAGE_ACCOUNT_KEY=$3
export SAP_USER=$4
export SAP_PASSWORD=$5

curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

sudo apt update
sudo apt-get install git
sudo apt -y install jq=1.5+dfsg-2
sudo apt -y install python3-pip
sudo -H pip3 install "ansible>=2.8,<2.9"
sudo -H pip3 install "pywinrm>=0.3.0"
sudo -H pip3 install "yamllint==1.25.0"
sudo -H pip3 install "ansible-lint==4.3.7"
sudo -H pip3 install beautifulsoup4
sudo apt install cifs-utils


sudo mkdir /sapmnt1
if [ ! -d "/etc/smbcredentials" ]; then
sudo mkdir /etc/smbcredentials
fi
touch /etc/smbcredentials/$STORAGE_ACCOUNT_NAME.cred
echo "username=$STORAGE_ACCOUNT_NAME" >> /etc/smbcredentials/$STORAGE_ACCOUNT_NAME.cred
echo "password=$STORAGE_ACCOUNT_KEY" >> /etc/smbcredentials/$STORAGE_ACCOUNT_NAME.cred

sudo chmod 600 /etc/smbcredentials/$STORAGE_ACCOUNT_NAME.cred

sudo bash -c 'echo "//$STORAGE_ACCOUNT_NAME.file.core.windows.net/sapbits /sapmnt1 cifs nofail,vers=3.0,credentials=/etc/smbcredentials/$STORAGE_ACCOUNT_NAME.cred,dir_mode=0777,file_mode=0777,serverino" >> /etc/fstab'
sudo mount -t cifs //$STORAGE_ACCOUNT_NAME.file.core.windows.net/sapbits /sapmnt1 -o vers=3.0,credentials=/etc/smbcredentials/$STORAGE_ACCOUNT_NAME.cred,dir_mode=0777,file_mode=0777,serverino



sudo git clone https://github.com/Zuldajri/sappython.git

cat > /home/$ADMIN_USER/output.json <<EOF
{"software":{"downloader":{"credentials":{"sap_password":"$SAP_PASSWORD","sap_user":"$SAP_USER"},"debug":{"cert":"charles.pem","enabled":false,"proxies":{"http":"http://127.0.0.1:8888","https":"https://127.0.0.1:8888"}},"scenarios":[{"scenario_type":"APP","product_name":"S4","product_version":"$S4_VERSION","os_type":"LINUX_X64","os_version":"SLES12.3"},{"components":["PLATFORM","DATABASE","CLIENT","STUDIO","COCKPIT"],"os_type":"LINUX_X64","os_version":"SLES12.3","product_name":"HANA","product_version":"2.0","scenario_type":"DB"},{"os_type":"LINUX_X64","product_name":"RTI","scenario_type":"RTI"},{"os_type":"NT_X64","scenario_type":"BASTION"},{"os_type":"LINUX_X64","scenario_type":"BASTION"}]},"storage_account_sapbits":{"blob_container_name":"sapbits","file_share_name":"sapbits","name":"$STORAGE_ACCOUNT_NAME","storage_access_key":"$STORAGE_ACCESS_KEY"}}}
EOF

cat > /home/$ADMIN_USER/commands.txt <<EOF
python3 /var/lib/waagent/custom-script/download/0/sappython/downloader/basket.py --config /home/$ADMIN_USER/output.json --dir /sapmnt1
python3 /var/lib/waagent/custom-script/download/0/sappython/downloader/basket1.py --config /home/$ADMIN_USER/output.json --dir /sapmnt1
python3 /var/lib/waagent/custom-script/download/0/sappython/downloader/basket2.py --config /home/$ADMIN_USER/output.json --dir /sapmnt1
python3 /var/lib/waagent/custom-script/download/0/sappython/downloader/basket3.py --config /home/$ADMIN_USER/output.json --dir /sapmnt1
EOF





#!/bin/bash

echo $(date) " - ############## Starting Script ####################"

set -e

export MASTER_PASSWORD=$1
export S4SID=$2
export SCS_VM_NAME=$3


cp -R /sapmnt1/Archives/. /usr/sap/install/

rm -f /usr/sap/install/IMDB_SERVER20_055_0-80002031.SAR
rm -f /usr/sap/install/IMC_STUDIO2_255_0-80000321.SAR
rm -f /usr/sap/install/IMC_STUDIO2_255_0-80000323.SAR
rm -f /usr/sap/install/IMDB_LCAPPS_2055_0-20010426.SAR

chmod +x /usr/sap/install/SAPCAR_1010-70006178.EXE
mkdir -p /usr/sap/install/SWPM

/usr/sap/install/SAPCAR_1010-70006178.EXE -xf /usr/sap/install/SWPM20SP08_6-80003424.SAR -R /usr/sap/install/SWPM/

groupadd -g 2001 sapinst
usermod -a -G sapinst root
usermod -a -G sapsys root 

cd /usr/sap/install/

wget https://raw.githubusercontent.com/Zuldajri/sap/main/scripts/scs.2020.inifile.params -O /usr/sap/install/scs.2020.inifile.params


chown root:sapinst /usr/sap/install/scs.2020.inifile.params
chmod g+r /usr/sap/install/scs.2020.inifile.params

lowS4SID=${S4SID,,}
lowS4SID="${lowS4SID}adm"

chgrp -R sapsys /usr/sap/$S4SID/
chown -R $lowS4SID /usr/sap/$S4SID/
chgrp -R sapsys /sapmnt/$S4SID/
chown -R $lowS4SID /sapmnt/$S4SID/


INTERNAL_DNS=$(cat /etc/resolv.conf | grep search | awk '{print $2}')

sudo sed -i "s/MASTER_PASSWORD/$MASTER_PASSWORD/g" /usr/sap/install/scs.2020.inifile.params
sudo sed -i "s/S4SID/$S4SID/g" /usr/sap/install/scs.2020.inifile.params
sudo sed -i "s/SCS_VM_NAME/$SCS_VM_NAME/g" /usr/sap/install/scs.2020.inifile.params
sudo sed -i "s/INTERNAL_DNS/$INTERNAL_DNS/g" /usr/sap/install/scs.2020.inifile.params

cd /usr/sap/install/SWPM/

/usr/sap/install/SWPM/sapinst SAPINST_USE_HOSTNAME=$SCS_VM_NAME SAPINST_INPUT_PARAMETERS_URL=/usr/sap/install/scs.2020.inifile.params SAPINST_EXECUTE_PRODUCT_ID=NW_ABAP_ASCS:S4HANA2020.CORE.HDB.ABAPHA SAPINST_START_GUI=false SAPINST_START_GUISERVER=false

systemctl start nfsserver
systemctl enable nfsserver
systemctl status nfsserver

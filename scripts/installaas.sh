#!/bin/bash

echo $(date) " - ############## Starting Script ####################"

set -e

export MASTER_PASSWORD=$1
export S4SID=$2
export SCS_STATIC_IP=$3
export LINUX_APP_VM_NAME=$5
export LINUX_APP_2_VM_NAME=$5



mkdir -p /usr/sap/{downloads,$S4SID/SYS,install} /tmp/app_template /sapmnt/$S4SID/{global,profile}

mount $SCS_STATIC_IP:/usr/sap/install /usr/sap/install
mount $SCS_STATIC_IP:/usr/sap/$S4SID/SYS /usr/sap/$S4SID/SYS
mount $SCS_STATIC_IP:/tmp/app_template /tmp/app_template
mount $SCS_STATIC_IP:/sapmnt/$S4SID/global /sapmnt/$S4SID/global
mount $SCS_STATIC_IP:/sapmnt/$S4SID/profile /sapmnt/$S4SID/profile

groupadd -g 2001 sapinst
groupadd -g 2000 sapsys



cd /usr/sap/install/

wget https://raw.githubusercontent.com/Zuldajri/sap/main/scripts/aas.2020.inifile.params -O /usr/sap/install/aas.2020.inifile.params

chown root:sapinst aas.2020.inifile.params
chmod g+r aas.2020.inifile.params


sudo sed -i "s/MASTER_PASSWORD/$MASTER_PASSWORD/g" /usr/sap/install/aas.2020.inifile.params
sudo sed -i "s/S4SID/$S4SID/g" /usr/sap/install/aas.2020.inifile.params
sudo sed -i "s/LINUX_APP_VM_NAME/$LINUX_APP_VM_NAME/g" /usr/sap/install/aas.2020.inifile.params

cd /root/

/usr/sap/install/SWPM/sapinst SAPINST_USE_HOSTNAME=$LINUX_APP_2_VM_NAME SAPINST_EXECUTE_PRODUCT_ID=NW_ABAP_CI:S4HANA2020.CORE.HDB.ABAP SAPINST_INPUT_PARAMETERS_URL=/usr/sap/install/aas.2020.inifile.params SAPINST_START_GUI=false SAPINST_START_GUISERVER=false

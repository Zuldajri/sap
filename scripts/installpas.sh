#!/bin/bash

echo $(date) " - ############## Starting Script ####################"

set -e

export MASTER_PASSWORD=$1
export S4SID=$2
export LINUX_APP_VM_NAME=$3

cd /usr/sap/install/

wget https://raw.githubusercontent.com/Zuldajri/sap/main/scripts/pas.2020.inifile.params -O /usr/sap/install/pas.2020.inifile.params

chown root:sapinst pas.2020.inifile.params
chmod g+r pas.2020.inifile.params


sudo sed -i "s/MASTER_PASSWORD/$MASTER_PASSWORD/g" /usr/sap/install/pas.2020.inifile.params
sudo sed -i "s/S4SID/$S4SID/g" /usr/sap/install/pas.2020.inifile.params
sudo sed -i "s/LINUX_APP_VM_NAME/$LINUX_APP_VM_NAME/g" /usr/sap/install/pas.2020.inifile.params

cd /root/

/usr/sap/install/SWPM/sapinst SAPINST_USE_HOSTNAME=$LINUX_APP_VM_NAME SAPINST_EXECUTE_PRODUCT_ID=NW_ABAP_CI:S4HANA2020.CORE.HDB.ABAP SAPINST_INPUT_PARAMETERS_URL=/usr/sap/install/pas.2020.inifile.params SAPINST_START_GUI=false SAPINST_START_GUISERVER=false

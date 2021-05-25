#!/bin/bash

echo $(date) " - ############## Starting Script ####################"

set -e

export MASTER_PASSWORD=$1
export S4SID=$2
export HANASID=$3
export SCS_STATIC_IP=$4
export HANA_VM_NAME=$5

mkdir -p /usr/sap/{downloads,$S4SID/SYS,install} /tmp/app_template /sapmnt/$S4SID/{global,profile}

mount $SCS_STATIC_IP:/usr/sap/install /usr/sap/install
mount $SCS_STATIC_IP:/usr/sap/$S4SID/SYS /usr/sap/$S4SID/SYS
mount $SCS_STATIC_IP:/tmp/app_template /tmp/app_template
mount $SCS_STATIC_IP:/sapmnt/$S4SID/global /sapmnt/$S4SID/global
mount $SCS_STATIC_IP:/sapmnt/$S4SID/profile /sapmnt/$S4SID/profile

groupadd -g 2001 sapinst
groupadd -g 2000 sapsys

lowS4SID=${S4SID,,}
lowS4SID="${lowS4SID}adm"

lowHANASID=${HANASID,,}
lowHANASID="${lowHANASID}adm"


useradd ${lowS4SID} --uid 2000 --gid sapinst

cd /usr/sap/install/

usermod -a -G sapinst root
usermod -a -G sapsys root 
usermod -a -G sapinst,sapsys ${lowS4SID}

wget https://raw.githubusercontent.com/Zuldajri/sap/main/scripts/db.inifile.params -O /usr/sap/install/db.inifile.params

sudo sed -i "s/MASTER_PASSWORD/$MASTER_PASSWORD/g" /usr/sap/install/db.inifile.params
sudo sed -i "s/S4SID/$S4SID/g" /usr/sap/install/db.inifile.params
sudo sed -i "s/HANA_VM_NAME/$HANA_VM_NAME/g" /usr/sap/install/db.inifile.params
sudo sed -i "s/HANASID/$HANASID/g" /usr/sap/install/db.inifile.params
sudo sed -i "s/lowHANASID/$lowHANASID/g" /usr/sap/install/db.inifile.params

chown root:sapinst db.2020.inifile.params
chmod g+r db.2020.inifile.params

chgrp -R sapsys /usr/sap/$S4SID/
chown -R $lowHANASID /usr/sap/$S4SID/
chgrp -R sapsys /sapmnt/$S4SID/
chown -R $lowHANASID /sapmnt/$S4SID/


cd /root/

/usr/sap/install/SWPM/sapinst SAPINST_INPUT_PARAMETERS_URL=/usr/sap/install/db.inifile.params  SAPINST_EXECUTE_PRODUCT_ID=NW_ABAP_DB:S4HANA2020.CORE.HDB.ABAP SAPINST_SKIP_DIALOGS=true SAPINST_START_GUI=false SAPINST_START_GUISERVER=false

#!/bin/bash

echo $(date) " - ############## Starting Script ####################"

set -e

export ADMIN_USER=$1
export LINUX_JUMPBOX=$2


# extract client
/usr/sap/hdbclient/SAPCAR_1010-70006178.EXE -manifest /usr/sap/hdbclient/SAP_HANA_CLIENT/SIGNATURE.SMF -xf /usr/sap/hdbclient/IMDB_CLIENT20_007_26-80002082.SAR

# extract studio
/usr/sap/hdbclient/SAPCAR_1010-70006178.EXE -manifest /usr/sap/hdbclient/SAP_HANA_STUDIO/SIGNATURE.SMF -xf /usr/sap/hdbclient/IMC_STUDIO2_255_0-80000321.SAR


# Install Hana Client on Linux 
 /usr/sap/hdbclient/SAP_HANA_CLIENT/hdbinst -a client -b --hostname=$LINUX_JUMPBOX --path=/usr/sap/hdbclient/SAP_HANA_CLIENT


# Install HANA Studio on Linux
/usr/sap/hdbclient/SAP_HANA_STUDIO/hdbinst -a studio -b --path=/usr/sap/hdbclient/SAP_HANA_STUDIO

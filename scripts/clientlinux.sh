#!/bin/bash

echo $(date) " - ############## Starting Script ####################"

set -e

export ADMIN_USER=$1
export LINUX_JUMPBOX=$2
export INSTALLERHOMECLIENT=/usr/sap/hdbclient
export INSTALLERHOMESTUDIO=/usr/sap/hdbstudio

cd $INSTALLERHOMECLIENT

# extract client
$INSTALLERHOMECLIENT/SAPCAR_1010-70006178.EXE -manifest SAP_HANA_CLIENT/SIGNATURE.SMF -xf $INSTALLERHOMECLIENT/IMDB_CLIENT20_007_26-80002082.SAR

cd $INSTALLERHOMESTUDIO

# extract studio
$INSTALLERHOMESTUDIO/SAPCAR_1010-70006178.EXE -manifest SAP_HANA_STUDIO/SIGNATURE.SMF -xf $INSTALLERHOMESTUDIO/IMC_STUDIO2_255_0-80000321.SAR

cd $INSTALLERHOMECLIENT/SAP_HANA_CLIENT

# Install Hana Client on Linux 
$INSTALLERHOMECLIENT/SAP_HANA_CLIENT/hdbinst -a client -b --hostname=$LINUX_JUMPBOX --path=$INSTALLERHOMECLIENT/SAP_HANA_CLIENT

cd $INSTALLERHOMESTUDIO/SAP_HANA_STUDIO
mkdir STUDIO_PATH

# Install HANA Studio on Linux
$INSTALLERHOMESTUDIO/SAP_HANA_STUDIO/hdbinst -a studio -b --path=$INSTALLERHOMESTUDIO/SAP_HANA_STUDIO/STUDIO_PATH

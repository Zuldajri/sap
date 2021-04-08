#!/bin/bash

echo $(date) " - ############## Starting Script ####################"

set -e

export ADMIN_USER=$1
export SID=$2
export INSTALLERHOME=/hana/shared/$SID/install

cd $INSTALLERHOME

# extract hana
$INSTALLERHOME/SAPCAR_1010-70006178.EXE -manifest $INSTALLERHOME/SAP_HANA_DATABASE/SIGNATURE.SMF -xf $INSTALLERHOME/IMDB_SERVER20_055_0-80002031.SAR
 
# extract client
$INSTALLERHOME/SAPCAR_1010-70006178.EXE -manifest $INSTALLERHOME/SAP_HANA_CLIENT/SIGNATURE.SMF -xf $INSTALLERHOME/IMDB_CLIENT20_007_26-80002082.SAR

# extract studio
$INSTALLERHOME/SAPCAR_1010-70006178.EXE -manifest $INSTALLERHOME/SAP_HANA_STUDIO/SIGNATURE.SMF -xf $INSTALLERHOME/IMC_STUDIO2_255_0-80000321.SAR

# extract LCAPPS
$INSTALLERHOME/SAPCAR_1010-70006178.EXE -manifest $INSTALLERHOME/SAP_HANA_LCAPPS/SIGNATURE.SMF -xf $INSTALLERHOME/IMDB_LCAPPS_2055_0-20010426.SAR


# Install HANA Database using hdblcm
cat $INSTALLERHOME/hdbserver_${SID}_passwords.xml | $INSTALLERHOME/SAP_HANA_DATABASE/hdblcm --read_password_from_stdin=xml -b --configfile=$INSTALLERHOME/hdbserver_${SID}_install.cfg
  
# Delete install template file

sudo rm $INSTALLERHOME/hdbserver_${SID}_install.cfg


# Install HANA LCAPPS using hdbinst
$INSTALLERHOME/SAP_HANA_LCAPPS/hdbinst --sid=$SID

# Install HANA client using hdbinst
$INSTALLERHOME/SAP_HANA_CLIENT/hdbinst --sapmnt=$INSTALLERHOME/SAP_HANA_CLIENT
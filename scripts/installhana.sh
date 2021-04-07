#!/bin/bash

echo $(date) " - ############## Starting Script ####################"

set -e

export ADMIN_USER=$1
export SID=$2



# extract hana
/hana/shared/$SID/install/SAPCAR_1010-70006178.EXE -manifest /hana/shared/$SID/install/SAP_HANA_DATABASE/SIGNATURE.SMF -xf /hana/shared/$SID/install/IMDB_SERVER20_055_0-80002031.SAR
 
# extract client
/hana/shared/$SID/install/SAPCAR_1010-70006178.EXE -manifest /hana/shared/$SID/install/SAP_HANA_CLIENT/SIGNATURE.SMF -xf /hana/shared/$SID/install/IMDB_CLIENT20_007_26-80002082.SAR

# extract studio
/hana/shared/$SID/install/SAPCAR_1010-70006178.EXE -manifest /hana/shared/$SID/install/SAP_HANA_STUDIO/SIGNATURE.SMF -xf /hana/shared/$SID/install/IMC_STUDIO2_255_0-80000321.SAR

# extract LCAPPS
/hana/shared/$SID/install/SAPCAR_1010-70006178.EXE -manifest /hana/shared/$SID/install/SAP_HANA_LCAPPS/SIGNATURE.SMF -xf /hana/shared/$SID/install/IMDB_LCAPPS_2055_0-20010426.SAR


# Install HANA Database using hdblcm
cat /hana/shared/$SID/install/hdbserver_$SID_passwords.xml | /hana/shared/$SID/install/SAP_HANA_DATABASE/hdblcm --read_password_from_stdin=xml -b --configfile=/hana/shared/$SID/install/hdbserver_$SID_install.cfg
  
# Delete install template file

sudo rm /hana/shared/$SID/install/hdbserver_$SID_install.cfg


# Install HANA LCAPPS using hdbinst
/hana/shared/$SID/install/SAP_HANA_LCAPPS/hdbinst --sid=$SID

# Install HANA client using hdbinst
/hana/shared/$SID/install/SAP_HANA_CLIENT/hdbinst --sapmnt=/hana/shared/$SID/install/SAP_HANA_CLIENT

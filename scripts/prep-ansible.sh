#!/bin/bash

echo $(date) " - ############## Starting Script ####################"

set -e

export ADMIN_USER=$1
export HANA_ADMIN_USERNAME=$2
export PRIVATE_KEY=$3
export DB_SYSTEMDB_PASSWORD=$4
export HA_CLUSTER_PASSWORD=$5
export OS_SAPADM_PASSWORD=$6
export OS_SIDADM_PASSWORD=$7
export HANA_VM_NAME=$8
export HANA_VM_SIZE=$9
export DB_VERSION=${10}
export INSTANCE_NUMBER=${11}
export SID=${12}
export HANA_STATIC_IP=${13}
export HANA_ADMIN_STATIC_IP=${14}
export HANA_IMAGE_OFFER=${15}
export HANA_IMAGE_PUBLISHER=${16}
export HANA_IMAGE_SKU=${17}
export STORAGE_ACCOUNT_NAME=${18}
export STORAGE_ACCESS_KEY=${19}
export PROXIMITY_PLACEMENT_GROUP=${20}
export RESOURCE_GROUP_NAME=${21}
export SUBNET_MANAGEMENT_NAME=${22}
export SUBNET_MANAGEMENT_PREFIX=${23}
export SUBNET_APP_NAME=${24}
export SUBNET_APP_PREFIX=${25}
export SUBNET_DB_NAME=${26}
export SUBNET_DB_PREFIX=${27}
export SAP_USER=${26}
export SAP_PASSWORD=${27}
export SCS_STATIC_IP=${28}
export APP1_STATIC_IP=${29}
export APP2_STATIC_IP=${30}
export APP3_STATIC_IP=${31}
export WEB_STATIC_IP=${32}


runuser -l $ADMIN_USER -c "echo -e \"$PRIVATE_KEY\" > ~/.ssh/id_rsa"
runuser -l $ADMIN_USER -c "chmod 600 ~/.ssh/id_rsa*"


curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

sudo apt update
sudo apt-get install git=1:2.17.1-1ubuntu0.7
sudo apt -y install jq=1.5+dfsg-2
sudo apt -y install python3-pip
sudo -H pip3 install "ansible>=2.8,<2.9"
sudo -H pip3 install "pywinrm>=0.3.0"
sudo -H pip3 install "yamllint==1.25.0"
sudo -H pip3 install "ansible-lint==4.3.7"

sudo git clone https://github.com/Zuldajri/sapansible.git


cat > /var/lib/waagent/custom-script/download/0/sapansible/ansible/output.json <<EOF
{"databases":[{"authentication":{"type":"key","username":"$ADMIN_USER"},"components":{"hana_database":[]},"credentials":{"db_systemdb_password":"$DB_SYSTEMDB_PASSWORD","ha_cluster_password":"$HA_CLUSTER_PASSWORD","os_sapadm_password":"$OS_SAPADM_PASSWORD","os_sidadm_password":"$OS_SIDADM_PASSWORD"},"db_version":"$DB_VERSION","filesystem":"xfs","high_availability":false,"instance":{"instance_number":"$INSTANCE_NUMBER","sid":"$SID"},"nodes":[{"dbname":"$HANA_VM_NAME","ip_admin_nic":"$HANA_ADMIN_STATIC_IP","ip_db_nic":"$HANA_STATIC_IP","role":"worker"}],"os":{"offer":"$HANA_IMAGE_OFFER","publisher":"$HANA_IMAGE_PUBLISHER","sku":"$HANA_IMAGE_SKU","source_image_id":""},"platform":"HANA","size":"$HANA_VM_SIZE"}],"infrastructure":{"iscsi":{"iscsi_nic_ips":[[]]},"ppg":{"arm_id":[],"is_existing":false,"name":["$PROXIMITY_PLACEMENT_GROUP"]},"resource_group":{"arm_id":"","is_existing":false,"name":"$RESOURCE_GROUP_NAME"},"vnets":{"sap":{"subnet_admin":{"arm_id":"","is_existing":false,"name":"$SUBNET_MANAGEMENT_NAME","nsg":{"arm_id":"","is_existing":false,"name":"NP-EUS2-SAP-X00_adminSubnet-nsg"},"prefix":"$SUBNET_MANAGEMENT_PREFIX"},"subnet_app":{"arm_id":"","is_existing":false,"name":"$SUBNET_APP_NAME","nsg":{"arm_id":"","is_existing":false,"name":"_NP-EUS2-SAP-X00appSubnet-nsg"},"prefix":"$SUBNET_APP_PREFIX"},"subnet_db":{"arm_id":"","is_existing":false,"name":"$SUBNET_DB_NAME","nsg":{"arm_id":"","is_existing":false,"name":"NP-EUS2-SAP-X00_dbSubnet-nsg"},"prefix":"$SUBNET_DB_PREFIX"}}}},"options":{"enable_prometheus":true,"enable_secure_transfer":true},"sshkey":{"path_to_private_key":"/home/$ADMIN_USER/.ssh/id_rsa","path_to_public_key":"/home/$ADMIN_USER/.ssh/authorized_keys"},"software":{"downloader":{"credentials":{"sap_password":"$SAP_PASSWORD","sap_user":"$SAP_USER"},"debug":{"cert":"charles.pem","enabled":false,"proxies":{"http":"http://127.0.0.1:8888","https":"https://127.0.0.1:8888"}},"scenarios":[{"scenario_type":"APP","product_name":"S4","product_version":"1909","os_type":"LINUX_X64","os_version":"SLES12.3"},{"components":["PLATFORM"],"os_type":"LINUX_X64","os_version":"SLES12.3","product_name":"HANA","product_version":"2.0","scenario_type":"DB"},{"os_type":"LINUX_X64","product_name":"RTI","scenario_type":"RTI"},{"os_type":"NT_X64","scenario_type":"BASTION"},{"os_type":"LINUX_X64","scenario_type":"BASTION"}]},"storage_account_sapbits":{"blob_container_name":"sapbits","file_share_name":"sapbits","name":"$STORAGE_ACCOUNT_NAME","storage_access_key":"$STORAGE_ACCESS_KEY"}}}
EOF

cat > /var/lib/waagent/custom-script/download/0/sapansible/ansible/hosts.yml <<EOF
all:
  children:
    iscsi:
      hosts:

    hanadbnodes:
      hosts:
        $HANA_ADMIN_STATIC_IP:
          ansible_connection:  "ssh"
          ansible_user:        "$ADMIN_USER"

    scs:
      hosts:
        $SCS_STATIC_IP:
          ansible_connection: "ssh"
          ansible_user:       "$ADMIN_USER"

    app:
      hosts:
        $APP1_STATIC_IP:
          ansible_connection: "ssh"
          ansible_user:       "$ADMIN_USER"
        $APP2_STATIC_IP:
          ansible_connection: "ssh"
          ansible_user:       "$ADMIN_USER"
        $APP3_STATIC_IP:
          ansible_connection: "ssh"
          ansible_user:       "$ADMIN_USER"

    web:
      hosts:
        $WEB_STATIC_IP:
          ansible_connection: "ssh"
          ansible_user:       "$ADMIN_USER"

    asenodes:
      hosts:

    oraclenodes:
      hosts:

    db2nodes:
      hosts:

    sqlservernodes:
      hosts:

    # Groups below are collections of the above groups for easier reference
    all_linux_servers:
      children:
        hanadbnodes:
        scs:
        app:

    # Localhost provisioning
    local:
      hosts:
        localhost:
          ansible_connection: "local"
          ansible_user:       "$ADMIN_USER"
EOF

cat > /var/lib/waagent/custom-script/download/0/sapansible/ansible/hosts <<EOF
[iscsi]

[all_linux_servers]
$HANA_ADMIN_STATIC_IP  ansible_connection=ssh ansible_user=azureadm
$SCS_STATIC_IP  ansible_connection=ssh ansible_user=azureadm

$APP1_STATIC_IP  ansible_connection=ssh ansible_user=azureadm
$APP2_STATIC_IP  ansible_connection=ssh ansible_user=azureadm
$APP3_STATIC_IP  ansible_connection=ssh ansible_user=azureadm

$WEB_STATIC_IP  ansible_connection=ssh ansible_user=azureadm

[hanadbnodes]
$HANA_ADMIN_STATIC_IP  ansible_connection=ssh  ansible_user=azureadm

[scs]
$SCS_STATIC_IP  ansible_connection=ssh ansible_user=azureadm

[app]
$APP1_STATIC_IP  ansible_connection=ssh ansible_user=azureadm
$APP2_STATIC_IP  ansible_connection=ssh ansible_user=azureadm
$APP3_STATIC_IP  ansible_connection=ssh ansible_user=azureadm

[web]
$WEB_STATIC_IP  ansible_connection=ssh ansible_user=azureadm

[ase]

[oracle]

[db2]

[sqlserver]
EOF


ansible-playbook -i /var/lib/waagent/custom-script/download/0/sapansible/ansible/hosts.yml /var/lib/waagent/custom-script/download/0/sapansible/ansible/sap_playbook.yml --private-key /home/$ADMIN_USER/.ssh/id_rsa


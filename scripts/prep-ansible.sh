#!/bin/bash

echo $(date) " - ############## Starting Script ####################"

set -e

export ADMIN_USER=$1
export DB_SYSTEMDB_PASSWORD=$2
export HA_CLUSTER_PASSWORD=$3
export OS_SAPADM_PASSWORD=$4
export OS_SIDADM_PASSWORD=$5
export HANA_VM_NAME=$6
export HANA_VM_SIZE=$7
export HANA_NODE_ROLE=$8
export DB_VERSION=$9
export INSTANCE_NUMBER=${10}
export SID=${11}
export HANA_STATIC_IP=${12}
export HANA_ADMIN_STATIC_IP=${13}
export HANA_LB_IP=${14}
export HANA_IMAGE_OFFER=${15}
export HANA_IMAGE_PUBLISHER=${16}
export HANA_IMAGE_SKU=${17}
export LINUX_JUMPBOX_STATIC_IP=${18}
export LINUX_JUMPBOX_NAME=${19}
export LINUX_JUMPBOX_VM_SIZE=${20}
export LINUX_JUMPBOX_IMAGE_OFFER=${21}
export LINUX_JUMPBOX_IMAGE_PUBLISHER=${22}
export LINUX_JUMPBOX_IMAGE_SKU=${23}
export WINDOWS_JUMPBOX_STATIC_IP=${24}
export WINDOWS_JUMPBOX_NAME=${25}
export WINDOWS_JUMPBOX_VM_SIZE=${26}
export WINDOWS_JUMPBOX_IMAGE_OFFER=${27}
export WINDOWS_JUMPBOX_IMAGE_PUBLISHER=${28}
export WINDOWS_JUMPBOX_IMAGE_SKU=${29}
export ADMIN_PASSWORD=${30}
export STORAGE_ACCOUNT_NAME=${31}
export STORAGE_ACCESS_KEY=${32}
export PROXIMITY_PLACEMENT_GROUP=${33}
export RESOURCE_GROUP_NAME=${34}
export SUBNET_MANAGEMENT_NAME=${35}
export SUBNET_MANAGEMENT_PREFIX=${36}
export SUBNET_APP_NAME=${37}
export SUBNET_APP_PREFIX=${38}
export SUBNET_DB_NAME=${39}
export SUBNET_DB_PREFIX=${40}
export SAP_USER=${41}
export SAP_PASSWORD=${42}
export SCS_STATIC_IP=${43}
export APP1_STATIC_IP=${44}
export APP2_STATIC_IP=${45}
export APP3_STATIC_IP=${46}
export WEB_STATIC_IP=${47}
export PRIVATE_KEY=${48}


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
{"databases":[{"authentication":{"type":"key","username":"$ADMIN_USER"},"components":{"hana_database":[]},"credentials":{"db_systemdb_password":"$DB_SYSTEMDB_PASSWORD","ha_cluster_password":"$HA_CLUSTER_PASSWORD","os_sapadm_password":"$OS_SAPADM_PASSWORD","os_sidadm_password":"$OS_SIDADM_PASSWORD"},"db_version":"$DB_VERSION","filesystem":"xfs","high_availability":false,"instance":{"instance_number":"$INSTANCE_NUMBER","sid":"$SID"},"loadbalancer":{"frontend_ip":"$HANA_LB_IP"},"nodes":[{"dbname":"$HANA_VM_NAME","ip_admin_nic":"$HANA_ADMIN_STATIC_IP","ip_db_nic":"$HANA_STATIC_IP","role":"$HANA_NODE_ROLE"}],"os":{"offer":"$HANA_IMAGE_OFFER","publisher":"$HANA_IMAGE_PUBLISHER","sku":"$HANA_IMAGE_SKU","source_image_id":""},"platform":"HANA","size":"$HANA_VM_SIZE"}],"jumpboxes":{"linux":[{"name":"$LINUX_JUMPBOX_NAME","size":"$LINUX_JUMPBOX_VM_SIZE","destroy_after_deploy":false,"private_ip_address":"$LINUX_JUMPBOX_STATIC_IP","components":["hana_studio_linux","hana_client_linux"],"authentication":{"type":"key","username":"$ADMIN_USER"},"os":{"offer":"$LINUX_JUMPBOX_IMAGE_OFFER","publisher":"$LINUX_JUMPBOX_IMAGE_PUBLISHER","sku":"$LINUX_JUMPBOX_IMAGE_SKU","source_image_id":""}}],"windows":[{"name":"$WINDOWS_JUMPBOX_NAME","size":"$WINDOWS_JUMPBOX_VM_SIZE","destroy_after_deploy":false,"private_ip_address":"$WINDOWS_JUMPBOX_STATIC_IP","components":["hana_studio_windows","hana_client_windows"],"authentication":{"type":"password","username":"$ADMIN_USER","password":"$ADMIN_PASSWORD"},"os":{"offer":"$WINDOWS_JUMPBOX_IMAGE_OFFER","publisher":"$WINDOWS_JUMPBOX_IMAGE_PUBLISHER","sku":"$WINDOWS_JUMPBOX_IMAGE_SKU","source_image_id":""}}]},"infrastructure":{"iscsi":{"iscsi_nic_ips":[[]]},"ppg":{"arm_id":[],"is_existing":false,"name":["$PROXIMITY_PLACEMENT_GROUP"]},"resource_group":{"arm_id":"","is_existing":false,"name":"$RESOURCE_GROUP_NAME"},"vnets":{"sap":{"subnet_admin":{"arm_id":"","is_existing":false,"name":"$SUBNET_MANAGEMENT_NAME","nsg":{"arm_id":"","is_existing":false,"name":"adminSubnet-nsg"},"prefix":"$SUBNET_MANAGEMENT_PREFIX"},"subnet_app":{"arm_id":"","is_existing":false,"name":"$SUBNET_APP_NAME","nsg":{"arm_id":"","is_existing":false,"name":"appSubnet-nsg"},"prefix":"$SUBNET_APP_PREFIX"},"subnet_db":{"arm_id":"","is_existing":false,"name":"$SUBNET_DB_NAME","nsg":{"arm_id":"","is_existing":false,"name":"dbSubnet-nsg"},"prefix":"$SUBNET_DB_PREFIX"}}}},"options":{"enable_prometheus":true,"enable_secure_transfer":true},"sshkey":{"path_to_private_key":"/home/$ADMIN_USER/.ssh/id_rsa","path_to_public_key":"/home/$ADMIN_USER/.ssh/authorized_keys"},"software":{"downloader":{"credentials":{"sap_password":"$SAP_PASSWORD","sap_user":"$SAP_USER"},"debug":{"cert":"charles.pem","enabled":false,"proxies":{"http":"http://127.0.0.1:8888","https":"https://127.0.0.1:8888"}},"scenarios":[{"scenario_type":"APP","product_name":"S4","product_version":"1.0","os_type":"LINUX_X64","os_version":"SLES12.3"},{"components":["PLATFORM","DATABASE","CLIENT","STUDIO","COCKPIT"],"os_type":"LINUX_X64","os_version":"SLES12.3","product_name":"HANA","product_version":"2.0","scenario_type":"DB"},{"os_type":"LINUX_X64","product_name":"RTI","scenario_type":"RTI"},{"os_type":"NT_X64","scenario_type":"BASTION"},{"os_type":"LINUX_X64","scenario_type":"BASTION"}]},"storage_account_sapbits":{"blob_container_name":"sapbits","file_share_name":"sapbits","name":"$STORAGE_ACCOUNT_NAME","storage_access_key":"$STORAGE_ACCESS_KEY"}}}
EOF

cat > /var/lib/waagent/custom-script/download/0/sapansible/ansible/hosts.yml <<EOF
all:
  children:
    iscsi:
      hosts:

    jumpboxes_linux:
      hosts:
        $LINUX_JUMPBOX_STATIC_IP:
          ansible_connection:  "ssh"
          ansible_user:        "$ADMIN_USER"

    jumpboxes_windows:
      hosts:
        $WINDOWS_JUMPBOX_STATIC_IP:
          ansible_connection:  "winrm"
          ansible_user:        "$ADMIN_USER"
          ansible_password:    "$ADMIN_PASSWORD"
          ansible_winrm_server_cert_validation: "ignore"

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


echo "=== Run ansible playbook ==="
echo "=== This may take quite a while, please be patient ==="
ansible-playbook --version
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
export ANSIBLE_HOST_KEY_CHECKING=False


ansible-playbook -i /var/lib/waagent/custom-script/download/0/sapansible/ansible/hosts.yml /var/lib/waagent/custom-script/download/0/sapansible/ansible/sap_playbook.yml --private-key /home/$ADMIN_USER/.ssh/id_rsa


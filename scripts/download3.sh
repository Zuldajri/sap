#!/bin/bash

echo $(date) " - ############## Starting Script ####################"

set -e

export ADMIN_USER=$1

cd /var/lib/waagent/custom-script/download/0/sapansible/python/downloader

python3 /var/lib/waagent/custom-script/download/0/sapansible/python/downloader/basket3.py --config /var/lib/waagent/custom-script/download/0/sapansible/ansible/output.json --dir /sapmnt1

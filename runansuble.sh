#! /bin/bash

echo -n "username:"
read USERNAME
if [ ! ${USERNAME} ]; then USERNAME="nothing"; fi
if [ ${USERNAME} == "nothing" ]; then
  echo "Required username"
  exit 1
fi

source ~/Dropbox/backup/mytodo-sinatra/config.ini
source ~/Dropbox/backup/owncloud/config.ini
vars="{\"TODOSINATRA_CLIENT_ID\":\"$TODOSINATRA_CLIENT_ID\",
        \"TODOSINATRA_CLIENTSECRET_ID\":\"$TODOSINATRA_CLIENTSECRET_ID\",
        \"OWNCLOUD_DB\":\"$OWNCLOUD_DB\",
        \"OWNCLOUD_USER\":\"$OWNCLOUD_USER\",
        \"OWNCLOUD_PASSWORD\":\"$OWNCLOUD_PASSWORD\",
        \"MYSQL_ROOT_PASSWORD\":\"$MYSQL_ROOT_PASSWORD\"}"
ansible-playbook -i hosts -u ${USERNAME} -K --extra-vars="${vars}" site.yml

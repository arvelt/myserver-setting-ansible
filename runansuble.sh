#! /bin/bash

source ~/Dropbox/backup/mytodo-sinatra/config.ini
source ~/Dropbox/backup/owncloud/config.ini
vars="{\"TODOSINATRA_CLIENT_ID\":\"$TODOSINATRA_CLIENT_ID\",
        \"TODOSINATRA_CLIENTSECRET_ID\":\"$TODOSINATRA_CLIENTSECRET_ID\",
        \"OWNCLOUD_DB\":\"$OWNCLOUD_DB\",
        \"OWNCLOUD_USER\":\"$OWNCLOUD_USER\",
        \"OWNCLOUD_PASSWORD\":\"$OWNCLOUD_PASSWORD\",
        \"MYSQL_ROOT_PASSWORD\":\"$MYSQL_ROOT_PASSWORD\"}"
ansible-playbook -i hosts  --extra-vars="${vars}" site.yml

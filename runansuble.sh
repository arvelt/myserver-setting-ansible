#! /bin/bash

source ~/Dropbox/backup/mytodo-sinatra/config.ini
vars="{\"TODOSINATRA_CLIENT_ID\":\"$TODOSINATRA_CLIENT_ID\",
        \"TODOSINATRA_CLIENTSECRET_ID\":\"$TODOSINATRA_CLIENTSECRET_ID\"}"
ansible-playbook -i hosts  --extra-vars="${vars}" site.yml

#! /bin/bash

echo -n "SSH Port No (8022/9022/10022/etc...) [nothing]:"
read SSHPNO
if [ ! ${SSHPNO} ]; then SSHPNO="nothing"; fi

if [ ${SSHPNO} == "nothing" ]; then
  echo "Required ssh port no"
  exit 1
fi


fname='/etc/ssh/sshd_config'
if [ ! -f ${fname}_bak ]; then cp ${fname} ${fname}_bak; fi
sed -i "s/^#Port 22/Port ${SSHPNO}/" ${fname}
#sed -i 's/^#PermitRootLogin yes/PermitRootLogin no/' ${fname}
sed -i 's/^#PermitEmptyPasswords/PermitEmptyPasswords/' ${fname}
echo "AllowUsers ${UName}" >> ${fname}

#! /bin/bash
################################################################################
###
###  情報入力
###
################################################################################

#-----------------------------------
# Edit Your Setting
#-----------------------------------
NTP1='ntp.asahi-net.or.jp'
NTP2='ntp1.sakura.ad.jp'
NTP3='ntp.ring.gr.jp'
#-----------------------------------

echo -n "User Name : "
read UName

echo -n "User Password : "
read UPass

echo -n "SSH Port No (8022/9022/10022/etc...) [nothing]:"
read SSHPNO
if [ ! ${SSHPNO} ]; then SSHPNO="nothing"; fi

if [ ${SSHPNO} == "nothing" ]; then
  echo "Required ssh port no"
  exit 1
fi

echo "
*******************************
 Admin User  = ${UName} / ${UPass}
 SSH Port No = ${SSHPNO}
 SELinux     = Disabled
 NTP Server1 = ${NTP1}
           2 = ${NTP2}
           3 = ${NTP3}
*******************************"

echo -n "Run OK ? (yes/no) [no]:"
read OKNG

if [ ! ${OKNG} ]; then OKNG="no"; fi

if [ ${OKNG} != "yes" ]; then exit 1; fi



################################################################################
###
###  基本設定
###
################################################################################

# サービスを停止
#if [ -f '/etc/rc.d/init.d/iscsid'    ]; then chkconfig iscsid off;    fi
#if [ -f '/etc/rc.d/init.d/iptables'  ]; then chkconfig iptables off;  fi
#if [ -f '/etc/rc.d/init.d/ip6tables' ]; then chkconfig ip6tables off; fi
if [ -f '/etc/rc.d/init.d/iscsi'     ]; then chkconfig iscsi off;     fi
if [ -f '/etc/rc.d/init.d/nfslock'   ]; then chkconfig nfslock off;   fi
if [ -f '/etc/rc.d/init.d/rpcidmapd' ]; then chkconfig rpcidmapd off; fi
if [ -f '/etc/rc.d/init.d/rpcgssd'   ]; then chkconfig rpcgssd off;   fi
if [ -f '/etc/rc.d/init.d/netfs'     ]; then chkconfig netfs off;     fi
if [ -f '/etc/rc.d/init.d/fcoe'      ]; then chkconfig fcoe off;      fi
if [ -f '/etc/rc.d/init.d/udev-post' ]; then chkconfig udev-post off; fi
if [ -f '/etc/rc.d/init.d/auditd' ]; then chkconfig auditd off; fi
if [ -f '/etc/rc.d/init.d/autofs' ]; then chkconfig autofs off; fi
if [ -f '/etc/rc.d/init.d/avahi-daemon' ]; then chkconfig avahi-daemon off; fi
if [ -f '/etc/rc.d/init.d/bluetooth' ]; then chkconfig bluetooth off; fi
if [ -f '/etc/rc.d/init.d/cups' ]; then chkconfig cups off; fi
if [ -f '/etc/rc.d/init.d/firstboot' ]; then chkconfig firstboot off; fi
if [ -f '/etc/rc.d/init.d/gpm' ]; then chkconfig gpm off; fi
if [ -f '/etc/rc.d/init.d/haldaemon' ]; then chkconfig haldaemon off; fi
if [ -f '/etc/rc.d/init.d/hidd' ]; then chkconfig hidd off; fi
if [ -f '/etc/rc.d/init.d/isdn' ]; then chkconfig isdn off; fi
if [ -f '/etc/rc.d/init.d/kudzu' ]; then chkconfig kudzu off; fi
if [ -f '/etc/rc.d/init.d/lvm2-monitor' ]; then chkconfig lvm2-monitor off; fi
if [ -f '/etc/rc.d/init.d/mcstrans' ]; then chkconfig mcstrans off; fi
if [ -f '/etc/rc.d/init.d/mdmonitor' ]; then chkconfig mdmonitor off; fi
if [ -f '/etc/rc.d/init.d/messagebus' ]; then chkconfig messagebus off; fi
if [ -f '/etc/rc.d/init.d/netfs' ]; then chkconfig netfs off; fi
if [ -f '/etc/rc.d/init.d/nfslock' ]; then chkconfig nfslock off; fi
if [ -f '/etc/rc.d/init.d/pcscd' ]; then chkconfig pcscd off; fi
if [ -f '/etc/rc.d/init.d/portmap' ]; then chkconfig portmap off; fi
if [ -f '/etc/rc.d/init.d/rawdevices' ]; then chkconfig rawdevices off; fi
if [ -f '/etc/rc.d/init.d/restorecond' ]; then chkconfig restorecond off; fi
if [ -f '/etc/rc.d/init.d/rpcgssd' ]; then chkconfig rpcgssd off; fi
if [ -f '/etc/rc.d/init.d/rpcidmapd' ]; then chkconfig rpcidmapd off; fi
if [ -f '/etc/rc.d/init.d/smartd' ]; then chkconfig smartd off; fi
if [ -f '/etc/rc.d/init.d/xfs' ]; then chkconfig xfs off; fi
if [ -f '/etc/rc.d/init.d/yum-updatesd' ]; then chkconfig yum-updatesd off; fi


# SELINUXを無効にする
setenforce 0
fname='/etc/selinux/config'
if [ ! -f ${fname}_bak ]; then cp ${fname} ${fname}_bak; fi
cp ${fname}_bak ${fname}
sed -i 's/^SELINUX=enforcing/SELINUX=disabled/' ${fname}


#文字コードを設定
sed -i 's/^LANG=.*/LANG=\"ja_JP.UTF-8\"/' /etc/sysconfig/i18n


# 一般ユーザの設定
sed -i 's/SHELL=\/bin\/bash/SHELL=\/sbin\/nologin/' /etc/default/useradd
sed -i 's/CREATE_MAIL_SPOOL=yes/CREATE_MAIL_SPOOL=no/' /etc/default/useradd


# sshログイン可能なユーザを追加
ret=`cat /etc/passwd | grep ^${UName}`
if [ $ret ]; then userdel -r ${UName}; fi
useradd -g wheel -s /bin/bash ${UName}


# -パスワード指定
echo ${UPass} | passwd --stdin ${UName}


# wheelグループへ追加
usermod -G wheel ${UName}


# wheelグループがルートになれるようにする
fname='/etc/sudoers'
if [ ! -f ${fname}_bak ]; then cp ${fname} ${fname}_bak; fi
sed -i 's/^# %wheel\s*ALL=(ALL)\s*ALL/%wheel ALL=(ALL) ALL/' ${fname}


# -sshの設定
fname='/etc/ssh/sshd_config'
if [ ! -f ${fname}_bak ]; then cp ${fname} ${fname}_bak; fi
sed -i "s/^#Port 22/Port ${SSHPNO}/" ${fname}
sed -i 's/^#PermitEmptyPasswords/PermitEmptyPasswords/' ${fname}
sed -i 's/^#PubkeyAuthentication/PubkeyAuthentication/' ${fname}
sed -i 's/^#RSAAuthentication/RSAAuthentication/' ${fname}
sed -i 's/^#AuthorizedKeysFile/AuthorizedKeysFile/' ${fname}
echo "AllowUsers ${UName}" >> ${fname}
service sshd restart
chkconfig sshd on

# ファイアーウォール設定
echo "*filter
:INPUT   ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT  ACCEPT [0:0]
:RH-Firewall-1-INPUT - [0:0]

-A INPUT -j RH-Firewall-1-INPUT
-A FORWARD -j RH-Firewall-1-INPUT
-A RH-Firewall-1-INPUT -i lo -j ACCEPT
-A RH-Firewall-1-INPUT -p icmp --icmp-type any -j ACCEPT
-A RH-Firewall-1-INPUT -p 50 -j ACCEPT
-A RH-Firewall-1-INPUT -p 51 -j ACCEPT
-A RH-Firewall-1-INPUT -p udp --dport 5353 -d 224.0.0.251 -j ACCEPT
-A RH-Firewall-1-INPUT -p udp -m udp --dport 631 -j ACCEPT
-A RH-Firewall-1-INPUT -p tcp -m tcp --dport 631 -j ACCEPT
-A RH-Firewall-1-INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# ssh
-A RH-Firewall-1-INPUT -m state --state NEW -m tcp -p tcp --dport ${SSHPNO} -j ACCEPT

# custom

-A RH-Firewall-1-INPUT -j REJECT --reject-with icmp-host-prohibited

COMMIT" > /etc/sysconfig/iptables
service iptables restart
chkconfig iptables on

su - ${UName}
mkdir .ssh
chmod 700 .ssh
cd .ssh
touch authorized_keys
chmod 600 authorized_keys

echo 'Add publick key to ~/.ssh/authorized_keys'

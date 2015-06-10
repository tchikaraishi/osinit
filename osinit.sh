#!/bin/bash
#
# ConoHaのCentOS 7.1の初期設定をするシェルスクリプト
#

if [ `id -u` -ne 0 ]
then
	echo "Re-run this program as the super user." >&2
	exit 1
fi

# ----------------------------------------------------------------------
# 1. SSHの設定
# ----------------------------------------------------------------------
sed -e "
	s/^#Port 22$/Port 10022/
	s/^PermitRootLogin yes$/PermitRootLogin no/
	s/^PasswordAuthentication yes$/PasswordAuthentication no/
	77s/^PasswordAuthentication no$/#PasswordAuthentication yes/
" -i /etc/ssh/sshd_config
sed -e "
	s/22/10022/
" -i /usr/lib/firewalld/services/ssh.xml

# ----------------------------------------------------------------------
# 2. ユーザーの作成
# ----------------------------------------------------------------------
groupadd admin
useradd -g admin -G wheel admin
chfn -f Administrator admin
mount /dev/sr1 /mnt
sed -e '
	s/^{"admin_pass": "//
	s/".*$//
' /mnt/openstack/latest/meta_data.json | passwd --stdin admin
visudo 2> /dev/null <<EOT
:/^# %wheel\s*ALL=(ALL)\s*ALL/s/^#\s*//
:wq
EOT
cp -r ~/.ssh ~admin
chown -R admin:admin ~admin/.ssh

# ----------------------------------------------------------------------
# 3. ホスト名の設定
# ----------------------------------------------------------------------
host `ip -4 addr show eth0 | grep inet | sed -e "
	s/^.*inet //
	s/\/.*$//
"` | sed -e "
	s/^.*domain name pointer //
	s/\.$//
" > /etc/hostname

# ----------------------------------------------------------------------
# 4. 下記メールの抑止
# Cron <root@xxx-xxx-xxx-xxx> /usr/lib64/sa/sa1 1 1
# Cannot open /var/log/sa/sa08: No such file or directory
# ----------------------------------------------------------------------
mkdir /var/log/sa

# ----------------------------------------------------------------------
# 4. ソフトウェアの更新
# ----------------------------------------------------------------------
yum -y update

# ----------------------------------------------------------------------
# 5. システムの再起動
# ----------------------------------------------------------------------
shutdown -r now

exit 0

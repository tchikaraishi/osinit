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
	s/^PermitRootLogin yes$/PermitRootLogin no/
	s/^PasswordAuthentication yes$/PasswordAuthentication no/
	77s/^PasswordAuthentication no$/#PasswordAuthentication yes/
" -i /etc/ssh/sshd_config

# ----------------------------------------------------------------------
# 2. ユーザーの作成
# ----------------------------------------------------------------------
groupadd admin
useradd -g admin -G wheel admin
chfn -f Administrator admin
passwd admin
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
# 4. 下記ログの抑止
# /var/log/messages
# Could not open dir /var/log/audit (No such file or directory)
# ----------------------------------------------------------------------
mkdir /var/log/audit
chmod o-rx /var/log/audit

# ----------------------------------------------------------------------
# 5. 下記メールの抑止
# Cron <root@xxx-xxx-xxx-xxx> /usr/lib64/sa/sa1 1 1
# Cannot open /var/log/sa/sa08: No such file or directory
# ----------------------------------------------------------------------
mkdir /var/log/sa

# ----------------------------------------------------------------------
# 6. ソフトウェアの更新
# ----------------------------------------------------------------------
yum -y update

# ----------------------------------------------------------------------
# 7. システムの再起動
# ----------------------------------------------------------------------
shutdown -r now

exit 0

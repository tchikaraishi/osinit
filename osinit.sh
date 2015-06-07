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
sed -e "{
	s/^#Port 22$/Port 10022/
	s/^PermitRootLogin yes$/PermitRootLogin no/
	s/^PasswordAuthentication yes$/PasswordAuthentication no/
	77s/^PasswordAuthentication no$/#PasswordAuthentication yes/
}" -i /etc/ssh/sshd_config
sed -e "s/22/10022/" -i /usr/lib/firewalld/services/ssh.xml

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
# 3. ソフトウェアの更新
# ----------------------------------------------------------------------
yum -y update

# ----------------------------------------------------------------------
# 4. システムの再起動
# ----------------------------------------------------------------------
shutdown -r now

exit 0

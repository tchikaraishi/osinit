#!/bin/bash
#
# ConoHaのCentOS 7.1にLogwatchをインストールするシェルスクリプト
#

if [ `id -u` -ne 0 ]
then
	echo "Re-run this program as the super user." >&2
	exit 1
fi

# レポートの宛先 (例: admin@example.com)
ADMIN_CONTACT=$1

# ----------------------------------------------------------------------
# 1. Logwatchのインストール
# ----------------------------------------------------------------------
yum -y install logwatch

# ----------------------------------------------------------------------
# 2. メール転送の設定
# ----------------------------------------------------------------------
if [ -n "$ADMIN_CONTACT" ]
then
	cat >> /etc/aliases <<EOT
root:		$ADMIN_CONTACT
EOT
	newaliases
fi

exit 0

#!/bin/bash
#
# ConoHaのCentOS 7.1をGUI環境にするシェルスクリプト
#
if [ `id -u` -ne 0 ]
then
	echo "Re-run this program as the super user." >&2
	exit 1
fi

GNOME_DESKTOP="
@base
@core
@desktop-debugging
@dial-up
@fonts
@gnome-desktop
@guest-agents
@guest-desktop-agents
@input-methods
@internet-browser
@multimedia
@print-client
@x11
kexec-tools"

SERVER_WITH_GUI="
@base
@core
@desktop-debugging
@dial-up
@fonts
@gnome-desktop
@guest-agents
@guest-desktop-agents
@input-methods
@internet-browser
@multimedia
@print-client
@x11
kexec-tools"

DEVELOPMENT_AND_CREATIVE_WORKSTATION="
@base
@core
@debugging
@desktop-debugging
@dial-up
@directory-client
@fonts
@gnome-apps
@gnome-desktop
@guest-desktop-agents
@input-methods
@internet-applications
@internet-browser
@java-platform
@multimedia
@network-file-system-client
@performance
@perl-runtime
@print-client
@ruby-runtime
@virtualization-client
@virtualization-hypervisor
@virtualization-tools
@web-server
@x11
kexec-tools"

# ----------------------------------------------------------------------
# 1. 言語の設定
# ----------------------------------------------------------------------
localectl set-locale LANG=ja_JP.UTF8

# ----------------------------------------------------------------------
# 2. GUIのインストール
# ----------------------------------------------------------------------
yum -y install $GNOME_DESKTOP

# ----------------------------------------------------------------------
# 3. 起動モードの設定
# ----------------------------------------------------------------------
systemctl set-default graphical.target

# ----------------------------------------------------------------------
# 4. システムの再起動
# ----------------------------------------------------------------------
shutdown -r now

exit 0

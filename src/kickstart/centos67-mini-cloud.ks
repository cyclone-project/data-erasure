#
# Copyrights     : CNRS
# Author         : Oleg Lodygensky
#
#    This is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this.  If not, see <http://www.gnu.org/licenses/>.
#
#  ******************************************************************
#  File    : centos67-mini-cloud.ks
#  Date    : March 24th, 2016
#  Author  : Oleg Lodygensky
# 
#  OS      : CentOS 6.7
#  Arch    : 64bits
# 
#  Purpose : this script creates a new CentOS 6.7 LiveCD
#
#  See     : misc/centos67-mini-cloud.ks
#
#  Requirements: centos67-mini-cloud.ks
#
# 
# Changelog:
#
#  ******************************************************************

lang en_US.UTF-8
keyboard us
timezone Europe/Paris
auth --useshadow --enablemd5
selinux --disabled
firewall --disabled
rootpw --lock dummy

part / --size 4096 --fstype ext4

network --onboot yes --device eth0 --bootproto dhcp --hostname=centos6-mini-cloud
services --enabled=network,sshd

repo --name=a-base --baseurl=http://mirror.isoc.org.il/pub/centos/6/os/$basearch
repo --name=a-updates --baseurl=http://mirror.isoc.org.il/pub/centos/6/updates/$basearch
repo --name=epel --baseurl=http://dl.fedoraproject.org/pub/epel/6/$basearch

bootloader --append="selinux=0 console=ttyS0 console=tty0 ignore_loglevel" --timeout=1



%packages
bash
kernel
passwd
chkconfig
rootfiles
dhclient
which
sudo
#grub
yum
system-config-firewall-base


cloud-init
openssh-clients
openssh-server

# livecd bits to set up the livecd
device-mapper-multipath

%end

###############################################################################
# This is run outside chroot
###############################################################################
%post --nochroot

# Fix Issue with ansible chroot transport crashing when PATH variable is not defined
export PATH=$PATH:/usr/local/sbin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin

# Fix issue with resolving not working for chroot
cp /etc/resolv.conf $INSTALL_ROOT/etc/resolv.conf

# Generate inventory file for ansible
cat > /root/livecd-ansible/auto_gen_ansible_hosts-centos6-mini << EOF_ansible_hosts
[post]
$INSTALL_ROOT

[post-nochroot]
127.0.0.1 live_root=$LIVE_ROOT
127.0.0.1 install_root=$INSTALL_ROOT
EOF_ansible_hosts

# Perform postinstallation with ansible
/usr/bin/ansible-playbook -i /root/livecd-ansible/auto_gen_ansible_hosts-centos6-mini /root/livecd-ansible/centos6-mini.yml

%end

###############################################################################
# This is run inside chroot
###############################################################################
%post

#
# configure sudoers
#
# cloud-user account is for cloud using cloud-init : allowed to do all
echo "cloud-user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers


/sbin/chkconfig --add cloud-init
/sbin/chkconfig       cloud-init on
/sbin/chkconfig --add sshd
/sbin/chkconfig       sshd       on 
#/sbin/service         cloud-init start
#/sbin/service         sshd       start

#if [ -f /boot/grub/menu.lst ] ; then
#serial --unit=0 --speed=115200
#terminal --timeout=10 serial console
#	sed "s/^[[:space:]]*kernel.*/&/g" /boot/grub/menu.lst
#fi

%end


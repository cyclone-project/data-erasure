#!/bin/sh

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
#

#  ******************************************************************
#  File    : centos67_mini_cloud.sh 
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
ROOTDIR=`dirname $0`
livecd-creator -c $ROOTDIR/../kickstart/centos67-mini-cloud.ks --cache=cache -f centos67-mini-cloud

#!/bin/bash

uid=$1;
gid=$2;

if ! id kitt;  then
	/usr/sbin/groupadd -g $gid kitt;
	/usr/sbin/useradd -m -s /bin/bash -u $uid -g $gid kitt;
fi

# 启动
/usr/sbin/nginx


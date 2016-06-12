#!/bin/bash

uid=$1;
gid=$2;

/usr/sbin/groupadd -g $gid kitt;
/usr/sbin/useradd -m -s /bin/bash -u $uid -g $gid kitt;

/user/bin/touch /var/log/nginx/access.log;
/user/bin/touch /var/log/nginx/error.log;
/bin/chown kitt:kitt  /var/log/nginx/access.log;
/bin/chown kitt:kitt  /var/log/nginx/error.log;

/usr/sbin/nginx


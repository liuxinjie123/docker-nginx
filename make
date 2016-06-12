#!/bin/bash

source ../aegis-docker/bin/aegis-config;
export pwd=$(pwd);

# 各成员站点的静态文件目录 以及文件上传挂载点
upload_root=$(cd ../; mkdir -p files; cd files; pwd);

export container_name=nginx-dev;
export project_name=ubuntu-nginx;
export image_name=ubuntu-nginx;
export ip="";


mkdir -p logs;
if [[ "$@" = "staging" ]]; then
    member_static=$(mkdir -p ../aegis-member/static/dist; cd ../aegis-member/static/dist; pwd);
    pay_static=$(   mkdir -p ../aegis-pay/app/dist;       cd ../aegis-pay/app/dist;       pwd);
    site_static=$(  mkdir -p ../aegis-site/src-web/dist;  cd ../aegis-site/src-web/dist;  pwd);
    export create_param="-v ${pwd}/sites-enabled:/etc/nginx/sites-enabled \
-v ${pwd}/deny:/etc/nginx/deny \
-v ${pwd}/logs:/var/log/nginx \
-v ${pwd}/certs:/etc/nginx/certs \
-v ${member_static}:/nginx/member/static \
-v ${pay_static}/public:/nginx/pay/static \
-v ${site_static}:/nginx/site/static \
-v ${upload_root}:/nginx/files";
else
    member_static=$(cd ../aegis-member/static; pwd);
    pay_static=$(   cd ../aegis-pay/app;       pwd);
    site_static=$(  cd ../aegis-site/src-web;  mkdir -p dist; cd dist; pwd);
    export create_param="-v ${pwd}/sites-enabled:/etc/nginx/sites-enabled \
-v ${pwd}/deny:/etc/nginx/deny \
-v ${pwd}/log:/var/log/nginx \
-v ${pwd}/certs:/etc/nginx/certs \
-v ${member_static}:/nginx/member/static \
-v ${pay_static}/public:/nginx/pay/static \
-v ${site_static}:/nginx/site/static \
-v ${upload_root}:/nginx/files";
fi

# 重写mbt!!!!!
mbt_rewrite;
devCreate() {
	touch logs/access.log;
	touch logs/error.log;
	if ! docker run -d --name $container_name --net host $create_param $image_name > /dev/null; then
        echo "ERROR: [docker run -d --name $container_name --net host $create_param $image_name] failed" | color red bold;
        exit -1;
    fi
    echo "$container_name is created" | color green bold;
}
stagingCreate() {
	devCreate;
}
local() { echo "ERROR: target not supported" | color red bold; }
debug() { echo "ERROR: target not supported" | color red bold; }

eval $@;


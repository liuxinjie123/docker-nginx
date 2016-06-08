#!/bin/bash

source ../aegis-docker/bin/aegis-config;
export pwd=$(pwd);

# 各成员站点的静态文件目录 以及文件上传挂载点
member_static=$(cd ../aegis-member/static; pwd);
pay_static=$(cd ../aegis-pay/; pwd);
site_static=$(cd ../aegis-site/src-web;mkdir -p dist;cd dist;pwd);
upload_root=$(cd ../; mkdir -p files; cd files; pwd);

export container_name=nginx-dev;
export project_name=ubuntu-nginx;
export image_name=ubuntu-nginx;
export ip="";
export create_param="-v ${pwd}/sites-enabled:/etc/nginx/sites-enabled \
-v ${pwd}/log:/var/log/nginx \
-v ${pwd}/certs:/etc/nginx/certs \
-v ${member_static}:/nginx/member/static \
-v ${pay_static}/public:/nginx/pay/static \
-v ${site_static}:/nginx/site/static \
-v ${upload_root}:/files";
export dev_registry=192.168.99.100:5000;
export registry=registry.yimei180.com;

# 重写mbt!!!!!
mbt_rewrite;
devCreate() {
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


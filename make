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
    member_static=$(mkdir -p ../aegis-member/static/dist;   cd ../aegis-member/static/dist; pwd);
    pay_static=$(   mkdir -p ../aegis-pay/frontend/dist;         cd ../aegis-pay/frontend/dist;       pwd);
    site_static=$(  mkdir -p ../aegis-site/src-web/dist;    cd ../aegis-site/src-web/dist;  pwd);
    admin_static=$( mkdir -p ../kitt/admin/src-web/dist;    cd ../kitt/admin/src-web/dist;  pwd);
    wechat_static=$( mkdir -p ../aegis-wechat/src-web/dist;  cd ../aegis-wechat/src-web/dist;  pwd);
    export create_param="-v ${pwd}/sites-enabled:/etc/nginx/sites-enabled \
-v ${pwd}/deny:/etc/nginx/deny \
-v ${pwd}/logs:/var/log/nginx \
-v ${pwd}/certs-prod:/etc/nginx/certs \
--volumes-from member-ui-data \
--volumes-from pay-ui-data \
--volumes-from site-ui-data \
-v ${admin_static}:/nginx/admin/static \
-v ${wechat_static}:/nginx/wechat/static \
-v ${upload_root}:/nginx/files";
elif [[ "$@" = "testing" ]]; then
    member_static=$(mkdir -p ../aegis-member/static/dist;  cd ../aegis-member/static/dist; pwd);
    pay_static=$(   mkdir -p ../aegis-pay/frontend/dist;        cd ../aegis-pay/frontend/dist;       pwd);
    site_static=$(  mkdir -p ../aegis-site/src-web/dist;   cd ../aegis-site/src-web/dist;  pwd);
    admin_static=$( mkdir -p ../kitt/admin/src-web/dist;   cd ../kitt/admin/src-web/dist;  pwd);
    wechat_static=$( mkdir -p ../aegis-wechat/src-web/dist; cd ../aegis-wechat/src-web/dist; pwd);
    export create_param="-v ${pwd}/sites-enabled-testing:/etc/nginx/sites-enabled \
-v ${pwd}/deny:/etc/nginx/deny \
-v ${pwd}/logs:/var/log/nginx \
-v ${pwd}/certs-prod:/etc/nginx/certs \
--volumes-from member-ui-data \
--volumes-from pay-ui-data \
--volumes-from site-ui-data \
-v ${admin_static}:/nginx/admin/static \
-v ${wechat_static}:/nginx/wechat/static \
-v ${upload_root}:/nginx/files";
else
    member_static=$(mkdir -p ../aegis-member/static/dist;  cd ../aegis-member/static/dist; pwd);
    pay_static=$(   mkdir -p ../aegis-pay/frontend/dist;        cd ../aegis-pay/frontend/dist;       pwd);
    site_static=$(  mkdir -p ../aegis-site/src-web/dist;   cd ../aegis-site/src-web/dist;  pwd);
    admin_static=$( mkdir -p ../kitt/admin/src-web/dist;   cd ../kitt/admin/src-web/dist;  pwd);
    wechat_static=$( mkdir -p ../aegis-wechat/src-web/dist; cd ../aegis-wechat/src-web/dist; pwd);
    export create_param="-v ${pwd}/sites-enabled-dev:/etc/nginx/sites-enabled \
-v ${pwd}/deny:/etc/nginx/deny \
-v ${pwd}/logs:/var/log/nginx \
-v ${pwd}/certs:/etc/nginx/certs \
-v ${member_static}:/nginx/member/static \
-v ${pay_static}:/nginx/pay/static \
-v ${site_static}:/nginx/site/static \
-v ${admin_static}:/nginx/admin/static \
-v ${wechat_static}:/nginx/wechat/static \
-v ${upload_root}:/nginx/files";
fi

# 重写mbt!!!!!
mbt_rewrite;
devCreate() {
	touch logs/access.log;
	touch logs/error.log;

	touch logs/jenkins.access.log;
	touch logs/jenkins.error.log;

 	touch logs/site.access.log;
    touch logs/site.error.log;

	touch logs/member.access.log;
    touch logs/member.error.log;

	touch logs/pay.access.log;
    touch logs/pay.error.log;

	touch logs/admin.access.log;
	touch logs/admin.error.log;

    touch logs/wechat.access.log;
    touch logs/wechat.error.log;

	if ! docker run -d --name $container_name --net host $create_param $image_name > /dev/null; then
        echo "ERROR: [docker run -d --name $container_name --net host $create_param $image_name] failed" | color red bold;
        exit -1;
    fi
    echo "$container_name is created" | color green bold;
}
stagingCreate() {
	devCreate;
}
testingCreate() {
	devCreate;
}

local() { echo "ERROR: target not supported" | color red bold; }
debug() { echo "ERROR: target not supported" | color red bold; }

eval $@;


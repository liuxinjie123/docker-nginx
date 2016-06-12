FROM ubuntu-1404

MAINTAINER hary <94093146@qq.com>

# 配置
RUN echo "\n daemon off;" >> /etc/nginx/nginx.conf \
  && chown -R www-data:www-data /var/lib/nginx

# 添加启动脚本
ADD run.sh /run.sh
RUN chmod +x /run.sh

# 添加deny.list:  可覆盖!!!
ADD deny.list /etc/nginx/deny.list

# 配置与日志
VOLUME [ \
	"/etc/nginx/deny.list"  \
	"/etc/nginx/sites-enabled"  \
	"/etc/nginx/certs"  \
	"/etc/nginx/conf.d" \
	"/var/log/nginx" \
]

# 挂载各站点的静态资源
VOLUME [ \
	"/nginx/member/static" \
	"/nginx/site/static" \
	"/nginx/pay/static" \
]

# 上传文件挂载点
VOLUME "/files"  


RUN mkdir -p /nginx/tmp

# 工作目录
WORKDIR /etc/nginx

# 开放端口
EXPOSE 80/tcp 443/tcp

CMD /run.sh


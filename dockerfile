# 第一阶段：构建
FROM alpine:latest AS builder
RUN apk update && \
    apk add --no-cache \
        apache2 \
        apache2-webdav \
        samba \
        bash \
        openrc

# 第二阶段：运行
FROM alpine:latest
COPY --from=builder /usr/sbin/httpd /usr/sbin/httpd
COPY --from=builder /usr/sbin/smbd /usr/sbin/smbd
COPY --from=builder /etc/apache2 /etc/apache2
COPY --from=builder /etc/samba /etc/samba
COPY --from=builder /usr/lib/apache2 /usr/lib/apache2
COPY --from=builder /usr/lib/samba /usr/lib/samba
COPY --from=builder /data/shared /data/shared

# 暴露端口
EXPOSE 80 139 445

# 启动脚本
COPY start.sh /start.sh
RUN chmod +x /start.sh

# 设置环境变量
ENV WEBDAV_USERNAME=admin
ENV WEBDAV_PASSWORD=password
ENV SMB_USERNAME=admin
ENV SMB_PASSWORD=password

# 启动服务
CMD ["/start.sh"]
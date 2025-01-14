#!/bin/bash

# 设置 WebDAV 用户名和密码
htpasswd -cb /etc/apache2/.htpasswd "$WEBDAV_USERNAME" "$WEBDAV_PASSWORD"

# 配置 Apache WebDAV 认证
echo "
<Directory "/var/www/localhost/htdocs">
    AuthType Basic
    AuthName 'WebDAV'
    AuthUserFile /etc/apache2/.htpasswd
    Require valid-user
</Directory>
" >> /etc/apache2/httpd.conf

# 启动 Apache
httpd -D FOREGROUND &

# 添加 Samba 用户
echo -e "$SMB_PASSWORD\n$SMB_PASSWORD" | smbpasswd -a -s "$SMB_USERNAME"

# 启动 Samba
smbd -D --no-process-group

# 保持容器运行
tail -f /dev/null
#!/usr/bin/env bash
# 在全新 Ubuntu 22.04/24.04 服务器上一键部署课堂助教（需 root 运行）
# 用法：
#   sudo DOMAIN=你的域名 EMAIL=你的邮箱 ./deploy/setup.sh
# 脚本会交互式要你输入 AI_API_KEY 和 浏览器访问密码。
#
# 前提：
#   1) 代码已 clone 到 /opt/classroom（或先把 REPO 变量改好）
#   2) 域名 DNS 的 A 记录已指向本机公网 IP

set -euo pipefail

DOMAIN="${DOMAIN:?请设置环境变量 DOMAIN=你的域名}"
EMAIL="${EMAIL:?请设置环境变量 EMAIL=你的邮箱}"
REPO="${REPO:-/opt/classroom}"
APP_DIR="$REPO/学习者记忆库/语音课程"

echo "==> 部署参数: DOMAIN=$DOMAIN  REPO=$REPO"

# 1) 安装依赖
apt-get update
apt-get install -y nginx certbot python3-certbot-nginx python3

# 2) 准备目录与权限（服务以 www-data 运行，需要能写 课堂记录）
chown -R www-data:www-data "$REPO"
mkdir -p /var/www/classroom
chown -R www-data:www-data /var/www/classroom

# 3) 写 .env（含 AI key，仅 root/www-data 可读）
if [ ! -f "$REPO/.env" ]; then
    echo "==> 请输入你的 AI_API_KEY（api.985la.cn 的 key）："
    read -rs AI_KEY
    echo
    cat > "$REPO/.env" <<EOF
AI_API_KEY=$AI_KEY
AI_MODEL=gpt-5.5
AI_BASE_URL=https://api.985la.cn
AI_TIMEOUT_SECONDS=90
EOF
    chmod 600 "$REPO/.env"
    chown root:root "$REPO/.env"
    echo "==> .env 已写入 $REPO/.env"
fi

# 4) 安装 systemd 服务
cp "$REPO/deploy/classroom.service" /etc/systemd/system/classroom.service
systemctl daemon-reload
systemctl enable classroom.service
systemctl restart classroom.service
echo "==> 服务状态："; systemctl is-active classroom.service

# 5) nginx 反代（替换占位域名）+ 基础访问密码
cp "$REPO/deploy/nginx-classroom.conf" /etc/nginx/sites-available/classroom.conf
sed -i "s/__DOMAIN__/$DOMAIN/g" /etc/nginx/sites-available/classroom.conf
ln -sf /etc/nginx/sites-available/classroom.conf /etc/nginx/sites-enabled/classroom.conf
rm -f /etc/nginx/sites-enabled/default

echo "==> 设置浏览器访问密码（别人打开你的域名时要输入）："
htpasswd -c /etc/nginx/classroom.htpasswd classroom
chown root:www-data /etc/nginx/classroom.htpasswd
chmod 640 /etc/nginx/classroom.htpasswd

nginx -t
systemctl reload nginx

# 6) 申请 HTTPS 证书（Let's Encrypt 免费）
certbot --nginx -d "$DOMAIN" --non-interactive --agree-tos -m "$EMAIL" --redirect
systemctl reload nginx

echo
echo "=================================================="
echo "部署完成！打开 https://$DOMAIN 即可使用（输入刚才设的访问密码）。"
echo "查看服务日志：sudo journalctl -u classroom.service -f"
echo "=================================================="

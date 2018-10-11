#!/bin/sh
export PATH='/etc/storage/bin:/tmp/script:/etc/storage/script:/opt/usr/sbin:/opt/usr/bin:/opt/sbin:/opt/bin:/usr/local/sbin:/usr/sbin:/usr/bin:/sbin:/bin'
export LD_LIBRARY_PATH=/lib:/opt/lib
killall frpc frps
mkdir -p /tmp/frp
#启动frp功能后会运行以下脚本
#frp项目地址教程: https://github.com/fatedier/frp/blob/master/README_zh.md
#请自行修改 token 用于对客户端连接进行身份验证
# IP查询： http://119.29.29.29/d?dn=github.com

cat > "/tmp/frp/myfrpc.ini" <<-\EOF
# ==========客户端配置：==========
[common]
server_addr = yourdomain.com
server_port = 7000
token = 998877


#v2ray-ss
[kx]
type = tcp
local_ip = 192.168.123.1
local_port = 55520
remote_port = 55520
use_encryption = true

#v2ray-tcp
[ccv]
type = tcp
local_ip = 192.168.123.1
local_port = 55501
remote_port = 55501
use_encryption = true

#v2ray-ws+tls
[l0ls]
type = tcp
local_ip = 192.168.123.1
local_port = 55502
remote_port = 55502
use_encryption = true

#v2ray-h2+tls
[o8l]
type = tcp
local_ip = 192.168.123.1
local_port = 55503
remote_port = 55503
use_encryption = true

##v2ray-kcp+utp
[kk]
type = udp
local_ip = 192.168.123.1
local_port = 55511
remote_port = 55511

#日志
log_file = /dev/null
log_level = info
log_max_days = 3

EOF

#请手动配置【外部网络 (WAN) - 端口转发 (UPnP)】开启 WAN 外网端口
cat > "/tmp/frp/myfrps.ini" <<-\EOF
# ==========服务端配置：==========
[common]
bind_port = 7000
dashboard_port = 7500
# dashboard 用户名密码，默认都为 admin
dashboard_user = admin
dashboard_pwd = admin
vhost_http_port = 88
token = 12345
subdomain_host = frps.com
max_pool_count = 50
log_file = /dev/null
log_level = info
log_max_days = 3
# ====================
EOF

#启动：
frpc_enable=`nvram get frpc_enable`
frpc_enable=${frpc_enable:-"0"}
frps_enable=`nvram get frps_enable`
frps_enable=${frps_enable:-"0"}
if [ "$frpc_enable" = "1" ] ; then
    frpc -c /tmp/frp/myfrpc.ini 2>&1 &
fi
if [ "$frps_enable" = "1" ] ; then
    frps -c /tmp/frp/myfrps.ini 2>&1 &
fi


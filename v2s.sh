#!/bin/sh
#开启 ipv6 v2ray server
logger -t "【v2s.sh】" "★关闭v2ray服务端" && echo "★关闭v2ray 服务端"
#手动去github下载v2ray的主程序压缩包，解压后把所有文件放到硬盘/media/AiDisk_a1/v2ray/目录里即可。为了不与路由器opt内的v2ray主程序冲突，已把硬盘里的v2ray主程序文件名改为“v2”。
cd /media/AiDisk_a1/v2ray/
#设置v2主程序文件权限
chmod 0777 v2 && chmod 0777 v2ctl
#关闭v2主程序
killall v2
echo " "

logger -t "【v2s.sh】" "正在下载服务端配置文件..." && echo "★正在下载服务端配置文件..."
curl -s -k https://raw.githubusercontent.com/testiknn/test/master/v2s.json > /etc/storage/v2s.json
time=`cat /etc/storage/v2s.json | grep 【 | awk -F// '{print $2}'`
logger -t "【v2s.sh】" " ✔配置文件版本$time"  && echo -e "   ✔配置文件版本\e[1;32m$time\e[0m"
echo " "

logger -t "【v2s.sh】" "打开对应ipv6防火墙端口 " && echo "★打开对应ipv6防火墙端口..."
#如ipv4的话，把“ip6tables”改为“iptables”即可。
#删除端口
ip6tables -D INPUT -p tcp --dport  55501:55520 -j ACCEPT
ip6tables -D INPUT -p udp --dport  55501:55520 -j ACCEPT
#打开防火墙端口
ip6tables -I INPUT -p tcp --dport  55501:55520 -j ACCEPT
ip6tables -I INPUT -p udp --dport  55501:55520 -j ACCEPT
echo "查看防火墙ip6tables端口："
ip6tables -nL | grep 555*
echo " "

logger -t "【v2s.sh】" "启动v2ray server 主程序 " && echo "★启动v2ray servers 主程序... "
/media/AiDisk_a1/v2ray/v2 -config=/etc/storage/v2s.json &
sleep 3
echo "查看v2网络监听端口："
netstat -anp | grep v2
echo " "


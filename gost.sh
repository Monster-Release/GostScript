#!/bin/bash

# function area

viewTunnel(){
echo "下面是正在运行中的隧道:"
ps -ef | grep "gost" | grep -v "$0" | grep -v "grep"
echo -e "\033[32m----------------------------\033[0m"
echo -e "1.停止 运行中的隧道"
echo -e "2.返回 主菜单"
echo -e "3.退出 本脚本!"
echo -e "\033[32m----------------------------\033[0m"
echo -e "你的选择[1-3]："
read tstunnel
case $tstunnel in 
1) 
    stopTunnel
    ;;
2) 
    Menu
    ;;
3)
    echo "你选择了退出脚本"
    exit 1
    ;;
*) 
    echo "输入错误！"
    exit 1
    ;;
esac
}

stopTunnel(){
while :
do
echo "请输入要停止的隧道PID：(Ctrl+C退出)"
read id
kill -9 $id
echo "成功停止PID为 $id 的隧道！"
Menu
done
}

downGost(){
        `reset`
        echo -e "\033[33m你选择了下载Gost\n\033[0m\033[31m本操作需要wget支持\n\033[0m"

        echo -e "\033[33m0.下载amd64 VPS版Gost二进制文件\n\033[0m"
        echo -e "\033[33m1.下载arm v7版Gost二进制文件(树莓派等)\n\033[0m"
        echo -e "\033[33m2.返回主菜单！\n\033[0m"

        echo -e "\033[33m你的选择！[0-2]：\c\033[0m"

        read chss

        if [ $chss = "0" ]
        then
                `wget https://github.com/ginuerzh/gost/releases/download/v2.11.0/gost-linux-amd64-2.11.0.gz`
                `gunzip gost-linux-amd64-2.11.0.gz`
                `mv gost-linux-amd64-2.11.0 gost`
                `chmod +x gost`
                echo "\033[33mgost 2.11.0 amd64 下载成功，且已经解压、赋权，改名为 gost，脚本退出\033[0m"
        elif [ $chss = "1" ]
        then
                `wget https://github.com/ginuerzh/gost/releases/download/v2.11.0/gost-linux-armv7-2.11.0.gz`
                `gunzip gost-linux-armv7-2.11.0.gz`
                `mv gost-linux-armv7-2.11.0 gost`
                `chmod +x gost`
                echo "\033[33mgost 2.11.0 armv7 下载成功，且已经解压、赋权，改名为 gost，脚本退出\033[0m"
        elif [ $chss = "2" ]
        then
                Menu
        else
                echo "输入错误，脚本退出"
                exit 1
        fi
    Menu
}

setClient(){

        tunnelType="ws"
        clientPort="23333"
        tunnelPort="80"
        serviceAddr="192.168.1.1"
        servicePort="443"

        `reset`

        echo -e "\033[33m你选择了配置Gost客户端！\n\033[0m"

        echo -e "请先选择一个基础隧道协议："
                
        echo -e "\033[33m1.ws (WebSocket)\n\033[0m"
        echo -e "\033[33m2.wss (Secured WebSocket)\n\033[0m"
        echo -e "\033[33m3.tls\n\033[0m"
        echo -e "\033[33m4.h2 (http2)\n\033[0m"
        echo -e "\033[33m5.socks5\n\033[0m"
        echo -e "\033[33m6.ssh\n\033[0m"
        echo -e "\033[33m7.返回主菜单！\n\033[0m"

        echo -e "\033[33m撒，你的选择！[1-7]：\c\033[0m"
        read chss2

        if [ $chss2 = "1" ]
        then
            tunnelType="ws"
        elif [ $chss2 = "2" ]
        then
            tunnelType="wss"
        elif [ $chss2 = "3" ]
        then
            tunnelType="tls"
        elif [ $chss2 = "4" ]
        then
            tunnelType="h2"
        elif [ $chss2 = "5" ]
        then
            tunnelType="socks5"
        elif [ $chss2 = "6" ]
        then
            tunnelType="ssh"
        elif [ $chss2 = "7" ]
        then
            Menu
        fi

        echo -e "\033[33m\n现在请输入本地隧道服务端口\n在小火箭等客户端连接的端口：\c\033[0m"
        read clientPort

        echo -e "\033[33m\n现在请输入你要转发到的远程服务的地址\n国外运行了ssr的服务器地址：\c\033[0m"
        read serviceAddr

        echo -e "\033[33m\n现在请输入你要转发的远程服务的端口\n例如你有一个ssr运行在250端口，那么填250：\c\033[0m"
        read servicePort

        echo -e "\033[33m\n现在请输入隧道传输端口\n国内服务器将流量通过该端口转发到国外服务器：\c\033[0m"
        read tunnelPort

        echo "是否在基础隧道协议基础上添加relay协议？[Y/N]"
        read chss_relay
        if [ $chss_relay = "Y" -o $chss_relay = "y" ]
        then
            echo -e "\033[33m\n你选择了relay+基础隧道协议的模式！\n\033[0m"
            echo -e "\033[33m隧道参数如下：\n隧道类型：relay+${tunnelType}\n本地隧道服务端口：${clientPort}\n远程服务地址：${serviceAddr}\n远程服务端口：${servicePort}\n隧道传输端口：${tunnelPort}\n\033[0m"
            cmd="nohup ./gost -L=tcp://:"${clientPort}"/"${serviceAddr}":"${servicePort}" -L=udp://:"${clientPort}"/"${serviceAddr}":"${servicePort}" -F="relay+${tunnelType}"://"${serviceAddr}":"${tunnelPort}" >1.log 2>&1 & "
            echo -e "$cmd\n"
            eval $cmd
            echo -e "\033[33m\n客户端隧道部署成功！\n\033[0m"
        else
            echo "\033[33m你选择了基础隧道协议的模式！\033[0m"
            echo -e "\033[33m隧道参数如下：\n隧道类型：${tunnelType}\n本地隧道服务端口：${clientPort}\n远程服务地址：${serviceAddr}\n远程服务端口：${servicePort}\n隧道传输端口：${tunnelPort}\n\033[0m"
            cmd="nohup ./gost -L=:"${clientPort}"/:"${servicePort}" -F="${tunnelType}"://"${serviceAddr}":"${servicePort}" >1.log 2>&1 &"
            echo -e "$cmd\n"
            eval $cmd
            echo -e "\033[33m\n客户端隧道部署成功！\n\033[0m"
        fi

        echo -e "\n\033[33m是否加入开机自启动？\n\033[31m（只保证CentOS7有效，且此行为会使得开机自启动文件完全重置，请小心决定！）\n\033[33m[Y/N]：\033[0m\c"

        read YYNN

        if [ $YYNN = "Y" -o $YYNN = "y" ]
        then
            echo -e "\033[33m\n加入开机自启动!\n\033[0m"
            `rm -f /etc/rc.d/rc.local`
            echo "${cmd}" > /etc/rc.d/rc.local
            `chmod +x /etc/rc.d/rc.local`
        else
            echo -e "\033[33m \n您选择了开机不自动启动该隧道！\n \033[0m"
        fi
    Menu
}

setServer(){
        tunnelType="ws"
        tunnelPort="80"

        `reset`

        echo -e "\033[33m你选择了配置Gost服务端！\n\033[0m"

        echo -e "请先选择一个基础隧道协议："
                
        echo -e "\033[33m1.ws (WebSocket)\n\033[0m"
        echo -e "\033[33m2.wss (Secured WebSocket)\n\033[0m"
        echo -e "\033[33m3.tls\n\033[0m"
        echo -e "\033[33m4.h2 (http2)\n\033[0m"
        echo -e "\033[33m5.socks5\n\033[0m"
        echo -e "\033[33m6.ssh\n\033[0m"
        echo -e "\033[33m7.返回主菜单！\n\033[0m"

        echo -e "\033[33m撒，你的选择！[1-7]：\c\033[0m"
        read chss2

        if [ $chss2 = "1" ]
        then
            tunnelType="ws"
        elif [ $chss2 = "2" ]
        then
            tunnelType="wss"
        elif [ $chss2 = "3" ]
        then
            tunnelType="tls"
        elif [ $chss2 = "4" ]
        then
            tunnelType="h2"
        elif [ $chss2 = "5" ]
        then
            tunnelType="socks5"
        elif [ $chss2 = "6" ]
        then
            tunnelType="ssh"
        elif [ $chss2 = "7" ]
        then
            Menu
        fi

        echo -e "\033[33m\n现在请输入隧道传输端口\n接收来自国内隧道客户端的流量：\c\033[0m"
        read tunnelPort

        echo "是否在基础隧道协议基础上添加relay协议？[Y/N]"
        read chss_relay
        if [ $chss_relay = "Y" -o $chss_relay = "y" ]
        then
            echo -e "\033[33m\n你选择了relay+基础隧道协议的模式！\n\033[0m"
            echo -e "\033[33m隧道参数如下：\n隧道传输端口：${tunnelPort}\n隧道类型：relay+${tunnelType}\n\033[0m"
            cmd="nohup ./gost -L="relay+${tunnelType}"://:"${tunnelPort}" >1.log 2>&1 &"
            echo -e "$cmd\n"
            eval $cmd
            echo -e "\033[33m\n服务端端隧道部署成功！\n\033[0m"
        else
            echo "\033[33m你选择了基础隧道协议的模式！\033[0m"
            echo -e "\033[33m隧道参数如下：\n隧道传输端口：${tunnelPort}\n隧道类型：${tunnelType}\n\033[0m"
            cmd="nohup ./gost -L="${tunnelType}"://:"${tunnelPort}" >1.log 2>&1 &"
            echo -e "$cmd\n"
            eval $cmd
            echo -e "\033[33m\n服务端隧道部署成功！\n\033[0m"
        fi

        echo -e "\n\033[33m是否加入开机自启动？\n\033[31m（只保证CentOS7有效，且此行为会使得开机自启动文件完全重置，请小心决定！）\n\033[33m[Y/N]：\033[0m\c"

        read YYNN

        if [ $YYNN = "Y" -o $YYNN = "y" ]
        then
            echo -e "\033[33m\n加入开机自启动!\n\033[0m"
            `rm -f /etc/rc.d/rc.local`
            echo "${cmd}" > /etc/rc.d/rc.local
            `chmod +x /etc/rc.d/rc.local`
        else
            echo -e "\033[33m \n您选择了开机不自动启动该隧道！\n \033[0m"
        fi
    Menu
}

Menu(){
`reset`

echo -e "\033[32m--------------------------------------------------------------\033[0m"

echo -e "\033[33m欢迎使用HelloWorld-create的GOST脚本\033[0m"
echo -e "\033[33m本脚本旨在为大家快速部署安全隧道,请勿用于违法行为\033[0m"
echo -e "\033[33m联系作者：HelloWorld-create\033[0m"

echo -e "\033[32m--------------------------------------------------------------\033[0m"

echo -e "\033[33m0.下载并解压gost二进制文件(wget本脚本时已经默认下载了gost二进制文件)\n\033[0m"
echo -e "\033[33m1.配置 客户端\n\033[0m"
echo -e "\033[33m2.配置 服务端\n\033[0m"
echo -e "\033[33m3.查看 运行的隧道\n\033[0m"
echo -e "\033[33m4.停止 运行中的隧道\n\033[0m"
echo -e "\033[33m5.退出脚本\n\033[0m"

echo -e "\033[33m我的选择[0-5]：(Ctrl+C退出)\033[0m\c"
read chs


if [ $chs = "0" ]
then
        downGost
elif [ $chs = "1" ]
then
        setClient
elif [ $chs = "2" ]
then
        setServer
elif [ $chs = "3" ]
then
        viewTunnel
elif [ $chs = "4" ]
then
        stopTunnel
elif [ $chs = "5" ]
then
        exit 1
else
        echo "错误输入，脚本结束"
fi
}

# function area end

Menu

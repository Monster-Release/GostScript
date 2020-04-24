#!/bin/bash

# function area

viewTunnel(){
echo "下面是正在运行中的隧道:"
ps -ef | grep "gost" | grep -v "$0" | grep -v "grep"
echo -e "\033[32m----------------------------\033[0m"
echo -e "\033[32m1.停止 运行中的隧道\033[0m"
echo -e "\033[32m2.返回 主菜单\033[0m"
echo -e "\033[32m3.退出 本程序\033[0m"
echo -e "\033[32m----------------------------\033[0m"
echo -n "你的选择[1-3]："
read tstunnel
echo -e ""
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
echo -n "请输入要停止的隧道PID (CTRL+C退出)："
read id
kill -9 $id
Menu
echo -e "成功停止PID为 $id 的隧道！"
done
}

downGost(){
        `reset`
        echo -e "\033[33m你选择了下载Gost\n\033[0m\033[31m本操作需要wget支持\n\033[0m"

        echo -e "\033[33m0.下载amd64 VPS版Gost二进制文件\n\033[0m"
        echo -e "\033[33m1.下载arm v7版Gost二进制文件(树莓派等)\n\033[0m"
        echo -e "\033[33m2.返回主菜单！\n\033[0m"

        echo -n "你的选择！[0-2]："

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

choiceBaseType(){

        echo -e "请先选择一个基础隧道传输协议："

        echo -e "\033[33m1.ws\n\033[0m"
        echo -e "\033[33m2.mws\n\033[0m"
        echo -e "\033[33m3.wss\n\033[0m"
        echo -e "\033[33m4.mwss\n\033[0m"
        echo -e "\033[33m5.tls\n\033[0m"
        echo -e "\033[33m6.mtls\n\033[0m"
        echo -e "\033[33m7.kcp\n\033[0m"
        echo -e "\033[33m8.返回主菜单！\n\033[0m"

        echo -n "你的选择！[1-16]："
        read chss2

        case $chss2 in
        1)
        tunnelType="ws"
        ;;
        2)
        tunnelType="mws"
        ;;
        3)
        tunnelType="wss"
        ;;
        4)
        tunnelType="mwss"
        ;;
        5)
        tunnelType="tls"
        ;;
        6)
        tunnelType="mtls"
        ;;
        7)
        tunnelType="kcp"
        ;;
        8)
        Menu
        ;;
        *)
        echo -e "输入错误，返回主菜单！"
        Menu
        ;;
        esac

}

choiceCilentEndType(){

        echo -e "1.选择基础协议仅支持tcp模式!"
        echo -e "2.选择基础协议支持tcp和udp over tcp模式！"
        echo -e "3.选择基础协议支持tcp和udp over tcp并且附加relay模式！"
        echo -n "你的选择[1-3]："
        read chss_tunnel

        case $chss_tunnel in
        1)
        echo "\033[33m你选择了基础协议仅支持tcp模式！\033[0m"
        echo -e "\033[33m隧道参数如下：\n隧道类型：${tunnelType}\n本地隧道服务端口：${clientPort}\n远程服务地址：${serviceAddr}\n远程服务端口：${servicePort}\n隧道传输端口：${tunnelPort}\n\033[0m"
        cmd="nohup ./gost -L=:"${clientPort}"/:"${servicePort}" -F="${tunnelType}"://"${serviceAddr}":"${servicePort}" >1.log 2>&1 &"
        echo -e "$cmd\n"
        eval $cmd
        echo -e "\033[33m\n客户端隧道部署成功！\n\033[0m"
        ;;
        2)
        echo -e "\003[33m2.选择基础协议支持tcp和udp over tcp模式！\n\033[0m"
        echo -e "\033[33m隧道参数如下：\n隧道类型：${tunnelType}\n本地隧道服务端口：${clientPort}\n远程服务地址：${serviceAddr}\n远程服务端口：${servicePort}\n隧道传输端口：${tunnelPort}\n\033[0m"
        cmd="nohup ./gost -L=tcp://:"${clientPort}"/"${serviceAddr}":"${servicePort}" -L=udp://:"${clientPort}"/"${serviceAddr}":"${servicePort}" -F="${tunnelType}"://"${serviceAddr}":"${tunnelPort}" >1.log 2>&1 & "
        echo -e "$cmd\n"
        eval $cmd
        echo -e "\033[33m\n客户端隧道部署成功！\n\033[0m"
        ;;
        3)
        echo -e "\003[33m3.选择基础协议支持tcp和udp over tcp并且附加relay模式！\n\033[0m"
        echo -e "\033[33m隧道参数如下：\n隧道类型：relay+${tunnelType}\n本地隧道服务端口：${clientPort}\n远程服务地址：${serviceAddr}\n远程服务端口：${servicePort}\n隧道传输端口：${tunnelPort}\n\033[0m"
        cmd="nohup ./gost -L=tcp://:"${clientPort}"/"${serviceAddr}":"${servicePort}" -L=udp://:"${clientPort}"/"${serviceAddr}":"${servicePort}" -F="relay+${tunnelType}"://"${serviceAddr}":"${tunnelPort}" >1.log 2>&1 & "
        echo -e "$cmd\n"
        eval $cmd
        echo -e "\033[33m\n客户端隧道部署成功！\n\033[0m"
        ;;
        *)
        echo -e "输入错误请重新输入脚本退出)"
        exit 1
        ;;
        esac

}

choiceServerEndType(){
        echo -e "\033[33m1.选择基础隧道协议并附加relay协议\n\033[0m"
        echo -e "\033[33m2.仅选择基础隧道协议\n\033[0m"
        echo -n "你的选择[1-2]："
        read chss_relay 

        case $chss_relay in
        1)
        echo -e "\033[33m\n你选择了relay+基础隧道协议的模式！\n\033[0m"
        echo -e "\033[33m隧道参数如下：\n隧道传输端口：${tunnelPort}\n隧道类型：relay+${tunnelType}\n\033[0m"
        cmd="nohup ./gost -L="relay+${tunnelType}"://:"${tunnelPort}" >1.log 2>&1 &"
        echo -e "$cmd\n"
        eval $cmd
        echo -e "\033[33m\n服务端端隧道部署成功！\n\033[0m"
        ;;
        2)
        echo "\033[33m你选择了基础隧道协议的模式！\033[0m"
        echo -e "\033[33m隧道参数如下：\n隧道传输端口：${tunnelPort}\n隧道类型：${tunnelType}\n\033[0m"
        cmd="nohup ./gost -L="${tunnelType}"://:"${tunnelPort}" >1.log 2>&1 &"
        echo -e "$cmd\n"
        eval $cmd
        echo -e "\033[33m\n服务端隧道部署成功！\n\033[0m"
        ;;
        *)
        echo -e "输入错误请重新输入脚本退出)"
        exit 1
        ;;
        esac
}

startOnUp(){

    echo -e "\033[33m是否配置开机自动启动？仅在cetos7测试通过，该选项会完全改变启动配置文件，请谨慎选择！[Y/N]: \033[0m"
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
}

setClient(){

        tunnelType="ws"
        clientPort="80"
        tunnelPort="80"
        serviceAddr="250.250.250.250"
        servicePort="443"

        `reset`

        echo -e "\033[33m你选择了配置Gost客户端！\n\c\033[0m"

        echo -e "\033[33m\n请输入本地隧道服务端口（小火箭等客户端连接的端口）：\c\033[0m"
        read clientPort
        echo -e "\033[33m\n请输入远程服务器的地址（国外运行了ssr的服务器的地址）：\c\033[0m"
        read serviceAddr
        echo -e "\033[33m\n请输入远程服务器的代理服务端口（国外服务器运行的ssr监听的端口：）：\c\033[0m"
        read servicePort
        echo -e "\033[33m\n现在请输入远程服务端隧道传输端口（国外服务器隧道服务端监听端口）：\c\033[0m"
        read tunnelPort

        choiceBaseType
        choiceCilentEndType
        startOnUp
        Menu
}

setServer(){
    tunnelType="ws"
    tunnelPort="80"

    `reset`

    echo -e "\033[33m你选择了配置Gost服务端！\n\c\033[0m"

    echo -e "\033[33m\n现在请输入服务端隧道传输端口（接收来自国内隧道客户端的流量）：\c\033[0m"
    read tunnelPort

    choiceBaseType
    choiceServerEndType
    startOnUp
    Menu
}

Menu(){

        echo -e "\033[32m--------------------------------------------------------------\033[0m"

        echo -e "\033[33m欢迎使用HelloWorld-create的GOST脚本\033[0m"
        echo -e "\033[33m目前支持6中隧道协议，支持relay,支持udp over tcp\033[0m"
        echo -e "\033[33m鸣谢：arloor提供iptables中转代码\033[0m"
        echo -e "\033[33m更多隧道类型支持正在路上！\033[0m"
        echo -e "\033[33m联系作者：HelloWorld-create\033[0m"

        echo -e "\033[32m--------------------------------------------------------------\033[0m"

        echo -e "\033[33m1.下载并解压gost二进制文件(wget本脚本时已经默认下载了gost二进制文件)\n\033[0m"
        echo -e "\033[33m2.配置 客户端\n\033[0m"
        echo -e "\033[33m3.配置 服务端\n\033[0m"
        echo -e "\033[33m4.查看 运行的隧道\n\033[0m"
        echo -e "\033[33m5.查看 隧道转发日志\n\033[0m"
        echo -e "\033[33m6.停止 运行中的隧道\n\033[0m"
        echo -e "\033[33m7.设置 iptables转发\n\033[0m"
        echo -e "\033[33m8.退出脚本\n\033[0m"

        echo -n "你的选择[1-8]："
        read chs

        case $chs in
        1)
        downGost
        ;;
        2)
        setClient
        ;;
        3)
        setServer
        ;;
        4)
        viewTunnel
        ;;
        5)
        cat ./1.log
        ;;
        6)
        stopTunnel
        ;;
        7)
        ./iptables.sh
        ;;
        8)
        exit 1
        ;;
        *)
        echo -n "输入错误请重新输入："
        ;;
        esac
}

# function area end

Menu

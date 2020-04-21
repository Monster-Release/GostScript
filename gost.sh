#!/bin/bash

# function area

stopTunnel(){
# ID=`ps -ef | grep "gost" | grep -v "$0" | grep -v "grep" | awk '{print $2}'`
# for id in $ID
# do
contu=Y
while [ $contu = "Y" ]
do
echo -e "请输入要停止的隧道PID："
read ID
kill -9 $ID
echo "成功停止PID为 $id 的隧道！"
echo "是否继续停止隧道？ [Y/N]"
read contu
done
# done
}

viewTunnel(){
echo "下面是正在运行中的隧道:"
ps -ef | grep "gost" | grep -v "$0" | grep -v "grep"
}

downGost(){
        `reset`
        echo -e "\033[33m你选择了下载Gost\n\033[0m\033[31m注意哦，本操作需要有wget，没有的话提示成功也是失败的哦\n\033[0m"

        echo -e "\033[33m0.我是amd64的VPS，选这个下载\n\033[0m"
        echo -e "\033[33m1.我是arm v7的设备，如树莓派，选此下载\n\033[0m"
        echo -e "\033[33m2.现在退出还来得及！\n\033[0m"

        echo -e "\033[33m撒，你的选择！[0-2]：\c\033[0m"

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
                exit 1
        else
                echo "输入错误，脚本退出"
                exit 1
        fi
}

setClient(){

        tunnelType="ws"
        clientPort="250"
        tunnelPort="80"
        serviceAddr="192.168.1.1"
        servicePort="443"

        `reset`

        echo -e "\033[33m你选择了配置Gost客户端\n\n现在请选择想要部署的隧道（支持tcp和udp over tcp）\033[0m"

        echo -e "\033[33m是否配置relay+其他协议的模式? [Y/N]\n\033[0m"
        read chss_relay
        if [ $chss_relay = "Y" ] 
        then
                echo -e "选择一个搭配relay的协议"
                echo -e "\033[33m0.relay+ws (WebSocket)\n\033[0m"
                echo -e "\033[33m1.relay+wss (Secured WebSocket)\n\033[0m"
                echo -e "\033[33m2.relay+tls\n\033[0m"
                echo -e "\033[33m3.relay+h2 (http2)\n\033[0m"
                echo -e "\033[33m4.relay+ssh\n\033[0m"
                echo -e "\033[33m5.relay+socks5\n\033[0m"
                echo -e "\033[33m6.现在退出还来得及！\n\033[0m"

                echo -e "\033[33m撒，你的选择！[0-6]：\c\033[0m"

                read chss1

                if [ $chss1 = "0" ]
                then
                        tunnelType="relay+ws"
                elif [ $chss1 = "1" ]
                then
                        tunnelType="relay+wss"
                elif [ $chss1 = "2" ]
                then
                        tunnelType="relay+tls"
                elif [ $chss1 = "3" ]
                then
                        tunnelType="relay+h2"
                elif [ $chss1 = "4" ]
                then
                        tunnelType="relay+ssh"
                elif [ $chss1 = "5" ]
                then
                        tunnelType="relay+socks5"
                elif [ $chss1 = "6" ]
                then
                        echo "脚本退出"
                        exit 1
                fi
        else
                echo -e "选择一个隧道协议"
                echo -e "\033[33m7.ws (WebSocket)\n\033[0m"
                echo -e "\033[33m8.wss (Secured WebSocket)\n\033[0m"
                echo -e "\033[33m9.tls\n\033[0m"
                echo -e "\033[33m10.h2 (http2)\n\033[0m"
                echo -e "\033[33m11.ssh\n\033[0m"
                echo -e "\033[33m12.socks5\n\033[0m"
                echo -e "\033[33m13.现在退出还来得及！\n\033[0m"

                echo -e "\033[33m撒，你的选择！[7-13]：\c\033[0m"
                read chss2

                if [ $chss2 = "7" ]
                then
                        tunnelType="ws"
                elif [ $chss2 = "8" ]
                then
                        tunnelType="wss"
                elif [ $chss2 = "9" ]
                then
                        tunnelType="tls"
                elif [ $chss2 = "10" ]
                then
                        tunnelType="h2"
                elif [ $chss2 = "11" ]
                then
                        tunnelType="ssh"
                elif [ $chss2 = "12" ]
                then
                        tunnelType="socks5"
                elif [ $chss2 = "13" ]
                then
                        echo "脚本退出"
                        exit 1
                fi
        fi

        echo -e "\033[33m\n现在请输入本地隧道服务端口(在小火箭等客户端连接的端口)：\c\033[0m"
        read clientPort

        echo -e "\033[33m\n现在请输入你要转发到的远程服务的地址,也就是国外运行了ssr的服务器地址：\c\033[0m"
        read serviceAddr

        echo -e "\033[33m\n现在请输入你要转发到的远程服务的端口\n例如你有一个ssr运行在1234端口，那么填1234：\c\033[0m"
        read servicePort

        echo -e "\033[33m\n现在请输入隧道传输端口\n国内服务器将流量通过该端口转发到国外服务器：\c\033[0m"
        read tunnelPort

        echo -e "\033[33m\n所有的条件都集齐了！\n请确认：\n隧道类型：${tunnelType}\n本地隧道服务端口：${clientPort}\n远程服务地址：${serviceAddr}\n远程服务端口：${servicePort}\n隧道传输端口：${tunnelPort}\n\033[0m"

        echo -e "\033[33m是否确认？（否定将退出脚本）[Y/N]：\c\033[0m"

        read YorN

        if [ $YorN = "Y" ]
        then
                echo -e "\033[33m\n确认了！\n\033[0m"

                cmd="nohup ./gost -L=tcp://:"${clientPort}"/"${serviceAddr}":"${servicePort}" -L=udp://:"${clientPort}"/"${serviceAddr}":"${servicePort}" -F="${tunnelType}"://"${serviceAddr}":"${tunnelPort}" >1.log 2>&1 & "
                echo -e "$cmd\n"
                eval $cmd

                echo -e "\033[33m\n后台执行成功！\n\033[0m"
        else
                echo "\033[33m脚本退出\033[0m"
                exit 1
        fi

        echo -e "\n\033[33m是否加入开机自启动？\n\033[31m（只保证CentOS7有效，且此行为会使得开机自启动文件完全重置，请小心决定）\n\033[33m[Y/N]：\033[0m\c"

        read YYNN

        if [ $YYNN = "Y" ]
        then
                echo -e "\033[33m\n加入开机自启动!\n\033[0m"
                `rm -f /etc/rc.d/rc.local`
                echo "${cmd}" > /etc/rc.d/rc.local
                `chmod +x /etc/rc.d/rc.local`
        else
                echo -e "\033[33m \nヾ(￣▽￣)Bye~Bye~\n \033[0m"
        fi
}

setServer(){
        tunnelType="ws"
        tunnelPort="80"

        `reset`

        echo -e "\033[33m你选择了配置Gost服务端\n\n现在请选择想要部署的隧道（支持tcp和udp over tcp）\033[0m"
        echo -e "是否配置\033[33m0.relay+其他协议\n\033[0m的模式？[Y/N]："
        read chss_relay
        if [ $chss_relay = "Y" ]
        then
                echo -e "选择一个搭配relay的协议"
                echo -e "\033[33m0.relay+ws (WebSocket)\n\033[0m"
                echo -e "\033[33m1.relay+wss (Secured WebSocket)\n\033[0m"
                echo -e "\033[33m2.relay+tls\n\033[0m"
                echo -e "\033[33m3.relay+h2 (http2)\n\033[0m"
                echo -e "\033[33m4.relay+ssh\n\033[0m"
                echo -e "\033[33m5.relay+socks5\n\033[0m"
                echo -e "\033[33m6.现在退出还来得及！\n\033[0m"

                echo -e "\033[33m撒，你的选择！[0-6]：\c\033[0m"

                read chss1

                if [ $chss1 = "0" ]
                then
                        tunnelType="relay+ws"
                elif [ $chss1 = "1" ]
                then
                        tunnelType="relay+wss"
                elif [ $chss1 = "2" ]
                then
                        tunnelType="relay+tls"
                elif [ $chss1 = "3" ]
                then
                        tunnelType="relay+h2"
                elif [ $chss1 = "4" ]
                then
                        tunnelType="relay+ssh"
                elif [ $chss1 = "5" ]
                then
                        tunnelType="relay+socks5"
                elif [ $chss1 = "6" ]
                then
                        echo "脚本退出"
                        exit 1
                fi
        else
                echo -e "选择一个隧道协议"
                echo -e "\033[33m7.ws (WebSocket)\n\033[0m"
                echo -e "\033[33m8.wss (Secured WebSocket)\n\033[0m"
                echo -e "\033[33m9.tls\n\033[0m"
                echo -e "\033[33m10.h2 (http2)\n\033[0m"
                echo -e "\033[33m11.ssh\n\033[0m"
                echo -e "\033[33m12.socks5\n\033[0m"
                echo -e "\033[33m13.现在退出还来得及！\n\033[0m"

                echo -e "\033[33m撒，你的选择！[7-13]：\c\033[0m"
                read chss2

                if [ $chss2 = "7" ]
                then
                        tunnelType="ws"
                elif [ $chss2 = "8" ]
                then
                        tunnelType="wss"
                elif [ $chss2 = "9" ]
                then
                        tunnelType="tls"
                elif [ $chss2 = "10" ]
                then
                        tunnelType="h2"
                elif [ $chss2 = "11" ]
                then
                        tunnelType="ssh"
                elif [ $chss2 = "12" ]
                then
                        tunnelType="socks5"
                elif [ $chss2 = "13" ]
                then
                        echo "脚本退出"
                        exit 1
                fi
        fi

        echo -e "\033[33m输入隧道的传输端口：\c\033[0m"
        read tunnelPort

        echo -e "\033[33m\nこれで全ての条件はクリアされた!!\n所有的条件都集齐了！\n请确认：\n隧道传输端口：${tunnelPort}\n隧道类型：${tunnelType}\n\033[0m"

        echo -e "\033[33m是否确认？（否定将退出脚本）[Y/N]：\c\033[0m"

        read YorN

        if [ $YorN = "Y" ]
        then
                echo -e "\033[33m\n确认了！\n\033[0m"

                cmd="nohup ./gost -L="${tunnelType}"://:"${tunnelPort}" >1.log 2>&1 &"
                echo "服务端隧道命令成功执行！"
                echo -e "$cmd\n"
                eval $cmd

                echo -e "\033[33m\n后台执行成功！\n\033[0m"
        else
                echo -e "\033[33m脚本退出\033[0m"
                exit 1
        fi

        echo -e "\n\033[33m是否加入开机自启动？\n\033[31m（只保证CentOS7有效，且此行为会使得开机自启动文件完全重置，请小心决定）\n\033[33m[Y/N]：\033[0m\c"

        read YYNN

        if [ $YYNN = "Y" ]
        then
                echo -e "\033[33m\n加入开机自启动!\n\033[0m"
                `rm -f /etc/rc.d/rc.local`
                echo "${cmd}" > /etc/rc.d/rc.local
                `chmod +x /etc/rc.d/rc.local`
        else
                echo -e "\033[33m \nヾ(￣▽￣)Bye~Bye~\n\033[0m"
        fi
}

# function area end

`reset`

echo -e "\033[32m--------------------------------------------------------------\033[0m"

echo -e "\033[33m欢迎使用HelloWorld-create的GOST脚本\033[0m"
echo -e "\033[33m本脚本旨在为大家快速部署安全隧道,请勿用于违法行为\033[0m"
echo -e "\033[33m联系作者：HelloWorld-create\033[0m"
echo -e "\033[33m骚扰者一律拉黑\033[0m"

echo -e "\033[32m--------------------------------------------------------------\033[0m"


echo -e "\033[32m请选择今天要做的事\n\033[0m"

echo -e "\033[33m0.下载并解压gost文件在本目录下（如果本目录没有gost请先执行！）\n\033[0m"
echo -e "\033[33m1.配置 客户端\n\033[0m"
echo -e "\033[33m2.配置 服务端\n\033[0m"
echo -e "\033[33m3.查看 运行的隧道\n\033[0m"
echo -e "\033[33m4.停止 运行中的隧道\n\033[0m"
echo -e "\033[33m5.退出脚本\n\033[0m"

echo -e "\033[33m我要选择[0-4]：\033[0m\c"
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

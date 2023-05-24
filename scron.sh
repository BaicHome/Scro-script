#!/bin/bash

# 检测是否已安装 crontab，如未安装，则自动进行安装
if ! command -v crontab &> /dev/null
then
    echo "crontab 未安装，正在自动安装..."
    if command -v apt-get &> /dev/null
    then
        sudo apt-get update
        sudo apt-get install -y cron
    elif command -v yum &> /dev/null
    then
        sudo yum update
        sudo yum install -y cronie
    else
        echo "无法自动安装 crontab，请手动安装后再运行脚本。"
        exit 1
    fi
fi

# 展示 GUI 图形化界面，让用户选择/输入执行时间和需要执行的命令
echo "请选择执行时间："
echo "1. 每分钟"
echo "2. 每3分钟"
echo "3. 每5分钟"
echo "4. 每天0点30分"
echo "5. 每周几"
echo "6. 每月多少号"
read -p "请输入选项（1-6）：" option

case $option in
    1)
        schedule="* * * * *"
        ;;
    2)
        schedule="*/3 * * * *"
        ;;
    3)
        schedule="*/5 * * * *"
        ;;
    4)
        schedule="30 0 * * *"
        ;;
    5)
        read -p "请输入要执行的星期几（0-6，0表示周日）：" weekday
        schedule="* * $weekday * *"
        ;;
    6)
        read -p "请输入要执行的日期（1-31）：" day
        schedule="* * $day * *"
        ;;
    *)
        echo "无效选项，程序退出。"
        exit 1
        ;;
esac

read -p "请输入要执行的 shell 命令：" command

# 将用户选择/输入的信息配置为计划任务定时执行
(crontab -l ; echo "$schedule $command") | crontab -

echo "计划任务已添加。"

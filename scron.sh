#!/bin/bash

# 检测是否已安装crontab
if ! command -v crontab &> /dev/null
then
    echo "Crontab未安装，正在安装..."
    sudo apt-get install cron
fi

# 要求用户选择/输入执行时间和需要执行的shell命令
echo "请选择执行时间："
echo "1. 每分钟"
echo "2. 每小时"
echo "3. 每天"
echo "4. 每周"
echo "5. 每月"
read -p "请选择： " choice

case $choice in
    1)
        time="* * * * *"
        ;;
    2)
        time="0 * * * *"
        ;;
    3)
        read -p "请输入小时数（0-23）：" hour
        read -p "请输入分钟数（0-59）：" minute
        time="$minute $hour * * *"
        ;;
    4)
        echo "请选择星期几："
        echo "1. 星期日"
        echo "2. 星期一"
        echo "3. 星期二"
        echo "4. 星期三"
        echo "5. 星期四"
        echo "6. 星期五"
        echo "7. 星期六"
        read -p "请选择：" day_choice
        case $day_choice in
            1)
                day="0"
                ;;
            2)
                day="1"
                ;;
            3)
                day="2"
                ;;
            4)
                day="3"
                ;;
            5)
                day="4"
                ;;
            6)
                day="5"
                ;;
            7)
                day="6"
                ;;
            *)
                echo "无效的选择"
                exit 1
                ;;
        esac
        read -p "请输入小时数（0-23）：" hour
        read -p "请输入分钟数（0-59）：" minute
        time="$minute $hour * * $day"
        ;;
    5)
        read -p "请输入日期（1-31）：" day
        read -p "请输入小时数（0-23）：" hour
        read -p "请输入分钟数（0-59）：" minute
        time="$minute $hour $day * *"
        ;;
    *)
        echo "无效的选择"
        exit 1
        ;;
esac

read -p "请输入需要执行的shell命令：" command

# 将用户选择/输入的信息配置为计划任务定时执行
(crontab -l ; echo "$time $command") | crontab -
echo "计划任务已添加"

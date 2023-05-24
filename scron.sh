#!/bin/bash

# 检测是否已安装crontab
if ! command -v crontab &> /dev/null
then
    echo "Crontab未安装，正在安装..."
    sudo apt-get install cron
fi

# 显示GUI图形界面，要求用户选择/输入执行时间和需要执行的shell命令
time=$(zenity --list --title="选择执行时间" --text="请选择执行时间" --radiolist --column "选择" --column "时间" TRUE "每分钟" FALSE "每小时" FALSE "每天" FALSE "每周" FALSE "每月")
if [ "$time" = "每分钟" ]
then
    time="* * * * *"
elif [ "$time" = "每小时" ]
then
    time="0 * * * *"
elif [ "$time" = "每天" ]
then
    hour=$(zenity --entry --title="输入小时数" --text="请输入小时数（0-23）")
    minute=$(zenity --entry --title="输入分钟数" --text="请输入分钟数（0-59）")
    time="$minute $hour * * *"
elif [ "$time" = "每周" ]
then
    day=$(zenity --list --title="选择星期几" --text="请选择星期几" --radiolist --column "选择" --column "星期几" TRUE "星期日" FALSE "星期一" FALSE "星期二" FALSE "星期三" FALSE "星期四" FALSE "星期五" FALSE "星期六")
    hour=$(zenity --entry --title="输入小时数" --text="请输入小时数（0-23）")
    minute=$(zenity --entry --title="输入分钟数" --text="请输入分钟数（0-59）")
    time="$minute $hour * * $day"
elif [ "$time" = "每月" ]
then
    day=$(zenity --entry --title="输入日期" --text="请输入日期（1-31）")
    hour=$(zenity --entry --title="输入小时数" --text="请输入小时数（0-23）")
    minute=$(zenity --entry --title="输入分钟数" --text="请输入分钟数（0-59）")
    time="$minute $hour $day * *"
fi
command=$(zenity --entry --title="输入命令" --text="请输入需要执行的shell命令")

# 将用户选择/输入的信息配置为计划任务定时执行
(crontab -l ; echo "$time $command") | crontab -
zenity --info --title="完成" --text="计划任务已添加"

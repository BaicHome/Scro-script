import os
import tkinter as tk
from tkinter import messagebox

# 检测是否已安装crontab，如未安装，则自动进行安装
if os.system('which crontab') != 0:
    os.system('sudo apt-get update')
    os.system('sudo apt-get install cron')

# 显示图形化界面
root = tk.Tk()
root.title("定时任务配置")
root.geometry('400x300')

# 时间选择
time_label = tk.Label(root, text="请选择执行时间：")
time_label.pack()
time_var = tk.StringVar()
time_var.set("*/1 * * * *")
time_entry = tk.Entry(root, textvariable=time_var)
time_entry.pack()

# 命令输入
command_label = tk.Label(root, text="请输入需要执行的命令：")
command_label.pack()
command_var = tk.StringVar()
command_entry = tk.Entry(root, textvariable=command_var)
command_entry.pack()

# 提交按钮
def submit():
    time_str = time_var.get()
    command_str = command_var.get()
    os.system(f'(crontab -l ; echo "{time_str} {command_str}") | crontab -')
    messagebox.showinfo("提示", "任务已添加成功！")
submit_button = tk.Button(root, text="提交", command=submit)
submit_button.pack()

root.mainloop()

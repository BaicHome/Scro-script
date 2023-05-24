## 简介

这是一款能帮助你实现阿里云域名动态解析至纯IPV6服务器的脚本

## 使用方法

> 单独使用（ipv6服务器上直接执行一键脚本）

```shell

bash <(curl -Ls https://raw.githubusercontent.com/BaicHome/Scro-script/master/aliv6.sh) -d 需要解析的域名 -b 阿里云AccessKeyID -c 阿里云AccessKeySecret

```

> 计划任务：

>> 如您已安装宝塔，可以直接使用宝塔的计划任务工具

>> 执行Python脚本后，会有图形界面，选择好时间，在Shell命令处填写单独使用方法中的一键脚本

```python3

python3 <(curl -Ls https://raw.githubusercontent.com/BaicHome/Scro-script/master/scron.py)

```

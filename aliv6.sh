#!/bin/bash

# 检查是否为root用户
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# 检查操作系统类型
if [ -f /etc/debian_version ]; then
    os="debian"
elif [ -f /etc/centos-release ]; then
    os="centos"
elif [ -f /etc/lsb-release ]; then
    os="ubuntu"
else
    echo "系统架构无法识别"
    exit 1
fi

# 检查Python3和pip是否已安装，如未安装则进行安装
if ! command -v python3 &> /dev/null; then
    if [ "$os" == "debian" ] || [ "$os" == "ubuntu" ]; then
        apt-get update
        apt-get install -y python3
    elif [ "$os" == "centos" ]; then
        yum update
        yum install -y python3
    fi
fi

if ! command -v pip &> /dev/null; then
    if [ "$os" == "debian" ] || [ "$os" == "ubuntu" ]; then
        apt-get update
        apt-get install -y python3-pip
    elif [ "$os" == "centos" ]; then
        yum update
        yum install -y python3-pip
    fi
fi

# 获取传入的参数
while getopts ":d:b:c:" opt; do
  case $opt in
    d)
      domain_name="$OPTARG"
      ;;
    b)
      access_key_id="$OPTARG"
      ;;
    c)
      access_key_secret="$OPTARG"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

# 检查是否传入了必要的参数
if [ -z "$domain_name" ] || [ -z "$access_key_id" ] || [ -z "$access_key_secret" ]; then
    echo "参数是必传的: -d 需要解析的域名 -b 阿里云AccessKeyID -c 阿里云AccessKeySecret"
    exit 1
fi

# 检查是否已安装aliyuncli，如未安装，则自动安装aliyuncli并配置相关密钥信息
if ! command -v aliyuncli &> /dev/null; then
    pip install aliyuncli
    aliyuncli configure set --profile default --access-key-id $access_key_id --access-key-secret $access_key_secret
fi

# 获取当前IPv6地址
ipv6=$(ip addr show dev eth0 | grep "inet6.*global" | awk '{print $2}' | cut -d '/' -f 1)

# 检查文件/ip6.txt是否存在
if [ ! -f /ip6.txt ]; then
    touch /ip6.txt
fi

# 获取文件中的IPv6地址
old_ipv6=$(cat /ip6.txt)

# 判断当前IPv6地址是否与文件中的IPv6地址相同
if [ "$ipv6" == "$old_ipv6" ]; then
    echo "IPv6 address is the same, exit."
    exit 0
fi

# 将当前IPv6地址写入文件
echo "$ipv6" > /ip6.txt

# 解析域名到IPv6地址
aliyuncli alidns AddDomainRecord --DomainName $domain_name --RR www --Type AAAA --Value $ipv6

echo "域名 $domain_name 已解析至 $ipv6."

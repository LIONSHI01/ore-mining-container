#!/bin/bash

# 检查是否以root用户运行脚本
if [ "$(id -u)" != "0" ]; then
    echo "此脚本需要以root用户权限运行。"
    echo "请尝试使用 'sudo -i' 命令切换到root用户，然后再次运行此脚本。"
    exit 1
fi

container_count=10

# 创建用户指定数量的容器
for i in $(seq 1 $container_count)
do
    docker rm -f ore$i

    echo "节点 ore$i 已经删除"
    
done

echo "==============================删除完成===================================."
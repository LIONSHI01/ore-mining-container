#!/bin/bash

# 检查是否以root用户运行脚本
if [ "$(id -u)" != "0" ]; then
    echo "此脚本需要以root用户权限运行。"
    echo "请尝试使用 'sudo -i' 命令切换到root用户，然后再次运行此脚本。"
    exit 1
fi

echo "脚本以及教程由推特用户大赌哥 @y95277777 编写，免费开源，请勿相信收费"
echo "================================================================"
echo "节点社区 Telegram 群组:https://t.me/niuwuriji"
echo "节点社区 Telegram 频道:https://t.me/niuwuriji"

# apt update -y

# 检查 Docker 是否已安装
# if ! command -v docker &> /dev/null
# then
#     echo "未检测到 Docker，正在安装..."
#     apt-get install -y ca-certificates curl gnupg lsb-release
    
#     # 安装 Docker 最新版本
#     apt-get install -y docker.io
# else
#     echo "Docker 已安装。"
# fi

container_count=10
rpc_url="https://capable-solitary-choice.solana-mainnet.quiknode.pro"
threads=4
priority_fee=5


# 创建用户指定数量的容器
for i in $(seq 1 $container_count)
do
    # 运行容器，并设置重启策略为always
    container_id=$(docker run -d --restart always -e RPC_URL="$rpc_url" -e THREADS:"$threads" -e PRIORITY_FEE="$priority_fee" -v "/root/.config/solana/wallet$i:/root/.config/solana" --name "ore$i" vicnoah/ore:4.0.2)

    echo "节点 ore$i 已经启动 容器ID $container_id"
    
done

echo "==============================所有节点均已设置并启动===================================."
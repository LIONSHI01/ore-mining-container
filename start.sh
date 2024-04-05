#!/bin/bash

create_wallets() {
    read -p "请输入要创建的 Solana 密钥对数量: " NUM_WALLETS

    echo "正在创建 $NUM_WALLETS 个 Solana 密钥对..."
    for ((i=1; i<=$NUM_WALLETS; i++)); do
        echo "钱包 $i 信息"
        mkdir -p /root/.config/solana/wallet$i
        solana-keygen new --derivation-path m/44'/501'/0'/0' --outfile /root/.config/solana/wallet$i/id.json --force | tee /root/.config/solana/wallet$i/wallet-output_$i.txt
    done

    echo "钱包列表"
    for ((i=1; i<=$NUM_WALLETS; i++)); do
        echo "钱包$i: $(solana-keygen pubkey /root/.config/solana/wallet$i/id.json)"
        echo $(cat /root/.config/solana/wallet$i/id.json)
    done

    echo "成功创建 $NUM_WALLETS 个 Solana 密钥对。"
}

# 查看挖矿收益
function view_rewards() {
    RPC_URL=${RPC_URL:-"https://api.mainnet-beta.solana.com"}
    ore --rpc $RPC_URL --keypair ~/.config/solana/id.json rewards
}

# 领取挖矿收益
function claim_rewards() {
    RPC_URL=${RPC_URL:-"https://api.mainnet-beta.solana.com"}
    ore --rpc $RPC_URL --keypair ~/.config/solana/id.json claim
}

function start() {
    RPC_URL=${RPC_URL:-"https://api.mainnet-beta.solana.com"}
    THREADS=${THREADS:-4}
    PRIORITY_FEE=${PRIORITY_FEE:-1}
    echo $RPC_URL
    echo "开始挖矿..."
    while true; do
        ore --rpc $RPC_URL --keypair ~/.config/solana/id.json --priority-fee $PRIORITY_FEE mine --threads $THREADS
        echo "进程异常退出，等待重启" >&2
        sleep 1
    done
}

# 主菜单
function main_menu() {
    while true; do
        clear
        echo "退出脚本，请按键盘ctrl c退出即可"
        echo "请选择要执行的操作:"
        echo "1. 创建钱包"
        echo "2. 查看挖矿收益"
        echo "3. 领取挖矿收益"
        read -p "请输入选项（1-3）: " OPTION

        case $OPTION in
        1) create_wallets ;;
        2) view_rewards ;;
        3) claim_rewards ;;
        esac
        echo "按任意键返回主菜单..."
        read -n 1
    done
}


# 如果没有传入参数，则执行 start 函数
if [ "$1" != "-i" ]; then
    start
else
    # 显示主菜单
    main_menu
fi
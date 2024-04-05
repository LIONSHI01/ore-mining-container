# 使用 rust:1.77.1-slim-bullseye 作为基础镜像
FROM rust:1.77.1-slim-bullseye

# 设置环境变量
ENV RPC_URL="https://api.mainnet-beta.solana.com"
ENV THREADS="4"
ENV PRIORITY_FEE="5"

# 安装 curl
RUN apt-get update -y && apt-get install -y curl

# 安装 Solana
RUN sh -c "$(curl -sSfL https://release.solana.com/v1.18.4/install)"

# 设置环境变量
ENV PATH="/root/.local/share/solana/install/active_release/bin:/root/.cargo/bin:$PATH"

# 安装 ore-cli
RUN cargo install ore-cli

# 将本地 start.sh 脚本复制到容器中
COPY start.sh /start.sh

# 设置脚本文件的执行权限
RUN chmod +x /start.sh

# 运行 ore-cli
CMD ["/start.sh"]

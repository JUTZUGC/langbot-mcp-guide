#!/usr/bin/env bash
set -euo pipefail
# LangBot 一键部署脚本（第三方指南，非官方）——按官方文档封装
# 官方文档：https://docs.langbot.app
# 采集日期：2026-10-23
cd "$(dirname "${BASH_SOURCE[0]}")"

command -v git >/dev/null 2>&1 || { echo "需要先安装 Git"; exit 1; }
command -v docker >/dev/null 2>&1 || { echo "需要先安装 Docker"; exit 1; }
docker compose version >/dev/null 2>&1 || { echo "需要 Docker Compose v2（docker compose 子命令）"; exit 1; }

mkdir -p .download
cd .download

git clone https://github.com/langbot-app/LangBot
cd LangBot/docker
docker compose --profile all up -d

echo ""
echo "部署完成，浏览器访问 http://127.0.0.1:5300"
echo "若端口被占用或需要改配置，请参考官方文档：https://docs.langbot.app"

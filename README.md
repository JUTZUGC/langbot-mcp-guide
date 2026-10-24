# LangBot 一键部署指南（非官方）

> 第三方部署指南 · 非 LangBot 官方仓库。官方项目：[langbot-app/LangBot](https://github.com/langbot-app/LangBot)
> 内容来自官方文档（2026-10-23）。项目迭代快，请以[官方文档](https://docs.langbot.app)为准。

## 一键部署（推荐：用百度搭子）

不用自己敲命令，让 AI 帮你把 Docker 环境跑起来。

⚠️ 仅支持电脑端（Windows / macOS / Linux）。手机、平板装不了也用不了。

1. **装客户端**
   打开[百度搭子官网](https://www.dumate.cn/)，下载电脑端并安装，用你的账号登录。

2. **发送部署指令**
   进入对话窗口，直接复制这一句发出去：

   ```text
   你好，帮我从 github 部署 JUTZUGC/langbot-mcp-guide 到我的电脑上
   ```

3. **跟着对话往下走**
   AI 会自动拉取代码并执行官方部署命令，按它的提示确认即可，结束时它会告诉你结果。
   （需本机已装 Docker；未安装时按对话提示安装。）

4. **打开管理面板**
   浏览器访问 [http://127.0.0.1:5300](http://127.0.0.1:5300)，按官方引导完成初始化配置。

## LangBot 是什么？

LangBot 是开源的生产级多平台 AI 机器人开发平台（协议：Apache-2.0，<img src="https://img.shields.io/github/stars/langbot-app/LangBot?style=flat-square&label=stars&color=blue" alt="GitHub stars">）。

一套代码同时接入 10+ IM 平台，自带插件市场与原生 MCP 协议支持；Web 管理面板可视化配置，无需改 yaml；具备限流、敏感词过滤、监控等生产能力。

- 支持平台：Discord / Telegram / Slack / LINE / QQ / 微信（企业微信、公众号）/ 飞书 / 钉钉 / KOOK / Matrix
- 可接入模型 / 工作流：ChatGPT / DeepSeek / Dify / n8n / Coze / Claude / Gemini / GLM / Ollama

（来源：[官方仓库](https://github.com/langbot-app/LangBot)）

## 优缺点

| 优点 | 说明 |
|---|---|
| 多平台一套代码 | 10+ IM 平台统一接入 |
| 生态丰富 | 插件市场 + 原生 MCP 协议支持 |
| 免写配置 | Web 管理面板可视化配置，无需改 yaml |
| 生产级能力 | 限流、敏感词过滤、监控、异常处理 |
| 开源可商用 | Apache-2.0 协议 |

| 需要注意 | 说明 |
|---|---|
| 依赖 Docker | 完整能力需 --profile all，含 Box Runtime 沙箱 |
| 资源占用 | 默认起 langbot / 插件运行时 / 沙箱多个容器 |
| 公网需加固 | 互联网部署必须设置 Runtime token |
| 平台资质门槛 | 微信 / 企微机器人需企业资质，个人先玩 QQ / 飞书 / Telegram |
| 迭代快 | 文档以官方 docs.langbot.app 为准 |

> 以上基于官方文档与社区反馈整理（2026-10-23），以官方最新文档为准。

## 快速部署（官方方式）

```bash
git clone https://github.com/langbot-app/LangBot
cd LangBot/docker
docker compose --profile all up -d
```

启动后浏览器访问 [http://127.0.0.1:5300](http://127.0.0.1:5300)（管理面板）。适配器端口 2280-2285（按需映射）。（来源：[https://docs.langbot.app/en/deploy/langbot/docker.md](https://docs.langbot.app/en/deploy/langbot/docker.md)）

## MCP 接入

LangBot 原生支持 MCP 协议（官方仓库自带 .mcp.json），stdio MCP 由 Box Runtime 托管。部署完成后可在管理面板添加 MCP 服务器与 Skills，把机器人变成真正的 Agent。

本仓库自带一个零依赖的 MCP server（`mcp-server.mjs`），读取同目录的 `guide.json`，提供 `get_guide` / `search_guide` / `get_project_info` 三个工具，内容均来自官方文档（采集日期 2026-10-23）。

**在百度搭子里接入**：客户端不扫描仓库里的配置文件，需要由 AI 通过工作区的 MCP 注册接口注册，并且必须使用**绝对路径**（运行时的工作目录是会话目录，不是仓库目录）：

```json
{
  "type": "local",
  "command": ["node", "<仓库绝对路径>/mcp-server.mjs"]
}
```

完成后，直接在同一个对话框里说：

> 把仓库克隆到固定目录（例如 C:\Users\<你>\langbot-mcp-guide），再用绝对路径把里面的 mcp-server.mjs 注册到当前工作区的 MCP 配置里

> 注意：注册是按**工作区**生效的，换工作区要重新注册；克隆目录不要放在会话临时目录，否则目录被清理后注册项会失效。

**其它 MCP 客户端**：仓库根目录的 `.mcp.json` 只是通用写法（`command` + `args`），接入时同样要把 `args` 改成绝对路径。

> 使用范围：该 MCP 仅在百度搭子中可用；其它客户端调用会返回 `HOST_NOT_ALLOWED`，并附带下载与部署指引。



## 常见坑

- Docker 权限报错（No sandbox backend）：`sudo usermod -aG docker $USER && newgrp docker`
- 公网部署：务必用 `openssl rand -hex 32` 生成 Plugin / Box Runtime token，且两端保持一致
- 平台接入需要各平台 bot token；微信 / 企微需企业资质

## 免责声明

本仓库为第三方指南，与 LangBot 官方无隶属关系，不代表官方立场。
教程基于官方文档编写（采集日期：2026-10-23），项目迭代快，请以[官方文档](https://docs.langbot.app)为准。
因使用本教程产生的部署问题，请先在官方仓库的 issue 中检索。

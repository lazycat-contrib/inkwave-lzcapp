# inkwave-lzcapp

[INKWAVE](https://github.com/amiaoapp/inkwave) 的 LazyCat LPK 打包 —— Splatoon 风格 4v4 涂地对战射击游戏（three.js 纯静态站点）。

## 形态

- 纯静态：无构建步骤，`tools/build-dist.py` 整理游戏文件到 `dist/`
- 单机模式完全自足：打 bot、涂地/占区对战、全部地图武器
- 在线房间：浏览器直连上游公共 relay（`wss://inkwave-net.inkwave.workers.dev`），与官网联机体验一致
- `run_as`/容器/后端服务：均不需要

## 结构

- `package.yml` — LPK v2 包元数据（`community.lazycat.app.inkwave`）
- `lzc-manifest.yml` — 运行结构：静态文件直出（`file:///lzcapp/pkg/content/`）
- `lzc-build.yml` — 构建配置（`build.sh` + `contentdir: ./dist`）
- `build.sh` — 拉取上游 main 源码 → `python3 tools/build-dist.py` → 拷贝 `dist/`
- `.github/lazycat-action.yml` — ca-x/lazycat-github-action 配置（git 版本源，无工具链，仅私有商店）
- `.github/workflows/lazycat.yml` — 每日自动构建 + 发布喵喵商店

## 发布

推送到 `lazycat-contrib/inkwave-lzcapp` 后，GitHub Action 自动：

1. 计算下一个 patch 版本
2. 拉取上游 main 最新 commit 并组装 `dist/`
3. 产出 `community.lazycat.app.inkwave-v<version>.lpk` Release 资产
4. 发布到喵喵商店（`APPSTORE_URL` / `APPSTORE_TOKEN`，可选 `APP_ID`、`PRIVATE_STORE_GROUP_CODES`）

需在仓库/组织配置 Secrets：`APPSTORE_URL`、`APPSTORE_TOKEN`。

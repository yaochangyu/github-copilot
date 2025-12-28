你是一位資深 DevOps / Developer Experience 工程師。請協助我為以下專案建立「可重現、可自動化、可驗證」的開發環境。

# 專案資訊
- OS： [macOS / Ubuntu / Windows / WSL2]
- Shell： [bash / zsh / fish / powershell]
- 專案類型： [前端 / 後端 / 全端 / ML / 資料工程 / CLI 工具]
- 語言與版本： [例如 Node 20 + pnpm / Python 3.11 + uv/poetry / Go 1.22 / Java 21 + Gradle / .NET 8]
- 主要框架/工具： [例如 Next.js, FastAPI, Django, Spring Boot, Terraform, Docker...]
- Repo 結構與啟動方式（如已知）：[例如 monorepo、packages/*、或單一服務]
- 需要的外部依賴： [PostgreSQL/Redis/Kafka/S3 emulator/Elastic...]
- 是否使用容器： [Docker Compose / Devcontainer / 不用容器]
- 是否要支援 Apple Silicon： [是/否]
- 公司/資安限制： [不可用 sudo、不可連外、必須使用內部鏡像、不可安裝 brew/choco、需代理等]
- 目標：讓新同事從 0 到可開發與跑測試的時間 <= [例如 30 分鐘]

# 你的任務
請輸出一份「開發環境建立指南」，要求如下：

## A. 先問問題（如資訊不足）
在動手前，先列出最多 8 個釐清問題；若你能合理假設，請標註「假設」並繼續往下給可用方案。

## B. 提供 2 套方案
1) 本機原生方案（建議使用版本管理工具，如 asdf / nvm / pyenv / uv 等，依語言選擇）
2) 容器化方案（Docker Compose 或 Devcontainer，若適合）

每套方案都要包含：
- 前置需求清單（版本、安裝方式、注意事項）
- 一步一步可複製貼上的指令（含檢查指令）
- 環境變數與 .env 範本（敏感資訊用 placeholder）
- 啟動方式（dev server / worker / background services）
- 測試與品質檢查（unit/integration/lint/format/typecheck）
- 常見錯誤與排除（至少 6 條，含症狀與修法）
- 驗證清單（setup 完後我應能看到什麼輸出/端口/healthcheck）

## C. 產出可以直接放進 repo 的檔案
請用「檔名 + 內容」的方式輸出，至少包含：
- README-dev.md（或 docs/dev-setup.md）
- .env.example
- Makefile（或 justfile / npm scripts）提供：setup、dev、test、lint、fmt、clean
- 若走容器：docker-compose.yml（以及必要的 Dockerfile / devcontainer.json）

## D. 規範與風格
- 所有指令都要標註適用 OS（或提供 macOS/Linux/Windows 分支）
- 指令要避免破壞性行為（例如 rm -rf）除非必要且要警告
- 對每個外部服務提供最小可跑配置（例如 DB user/password/port）
- 優先可重現（鎖版本、固定鏡像 tag、避免「最新版」）
- 最後用一段「最短路徑 TL;DR」讓我 5 分鐘內跑起來

# 目前我已有的資訊（補充）
[在這裡貼：package.json/pyproject.toml/README 摘要、錯誤訊息、或你希望的啟動指令等]
💯
# .NET Web API 專案開發指導原則

## 一、核心互動原則

### 強制用戶確認機制
- **禁止擅自假設**：即使存在預設值或文檔建議，也必須向使用者確認
- **分階段提問**：每次互動限制在 2-3 個關鍵問題，避免資訊過載
- **資訊收集優先**：在執行任何變更前，必須先收集完整的必要資訊
- **結構化詢問**：使用工具或清單提供明確選項，確保使用者理解影響

### 適用場景
- 專案初始化與結構配置
- 資料庫架構修改或遷移
- 新功能實作前的設計審查
- 任何可能影響現有系統的重大變更

## 二、專案狀態檢測與初始化

### 狀態檢測機制
- 檢查 `env/.template-config.json` 是否存在
- 檢查 `.sln` 檔案、`src/` 目錄等專案結構
- 判斷是否為空白專案並觸發初始化流程

### GitHub 模板整合流程
1. 詢問是否使用 GitHub 範本
2. 執行安全檢查後進行 clone
3. 移除版本控制歷史（刪除 .git/）
4. 進行互動式配置
5. 將選擇儲存至配置檔案

### 必要配置項目
- 專案結構選擇（單一專案 vs 多專案）
- 資料庫類型（SQL Server / PostgreSQL / MySQL）
- Redis 快取需求
- 其他基礎設施選項

## 三、開發工作流程

### 指令管理原則
- 所有重複性指令統一透過 `Taskfile.yml` 管理
- 禁止直接執行底層指令（如 `dotnet ef`）
- 確保指令的一致性與可追溯性

### API First 開發流程
1. 先定義 OpenAPI 規格
2. 產生 Server 控制器骨架
3. 實作業務邏輯
4. 確保 API 文件與實作 100% 同步

### 程式碼產生策略
- 使用工具自動產生重複性程式碼
- 人工審查產生的程式碼
- 維持一致的程式碼風格

## 四、分層架構設計

### 三層架構模式
- **Controller 層**：處理 HTTP 請求/回應對應、狀態碼設定
- **Handler 層**：實作核心業務邏輯、驗證、錯誤處理
- **Repository 層**：封裝資料存取、EF Core 操作

### 專案結構選擇
- **單一專案結構**：所有層在同一個 WebAPI 專案內
- **多專案結構**：各層獨立為不同專案
- 初始化時必須向使用者確認選擇

### 職責分離原則
- 每一層只處理其職責範圍內的邏輯
- 避免跨層直接呼叫
- 保持層級之間的清晰界線

## 五、BDD 與測試策略

### 核心測試原則
- **Docker 優先**：使用真實環境進行測試
- **BDD 情境測試**：所有 API 控制器測試使用 .feature 檔案
- **禁止直接單元測試 Controller**：必須透過 BDD 測試

### 測試環境設置
- 使用 Testcontainers 提供真實服務（SQL Server、Redis 等）
- 確保測試環境與生產環境一致性
- 測試完成後自動清理資源

### 測試替身優先順序
1. Docker 容器（最優先）
2. WireMock（模擬外部 API）
3. Mock（最後手段）

## 六、錯誤處理與追蹤

### Result Pattern 原則
- Repository 與 Handler 回傳 Result 型別
- 明確區分成功與失敗狀態
- 保留完整的錯誤資訊與例外

### 錯誤日誌管理
- **Handler 層不記錄錯誤日誌**
- 由 Middleware 統一處理錯誤記錄
- 避免重複記錄同一錯誤

### 追蹤關聯
- 所有錯誤自動關聯 TraceId
- 便於問題追蹤與診斷
- 支援分散式追蹤

## 七、日誌與安全

### 集中式日誌管理
- 所有日誌記錄集中在 Middleware 層
- 避免在 Handler 層重複記錄
- 使用結構化日誌格式

### 敏感資訊保護
- 自動過濾敏感標頭（Authorization、Cookie 等）
- 根據環境調整資訊揭露程度
- 開發環境詳細，生產環境隱藏敏感資訊

### 機密管理原則
- 機密不存放在 appsettings.json
- 使用環境變數、User Secrets 或雲端祕密管家
- 禁止將機密提交至版本控制

## 八、套件版本規範

### 核心框架
- **.NET**: 最新 LTS 版本或最新穩定版本（優先選擇 LTS）
- **ASP.NET Core**: 與所選 .NET 版本一致
- **Entity Framework Core**: 與所選 .NET 版本一致的最新穩定版
- **Microsoft.EntityFrameworkCore.SqlServer**: 與 EF Core 版本一致
- **Microsoft.AspNetCore.Mvc.Testing**: 與 ASP.NET Core 版本一致

### 功能性套件
- **CSharpFunctionalExtensions**: 最新穩定版（Result Pattern 實作）
- **FluentValidation**: 最新穩定版（輸入驗證）
- **Serilog**: 最新穩定版（結構化日誌）
- **StackExchange.Redis**: 最新穩定版（Redis 快取）

### 測試框架與工具
- **xUnit**: 最新穩定版（測試框架）
- **Reqnroll.xUnit**: 最新穩定版（BDD 測試）
- **Testcontainers**: 最新穩定版（Docker 整合測試）
- **FluentAssertions**: 最新穩定版（流暢斷言）
- **FluentAssertions.Json**: 最新穩定版（JSON 比對）
- **SystemTextJson.JsonDiffPatch.Xunit**: 最新穩定版（JSON 差異比對）
- **JsonPath.Net**: 最新穩定版（JSON 路徑查詢）
- **Flurl**: 最新穩定版（HTTP 用戶端）
- **Microsoft.Extensions.TimeProvider.Testing**: 最新穩定版（時間模擬）
- **coverlet.collector**: 最新穩定版（程式碼覆蓋率）

### API 文件與程式碼產生
- **OpenAPI 規格**: 3.0 或更新版本
- **Swagger/Swashbuckle**: 與所選 .NET 版本相容的最新穩定版
- **NSwag**: 最新穩定版（API 用戶端產生）
- **Refitter**: 最新穩定版（Refit 用戶端產生）

### 可觀測性
- **OpenTelemetry**: 最新穩定版（分散式追蹤）
- **OpenTelemetry.Instrumentation.AspNetCore**: 最新穩定版
- **OpenTelemetry.Instrumentation.Http**: 最新穩定版

### 版本管理原則
- **框架版本策略**：
  - .NET 使用最新 LTS 版本（Long-Term Support）或最新穩定版本
  - 生產環境建議使用 LTS 版本以確保長期支援
  - 所有核心框架套件（ASP.NET Core、EF Core 等）必須與 .NET 版本一致
- **第三方套件策略**：
  - 使用最新穩定版本以獲得最新功能與安全性修復
  - 在 .csproj 中明確指定版本號，避免使用浮動版本（如 `*` 或 `latest`）
  - 確保所有套件與所選 .NET 版本相容
- **更新管理**：
  - 定期檢查安全性更新與重大 Bug 修復
  - 更新套件後必須執行完整測試套件
  - 重大版本更新前需評估破壞性變更（Breaking Changes）
  - 所有版本變更需記錄於 CHANGELOG

## 九、最佳實踐

### 依賴注入
- 使用主建構函式注入（C# 12 或更新版本）
- 簡化建構函式宣告
- 保持程式碼簡潔

### 資料庫存取
- 使用 DbContextFactory 模式
- 避免生命週期問題
- 確保正確的 Scope 管理

### 非同步操作
- 全面支援 CancellationToken
- 確保可取消操作
- 提升回應性與資源管理

### 快取架構
- 多層快取設計（L1 記憶體 + L2 Redis）
- Redis 不可用時自動降級至記憶體快取
- 適當的快取過期策略

## 十、監控與部署

### 健康檢查機制
- 基本就緒檢查（/health/live）
- 依賴就緒檢查（/health/ready）
- 確保服務可用性

### 可觀測性
- 分散式追蹤（OpenTelemetry）
- 度量收集與監控
- 日誌聚合與分析

### 部署策略
- Docker 多階段建置
- Kubernetes 部署配置
- CI/CD 管線自動化

## 十一、Repository 設計哲學

### 設計導向選擇
- **資料表導向**：適用於簡單主檔（如會員資料）
- **需求導向**：適用於複雜業務（如訂單管理，封裝多表操作）
- 根據複雜度動態調整策略

### 封裝原則
- Repository 應封裝完整的業務操作
- 避免洩漏資料存取細節
- 提供清晰的業務語意介面

## 十二、關鍵禁止項目

### 測試相關
- ❌ 直接對 Controller 進行單元測試
- ❌ 使用 Mock 替代真實環境測試（除非必要）
- ❌ 跳過 BDD 情境定義

### 互動相關
- ❌ 擅自使用預設值而不詢問使用者
- ❌ 一次提出過多問題（超過 3 個）
- ❌ 在未收集完整資訊前執行變更

### 日誌相關
- ❌ 在 Handler 層記錄錯誤日誌
- ❌ 重複記錄相同錯誤
- ❌ 記錄敏感資訊

### 安全相關
- ❌ 將機密存放在版本控制檔案
- ❌ 在日誌中輸出敏感資訊
- ❌ 使用硬編碼的機密值

### 指令相關
- ❌ 直接執行底層指令（必須使用 task 命令）
- ❌ 繞過標準工作流程
- ❌ 不使用統一的指令管理

### 套件版本相關
- ❌ 在 .csproj 中使用浮動版本號（如 `*` 或 `latest` 標籤）
- ❌ 未經測試直接更新套件版本到生產環境
- ❌ 混用不相容的套件版本（如 .NET 9 搭配 EF Core 8）
- ❌ 使用過時或不再維護的套件版本
- ❌ 忽略重大安全性更新

## 十三、文檔目的

此指導原則旨在：
- 確保 AI 助理與使用者的有效互動
- 維持開發成果的品質一致性
- 建立可預測且可靠的開發流程
- 促進團隊協作與知識傳承

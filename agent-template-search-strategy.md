# Agent/Skill 模板搜尋策略

基於 `code-review.agent.md` 的特徵，搜尋類似的軟體工程 agent/skill 指令檔模板。

---

## 📋 已知檔案特徵

- **格式**: Markdown 檔案 (`.md`)
- **結構**: YAML frontmatter + Markdown 內容
- **Frontmatter 欄位**: 
  - `name`: agent 名稱
  - `agent`: 類型標記
  - `description`: 功能描述
- **內容特徵**:
  - 角色定義（Role）
  - 審查/分析面向（多個維度）
  - 結構化輸出格式
  - 可能包含變數/參數（如 `${input:...}`）

---

## 🔍 1. Google/Bing 搜尋查詢（10 組）

```
1. site:github.com "---" "name:" "agent:" "description:" filetype:md

2. site:github.com ".agent.md" "code review" OR "code-review"

3. site:github.com "copilot" "agent" "frontmatter" "---"

4. site:github.com ".skill.md" "YAML frontmatter" "role"

5. site:github.com "claude" "sub-agent" ".md" "---"

6. site:github.com "prompt template" "software engineering" "---" filetype:md

7. site:github.com ".github/agents" OR ".github/prompts" "*.agent.md"

8. site:github.com "AI agent template" "security" "performance" "architecture"

9. site:github.com "copilot instructions" ".md" "frontmatter"

10. site:github.com "agent-based" "code analysis" "template" "markdown"
```

---

## 🐙 2. GitHub Code Search 查詢（10 組）

使用新版 GitHub Code Search 語法：

```
1. path:**.agent.md "---" "name:" "description:"

2. path:**/.github/agents/ language:markdown "---"

3. filename:*.agent.md "role" "output format"

4. path:**/prompts/ "---" "agent:" extension:md

5. "name: code-review" OR "name: security-scan" path:**.md

6. path:**.skill.md "frontmatter" "YAML"

7. "Critical Issues" "Suggestions" "Good Practices" path:**.agent.md

8. path:**/.github/ filename:*.agent.md OR filename:*.skill.md

9. "${input:" path:**.md "---"

10. "separation of concerns" "design pattern" path:**agent**.md
```

### GitHub 進階搜尋組合

```
repo:github/copilot* path:**.agent.md

org:microsoft path:**agents/ extension:md

user:anthropic "claude" ".md" "---"

stars:>100 "AI agent" "template" extension:md
```

---

## 🔤 3. 關鍵字同義詞

| 類別 | 同義詞 |
|------|--------|
| **Agent 相關** | agent, skill, subagent, sub-agent, capability, tool, function |
| **Prompt 相關** | prompt, instruction, system-prompt, system_prompt, directive |
| **模板相關** | template, scaffold, boilerplate, blueprint, schema |
| **配置相關** | config, configuration, manifest, definition, spec |
| **文檔類型** | .agent.md, .skill.md, .prompt.md, .instruction.md |
| **框架相關** | copilot, claude, cursor, cody, aider, chatgpt |

### 組合搜尋詞

```
- "agent template"
- "skill definition"
- "prompt scaffold"
- "AI instruction template"
- "code review agent"
- "analysis skill"
- "engineering agent"
```

---

## ✅ 4. 判斷「真的是模板」的特徵

### 🟢 **肯定特徵** (這是模板)

1. **結構化 Frontmatter**
   - 有 YAML frontmatter (`---` 開頭結尾)
   - 包含 metadata 欄位 (name, description, author, version 等)
   
2. **角色定義區塊**
   - 明確的 "Role" 或 "角色" 段落
   - 使用第二人稱 ("你是...", "You are...")
   
3. **系統化內容結構**
   - 有明確的章節劃分 (## 標題)
   - 包含「分析面向」、「審查項目」、「檢查清單」等結構
   
4. **可重用的輸出格式**
   - 定義標準化輸出格式
   - 使用表情符號或標記 (🔴, 🟡, ✅)
   
5. **參數化設計**
   - 包含變數佔位符 (`${input:...}`, `{{variable}}`, `[PLACEHOLDER]`)
   - 可以替換的參數區塊

6. **檔案命名模式**
   - `.agent.md`, `.skill.md`, `.prompt.md`
   - 檔案位於特定目錄 (`.github/agents/`, `prompts/`, `.claude/`)

### 🔴 **否定特徵** (不是模板，是文章/引用)

1. **敘述性內容**
   - 是在「介紹」或「討論」agent，而非定義 agent
   - 包含 "如何使用", "教學", "範例說明" 等字眼
   
2. **文章結構**
   - 有作者署名、發布日期
   - 包含「前言」、「結論」、「延伸閱讀」
   
3. **程式碼範例**
   - 檔案中主要是程式碼，而非指令
   - 是在展示「如何呼叫 agent」，不是定義 agent 本身
   
4. **README 或文檔**
   - 檔案名稱為 README.md
   - 是專案說明文件，內含多個 agent 的引用

5. **外部引用**
   - 包含 "參考來源", "引用自", "inspired by"
   - 是集合/列表文件 (如 "awesome-agents")

### 🔍 **快速驗證方法**

```markdown
✓ 檢查前 20 行是否有 YAML frontmatter
✓ 搜尋 "你是" 或 "You are" (角色定義)
✓ 檢查是否有 ${input:} 或類似變數
✓ 檔案路徑包含 agents/, prompts/, .claude/
✗ 包含 "How to", "Tutorial", "Guide", "Example"
✗ 有多個 agent 並列說明 (代表是列表文件)
```

---

## 🎯 5. 推薦搜尋路徑

### 優先搜尋的 GitHub Repository

```
github/copilot-*
anthropic/claude-*
microsoft/vscode-*
cursor-ai/*
sourcegraph/cody-*
```

### 特定目錄

```
.github/agents/
.github/prompts/
.claude/
prompts/
agents/
skills/
.copilot/
```

---

## 📊 6. 執行順序建議

1. **第一階段**: GitHub Code Search (最精準)
   - 使用前 5 組 Code Search 查詢
   - 重點：path 和 filename 過濾

2. **第二階段**: Google/Bing (擴大範圍)
   - 使用 site:github.com 限定
   - 重點：特定關鍵字組合

3. **第三階段**: 手動驗證
   - 檢查搜尋結果是否符合「模板特徵」
   - 排除文章、教學、README

4. **第四階段**: 交叉驗證
   - 查看找到的 repository 是否有更多類似檔案
   - 追蹤 forks 和 related repositories

---

## 📝 範例比對

### ✅ 這是模板

```markdown
---
name: security-audit
agent: security
description: 執行安全性稽核
---

## 角色
你是資深安全工程師...

## 審查項目
1. 輸入驗證
2. 權限控制
...
```

### ❌ 這不是模板（是文章）

```markdown
# How to Use Code Review Agents

In this tutorial, we'll learn how to use agents...

Here's an example of a code-review agent:
[引用某個 agent 內容]
```

---

## 🚀 下一步

執行搜尋後，建議：
1. 記錄找到的模板數量與品質
2. 分類不同類型的 agent (code-review, security, performance, testing...)
3. 分析共通模式，提煉最佳實踐
4. 建立自己的模板庫

---

*建立日期: 2025-12-28*
*用途: 搜尋 GitHub 上的 AI Agent/Skill 模板檔案*

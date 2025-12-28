# GitHub Copilot Agent/Skill 模板完整指南

## 🎯 執行摘要

GitHub Copilot 現已支援完整的 agent 與 skill 系統（2024-2025），包含：
- **127+ 社群 agents** (來自 github/awesome-copilot)
- **3 種檔案類型**: `.agent.md`, `.instructions.md`, `SKILL.md`
- **官方內建**: code-review agent, coding agent, CLI agent
- **MCP 整合**: Model Context Protocol 伺服器支援

---

## 📦 一、核心資源與官方倉庫

### 🏆 **GitHub 官方 awesome-copilot** ⭐⭐⭐⭐⭐
- **URL**: https://github.com/github/awesome-copilot
- **規模**: 127 agents + prompts + instructions + skills
- **授權**: MIT License
- **更新頻率**: 活躍（2024-2025）

**目錄結構**:
```
awesome-copilot/
├── agents/              # 127+ custom agents (.agent.md)
├── prompts/             # Task-specific prompts (.prompt.md)
├── instructions/        # Coding standards (.instructions.md)
├── skills/              # Self-contained skill folders (SKILL.md)
├── collections/         # Themed resource groupings
└── docs/                # Documentation & guidelines
```

### 📚 **官方文件**
- [Creating Custom Agents](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/coding-agent/create-custom-agents)
- [Custom Agents Configuration](https://docs.github.com/en/copilot/reference/custom-agents-configuration)
- [Using GitHub Copilot CLI](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/use-copilot-cli)
- [Agent Skills](https://github.blog/changelog/2025-12-18-github-copilot-now-supports-agent-skills/)

---

## 🎨 二、檔案類型與格式對比

### 📄 **類型 1: Custom Agents (.agent.md)**

**用途**: 定義專門的 AI 助手角色（類似 Claude Code subagents）

**位置**:
```
.github/agents/          # 專案層級
~/.copilot/agents/       # CLI 個人層級（新增於 2025-10）
{org}/.github/agents/    # 組織層級
```

**YAML Frontmatter 結構**:
```yaml
---
name: 'Agent Display Name'           # 可選（預設為檔名）
description: 'Required: when and why to use this agent'  # 必填
target: 'vscode'                     # 可選：vscode | github-copilot
tools: ['read', 'edit', 'search']    # 可選：限制工具權限
model: 'GPT-4'                       # 可選：指定模型
infer: true                          # 可選：自動選擇（預設 true）
mcp-servers:                         # 可選：MCP 伺服器（僅組織/企業）
  custom-server:
    type: 'local'
    command: 'npx'
    args: ['-y', '@modelcontextprotocol/server-example']
metadata:                            # 可選：標註資訊
  author: 'team-name'
  version: '1.0'
---

# Agent Instructions

You are a [role] specialized in [expertise].

## Responsibilities
- Task 1
- Task 2

## Approach
[Detailed behavioral instructions, max 30,000 characters]
```

**範例檔案**: `se-security-reviewer.agent.md`
```yaml
---
name: 'SE: Security'
description: 'Security-focused code review specialist with OWASP Top 10, Zero Trust, LLM security, and enterprise security standards'
model: GPT-5
tools: ['codebase', 'edit/editFiles', 'search', 'problems']
---

You are a comprehensive security reviewer tasked with preventing production vulnerabilities.

## Primary Review Areas

1. **OWASP Top 10**
   - Broken Access Control
   - Cryptographic Failures
   - Injection Attacks

2. **OWASP LLM Top 10**
   - Prompt Injection
   - Information Disclosure

3. **Zero Trust Architecture**
   - Verify all internal requests
   - Authentication validation

## Documentation
Each review produces a structured report saved to:
`docs/code-review/[date]-[component]-review.md`
```

---

### 📄 **類型 2: Instructions (.instructions.md)**

**用途**: 專案編碼標準與審查指南（類似 Claude Code skills）

**位置**:
```
.github/copilot-instructions.md           # 單一檔案
.github/instructions/*.instructions.md    # 多檔案（條件式）
AGENTS.md                                 # 通用 AI agent 說明檔
```

**YAML Frontmatter 結構**:
```yaml
---
description: 'Non-empty description'     # 必填
applyTo: '**.js, **.ts'                  # 必填：檔案模式
excludeAgent: 'code-review'              # 可選：排除特定 agent
---

# Coding Standards

## Code Quality
- Meaningful names
- Single Responsibility Principle
- DRY (Don't Repeat Yourself)

## Security
- Input validation
- SQL injection prevention
- Authentication/Authorization
```

**範例檔案**: `code-review-generic.instructions.md`
```yaml
---
description: 'Comprehensive code review guidelines following best practices'
applyTo: '**.*'
---

# Code Review Instructions

## Prioritization Framework
- 🔴 **CRITICAL** (blocks merge): Security, logic errors, breaking changes
- 🟡 **IMPORTANT** (requires discussion): Code quality, test gaps
- 🟢 **SUGGESTION** (non-blocking): Readability, optimization

## Review Areas

### Security Checklist
- [ ] No sensitive data exposed
- [ ] Input validation implemented
- [ ] SQL injection prevention
- [ ] Authentication/Authorization verified
- [ ] Cryptographic best practices
- [ ] Dependencies scanned

### Testing Standards
- [ ] Descriptive test names
- [ ] Arrange-Act-Assert structure
- [ ] Independent tests
- [ ] Edge case coverage

### Performance
- [ ] No N+1 queries
- [ ] Efficient algorithms
- [ ] Proper caching
- [ ] Resource cleanup
```

---

### 📄 **類型 3: Skills (SKILL.md)**

**用途**: 可攜帶式技能包（與 Claude Code SKILL.md 相容）

**位置**:
```
.github/skills/{skill-name}/SKILL.md     # 專案層級
~/.copilot/skills/{skill-name}/SKILL.md  # 個人層級
```

**目錄結構**:
```
skills/my-skill/
├── SKILL.md            # 必須（含 YAML frontmatter）
├── reference.md        # 可選（詳細文件）
├── examples/           # 可選（範例檔案）
└── scripts/            # 可選（輔助腳本，<5MB）
```

**YAML Frontmatter 結構**:
```yaml
---
name: skill-name                    # 必填（小寫 + 連字號，≤64 字元）
description: 'What this skill does and when to use it'  # 必填（10-1024 字元）
license: 'Apache-2.0'              # 可選
metadata:                          # 可選
  author: 'author-name'
  version: '1.0'
---

# Skill Name

## Instructions
[Clear, step-by-step guidance]

## Examples
[Concrete usage examples]
```

---

## 🔧 三、工具權限配置 (Tools)

### **可用工具別名**（不區分大小寫）

| 別名 | 功能 | 對應工具 |
|------|------|----------|
| `execute` | 執行 shell/bash/powershell 命令 | Shell, Bash, PowerShell |
| `read` | 讀取檔案內容 | File reading |
| `edit` | 修改程式碼 | Code editing, editFiles |
| `search` | 檔案/文字搜尋 | File search, text search |
| `agent` | 呼叫其他 custom agents | Agent invocation |
| `web` | URL 抓取與網路搜尋 | Web fetch, web search |
| `todo` | 任務清單管理 | Task list |

### **MCP 伺服器工具** (Model Context Protocol)

**內建 MCP 伺服器**:
- `github/*` - GitHub 唯讀工具（限定 source repo）
- `playwright/*` - 瀏覽器自動化（僅限 localhost）

**命名空間語法**:
```yaml
tools:
  - 'read'
  - 'edit'
  - 'github/get_pull_request'     # 特定工具
  - 'playwright/*'                 # 伺服器所有工具
```

### **工具權限模式**

```yaml
# 模式 1: 所有工具（預設）
# 不指定 tools 欄位，或：
tools: ['*']

# 模式 2: 限制特定工具
tools: ['read', 'search']         # 僅唯讀

# 模式 3: 無工具權限
tools: []
```

---

## 🎯 四、Code Review 相關 Agents

### 📊 **GitHub awesome-copilot 倉庫中的品質/安全 Agents**

| Agent 檔案 | 功能 | 工具 | 模型 |
|-----------|------|------|------|
| `se-security-reviewer.agent.md` | OWASP Top 10, Zero Trust, LLM 安全 | codebase, edit, search, problems | GPT-5 |
| `se-system-architecture-reviewer.agent.md` | Well-Architected frameworks, 可擴展性 | codebase, edit, search | GPT-5 |
| `playwright-tester.agent.md` | Web 應用測試 | playwright/*, execute, edit | Claude Sonnet 4 |
| `diffblue-cover.agent.md` | 自動單元測試生成 | diffblue/* | - |
| `tdd-red.agent.md` | TDD Red phase（失敗測試） | edit, execute | - |
| `tdd-green.agent.md` | TDD Green phase（通過測試） | edit, execute | - |
| `tdd-refactor.agent.md` | TDD Refactor phase（重構） | edit, search | - |
| `janitor.agent.md` | 程式碼清理與維護 | edit, search | - |
| `tech-debt-remediation-plan.agent.md` | 技術債分析與規劃 | search, read | - |

### 📋 **Instructions 檔案（編碼標準）**

| 檔案 | 用途 |
|------|------|
| `code-review-generic.instructions.md` | 通用 code review 指南 |
| 其他 language-specific instructions | 特定語言/框架標準 |

---

## 🚀 五、安裝與使用方式

### 📥 **安裝 Custom Agent**

#### 方法 1: 手動下載（推薦）
```bash
# 1. 建立目錄
mkdir -p .github/agents

# 2. 下載 agent 檔案
curl -o .github/agents/security-reviewer.agent.md \
  https://raw.githubusercontent.com/github/awesome-copilot/main/agents/se-security-reviewer.agent.md

# 3. 提交到版本控制
git add .github/agents/
git commit -m "Add security reviewer agent"
```

#### 方法 2: VS Code 一鍵安裝
- 在 awesome-copilot README 中點擊 "Install in VS Code" 按鈕
- Agent 自動下載到 `.github/agents/`

#### 方法 3: CLI 個人層級（新功能）
```bash
# 安裝到個人 Copilot CLI 設定
mkdir -p ~/.copilot/agents
cp security-reviewer.agent.md ~/.copilot/agents/
```

### 🎮 **啟動 Agent**

#### VS Code / IDE
```
# 在 Copilot Chat 中：
@security-reviewer Review this authentication code

# 或讓 Copilot 自動選擇（infer: true）
Review this code for security issues
```

#### GitHub Copilot CLI
```bash
# 明確指定 agent
gh copilot suggest --agent security-reviewer "review auth.js"

# 委派給 coding agent
gh copilot code --agent coding-agent "fix the security issues"
```

#### Code Review（自動）
- PR 中的 Copilot code-review agent 自動載入 `.instructions.md` 檔案
- 根據 `applyTo` 模式選擇適用的指令

---

## 📐 六、檔案類型選擇指南

### 何時使用 `.agent.md`？

✅ **使用 Agent** 當：
- 需要**專門角色**（如 security reviewer, test specialist）
- 需要**限制工具權限**（如唯讀分析）
- 需要**獨立執行**任務並回報結果
- 需要**整合 MCP 伺服器**（組織層級）
- 希望用戶**明確呼叫**（`@agent-name`）

**範例**:
- Security reviewer（安全審查專家）
- Architecture reviewer（架構審查）
- Test generator（測試生成）
- Performance analyzer（效能分析）

### 何時使用 `.instructions.md`？

✅ **使用 Instructions** 當：
- 定義**編碼標準**與團隊規範
- 設定**自動套用**的審查規則
- 針對**特定檔案類型**提供指南（`applyTo`）
- 希望 code-review agent **自動遵循**

**範例**:
- Code review checklist
- Security guidelines
- Testing standards
- Style guide

### 何時使用 `SKILL.md`？

✅ **使用 Skill** 當：
- 需要**打包知識**為可攜式模組
- 包含**輔助腳本**與參考文件
- 希望**跨專案重用**
- 與 **Claude Code skills 相容**

**範例**:
- Database schema analyzer（含 SQL 腳本）
- API documentation generator（含模板）
- Deployment helper（含 CI/CD 腳本）

---

## 🎨 七、實戰模板範例

### 🔹 **Code Review Agent 模板**

**檔案**: `.github/agents/code-reviewer.agent.md`

```yaml
---
name: 'Code Reviewer'
description: 'Comprehensive code review specialist focusing on security, quality, performance, and best practices. Use when reviewing PRs or conducting code audits.'
tools: ['read', 'search', 'github/*']  # 唯讀 + GitHub 整合
model: 'GPT-4'
infer: true
metadata:
  team: 'engineering'
  category: 'quality-assurance'
---

# Code Reviewer Agent

You are an expert code reviewer with deep knowledge of software engineering best practices, security vulnerabilities, and performance optimization.

## Review Framework

### 1. Initial Analysis
- **Code Type**: Identify if it's API, frontend, data pipeline, or infrastructure
- **Risk Level**: Assign HIGH/MEDIUM/LOW based on:
  - Security implications
  - Performance impact
  - Breaking change potential

### 2. Review Dimensions

#### 🔴 Security (CRITICAL)
- [ ] **OWASP Top 10**
  - Broken Access Control
  - Cryptographic Failures
  - Injection (SQL, XSS, Command)
  - Insecure Design
  - Security Misconfiguration
  - Vulnerable Dependencies
  - Authentication Failures
  - Software Integrity Failures
  - Logging/Monitoring Failures
  - SSRF

- [ ] **Sensitive Data**
  - No hardcoded secrets, API keys, passwords
  - Proper encryption for sensitive data
  - Secure credential management

- [ ] **Input Validation**
  - All user inputs validated
  - Proper sanitization
  - Type checking

#### 🟡 Code Quality (IMPORTANT)
- [ ] **Clean Code**
  - Meaningful variable/function names
  - Single Responsibility Principle
  - DRY (Don't Repeat Yourself)
  - No magic numbers
  - Max nesting level ≤ 3

- [ ] **Error Handling**
  - Comprehensive try-catch blocks
  - Meaningful error messages
  - Proper logging
  - Graceful degradation

#### 🟢 Performance (SUGGESTION)
- [ ] **Database**
  - No N+1 query problems
  - Proper indexing
  - Query optimization
  - Connection pooling

- [ ] **Algorithms**
  - Efficient data structures
  - Time/space complexity analysis
  - Caching strategies

#### 📋 Testing
- [ ] **Coverage**
  - Unit tests for business logic
  - Integration tests for APIs
  - Edge case coverage

- [ ] **Test Quality**
  - Arrange-Act-Assert pattern
  - Descriptive test names
  - Independent tests
  - No flaky tests

### 3. Output Format

Generate review in this structure:

\`\`\`markdown
## Code Review Report: [Component Name]
**Date**: [YYYY-MM-DD]
**Reviewer**: Code Reviewer Agent
**Risk Level**: [HIGH/MEDIUM/LOW]

---

### 🔴 Critical Issues (BLOCKS MERGE)
| File:Line | Issue | Impact | Fix |
|-----------|-------|--------|-----|
| auth.ts:42 | SQL Injection vulnerability | Data breach risk | Use parameterized queries |

### 🟡 Important Issues (REQUIRES DISCUSSION)
| File:Line | Issue | Impact | Suggestion |
|-----------|-------|--------|------------|
| api.ts:15 | Missing error handling | Poor UX on failure | Add try-catch block |

### 🟢 Suggestions (NON-BLOCKING)
| File:Line | Suggestion | Benefit |
|-----------|------------|---------|
| utils.ts:8 | Extract to helper function | Improved reusability |

---

### ✅ Positive Highlights
- Excellent test coverage (95%)
- Well-structured component architecture
- Good use of TypeScript types

---

### 📊 Review Summary
- **Files Reviewed**: 12
- **Critical**: 1
- **Important**: 3
- **Suggestions**: 7

### 🎯 Recommendation
**[APPROVE / REQUEST CHANGES / COMMENT]**

**Rationale**: [Brief explanation]
\`\`\`

### 4. Review Principles
- **Be Specific**: Always reference file:line
- **Provide Context**: Explain WHY it's an issue
- **Suggest Solutions**: Include code examples
- **Be Constructive**: Acknowledge good practices
- **Be Pragmatic**: Balance perfection vs. delivery

### 5. Escalation Criteria
Immediately flag to human reviewer if:
- Security vulnerability with HIGH risk
- Breaking change to public API
- Performance degradation > 20%
- Compliance violations (GDPR, HIPAA, etc.)

## Tools Usage
- **read**: Analyze code files
- **search**: Find similar patterns in codebase
- **github/get_pull_request**: Fetch PR context
- **github/list_commits**: Review commit history

## Example Usage

**User**: "Review this authentication implementation"

**Agent Response**:
1. Read auth-related files
2. Search for existing auth patterns
3. Check for OWASP vulnerabilities
4. Verify test coverage
5. Generate structured report
6. Provide actionable recommendations
```

---

### 🔹 **Security Audit Instructions 模板**

**檔案**: `.github/instructions/security-audit.instructions.md`

```yaml
---
description: 'Security audit guidelines for all code changes. Automatically applied to code review agent.'
applyTo: '**.js, **.ts, **.py, **.java, **.cs, **.go'
excludeAgent: ''  # Apply to all agents
---

# Security Audit Instructions

When reviewing code, always perform security checks in this order:

## 1. Authentication & Authorization
```javascript
// ❌ BAD: No authentication check
app.get('/api/user/:id', async (req, res) => {
  const user = await db.getUser(req.params.id);
  res.json(user);
});

// ✅ GOOD: Proper auth + authorization
app.get('/api/user/:id', authenticateUser, async (req, res) => {
  const requestedUserId = req.params.id;
  if (req.user.id !== requestedUserId && !req.user.isAdmin) {
    return res.status(403).json({ error: 'Forbidden' });
  }
  const user = await db.getUser(requestedUserId);
  res.json(user);
});
```

## 2. Input Validation
```javascript
// ❌ BAD: Direct use of user input
const query = `SELECT * FROM users WHERE email = '${req.body.email}'`;

// ✅ GOOD: Parameterized query
const query = 'SELECT * FROM users WHERE email = ?';
const result = await db.query(query, [req.body.email]);
```

## 3. Sensitive Data Handling
- [ ] No secrets in code (use environment variables)
- [ ] No sensitive data in logs
- [ ] Proper encryption for PII
- [ ] Secure session management

## 4. Dependency Security
- [ ] Run `npm audit` or equivalent
- [ ] Check for known vulnerabilities
- [ ] Keep dependencies up to date
- [ ] Use lock files (package-lock.json, yarn.lock)

## 5. Output Encoding
```javascript
// ❌ BAD: XSS vulnerability
res.send(`<h1>Welcome ${req.query.name}</h1>`);

// ✅ GOOD: Proper escaping
const sanitized = escapeHtml(req.query.name);
res.send(`<h1>Welcome ${sanitized}</h1>`);
```

## Review Checklist
When you find a security issue, categorize it:

- **CRITICAL** 🔴: Exploitable vulnerability (SQL injection, XSS, auth bypass)
- **HIGH** 🟠: Potential security risk (weak crypto, missing validation)
- **MEDIUM** 🟡: Security best practice violation (hardcoded secrets)
- **LOW** 🔵: Security improvement (add security headers)

Always provide:
1. **What**: The vulnerability
2. **Why**: The risk/impact
3. **How**: Fix with code example
4. **Reference**: Link to OWASP or CWE
```

---

### 🔹 **Testing Standards Skill 模板**

**目錄**: `.github/skills/testing-standards/`

**檔案**: `SKILL.md`
```yaml
---
name: testing-standards
description: 'Comprehensive testing guidelines and patterns for unit, integration, and E2E tests. Use when writing or reviewing tests.'
license: MIT
metadata:
  team: quality-engineering
  version: 2.0
---

# Testing Standards Skill

## Test Structure

### Unit Tests
```typescript
// Use Arrange-Act-Assert pattern
describe('UserService', () => {
  describe('createUser', () => {
    it('should create user with hashed password', async () => {
      // Arrange
      const userData = { email: 'test@example.com', password: 'secret123' };
      const mockHash = jest.fn().mockResolvedValue('hashed_password');

      // Act
      const user = await userService.createUser(userData, mockHash);

      // Assert
      expect(user.password).toBe('hashed_password');
      expect(mockHash).toHaveBeenCalledWith('secret123');
    });
  });
});
```

### Integration Tests
```typescript
describe('User API', () => {
  beforeAll(async () => {
    await db.migrate.latest();
  });

  afterAll(async () => {
    await db.destroy();
  });

  it('POST /api/users should create user and return 201', async () => {
    const response = await request(app)
      .post('/api/users')
      .send({ email: 'test@example.com', password: 'secret123' })
      .expect(201);

    expect(response.body).toHaveProperty('id');
    expect(response.body.email).toBe('test@example.com');
  });
});
```

## Test Naming Conventions

**Format**: `should [expected behavior] when [condition]`

Examples:
- ✅ `should return 404 when user not found`
- ✅ `should throw ValidationError when email is invalid`
- ❌ `test user creation` (too vague)

## Coverage Requirements

- **Unit Tests**: ≥ 80% code coverage
- **Integration Tests**: All API endpoints
- **E2E Tests**: Critical user flows

## Test Independence

Each test must:
- [ ] Run independently (no shared state)
- [ ] Clean up after itself
- [ ] Use fresh test data
- [ ] Not depend on execution order

## Mocking Guidelines

Mock external dependencies:
- Database calls
- API requests
- File system operations
- Time-dependent functions

```typescript
// ✅ GOOD: Mock external API
jest.mock('axios');
mockedAxios.get.mockResolvedValue({ data: mockData });

// ❌ BAD: Real API call in tests
const data = await axios.get('https://api.example.com/data');
```

## Edge Cases to Test

- [ ] Empty inputs
- [ ] Null/undefined values
- [ ] Boundary values (0, -1, MAX_INT)
- [ ] Invalid data types
- [ ] Concurrent requests
- [ ] Network failures
- [ ] Timeouts

## References

See `examples/test-examples.ts` for complete patterns.
```

**檔案**: `examples/test-examples.ts` (輔助檔案)
```typescript
// Complete test examples referenced in SKILL.md
// [Full code examples here...]
```

---

## 🔄 八、Claude Code vs GitHub Copilot 對照表

| 特性 | Claude Code | GitHub Copilot |
|------|-------------|----------------|
| **Agent 檔案** | `.claude/agents/*.md` | `.github/agents/*.agent.md` |
| **Skill 檔案** | `.claude/skills/*/SKILL.md` | `.github/skills/*/SKILL.md` |
| **Instructions** | `CLAUDE.md` (較少使用) | `.github/copilot-instructions.md` |
| **通用 Agent 檔** | 不支援 | `AGENTS.md` (跨 AI 平台) |
| **工具限制** | `allowed-tools:` | `tools:` |
| **模型選擇** | `model: sonnet/opus/haiku` | `model: GPT-4/GPT-5` |
| **MCP 支援** | 透過 Claude MCP | `mcp-servers:` (組織層級) |
| **啟動方式** | 自動語義匹配 | `@agent-name` + 自動推斷 |
| **CLI 支援** | `claude` 命令 | `gh copilot` 命令 |
| **內建 Agents** | Explore, Plan, General-purpose | coding-agent, code-review |

### 🔄 **跨平台相容性**

**SKILL.md 格式是跨平台的！**
```
✅ Claude Code 支援
✅ GitHub Copilot 支援
✅ 其他 AI platforms（AGENTS.md）
```

**建議做法**:
1. **Skills** 用標準 `SKILL.md` → 跨平台相容
2. **Agents** 用平台特定格式：
   - Claude: `.claude/agents/name.md`
   - Copilot: `.github/agents/name.agent.md`

---

## 💡 九、最佳實踐

### ✅ **Agent 設計原則**

1. **單一職責**
   - 一個 agent 專注一個角色
   - 不要創建「萬能 agent」

2. **明確描述**
   - `description` 清楚說明「何時」使用
   - 包含觸發關鍵字

3. **工具最小權限**
   - 只授予必要工具
   - Security reviewer 用 `['read', 'search']`（唯讀）
   - Code generator 用 `['read', 'edit']`

4. **輸出格式標準化**
   - 定義明確的 markdown 輸出模板
   - 使用表格、清單、程式碼區塊

5. **範例導向**
   - 在 agent 指令中包含 ❌ BAD / ✅ GOOD 範例
   - 提供完整的輸出範例

### ✅ **Instructions 設計原則**

1. **條件式套用**
   - 使用 `applyTo` 限定檔案類型
   - 使用 `excludeAgent` 排除特定 agent

2. **優先級清楚**
   - 使用 🔴🟡🟢 emoji 標記嚴重性
   - CRITICAL / IMPORTANT / SUGGESTION

3. **檢查清單化**
   - 提供 `[ ]` checkbox 清單
   - 易於追蹤與驗證

### ✅ **Skill 設計原則**

1. **模組化**
   - 一個 skill 一個目錄
   - 相關檔案打包在一起

2. **漸進式揭露** (Progressive Disclosure)
   - SKILL.md 保持簡潔
   - 詳細內容放 `reference.md`
   - 複雜邏輯寫成 `scripts/`

3. **可重用性**
   - 設計為跨專案可用
   - 避免硬編碼專案特定路徑

---

## 📊 十、社群資源統計

### 📈 **github/awesome-copilot 倉庫分析**

**檔案數量統計**:
```
agents/              127 files (.agent.md)
prompts/             40+ files (.prompt.md)
instructions/        30+ files (.instructions.md)
skills/              15+ folders (SKILL.md)
collections/         10+ themed collections
```

**熱門分類**:
| 分類 | Agent 數量 | 代表範例 |
|------|-----------|---------|
| **Language-Specific** | 35+ | Python, TypeScript, Rust, Go, C# |
| **Cloud Platforms** | 20+ | Azure, AWS, GCP |
| **Security** | 15+ | Security reviewer, Responsible AI |
| **Testing** | 12+ | Playwright, TDD, Diffblue |
| **Architecture** | 10+ | System architect, API designer |
| **DevOps** | 10+ | CI/CD, Docker, Kubernetes |
| **Data** | 8+ | SQL, MongoDB, Analytics |

### 🔗 **重要連結**

**官方資源**:
- [GitHub Copilot Agents](https://github.com/features/copilot/agents)
- [awesome-copilot Repository](https://github.com/github/awesome-copilot)
- [Custom Agents Docs](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/coding-agent/create-custom-agents)
- [Agent Skills Blog](https://github.blog/changelog/2025-12-18-github-copilot-now-supports-agent-skills/)
- [Writing great agents.md](https://github.blog/ai-and-ml/github-copilot/how-to-write-a-great-agents-md-lessons-from-over-2500-repositories/)

**社群資源**:
- [Awesome Copilot Customizations](https://developer.microsoft.com/blog/introducing-awesome-github-copilot-customizations-repo)
- [5 Tips for Better Instructions](https://github.blog/ai-and-ml/github-copilot/5-tips-for-writing-better-custom-instructions-for-copilot/)

---

## 🚀 十一、快速開始指南

### Step 1: 選擇模板類型

```bash
# 決策樹
需要專門角色？ → 使用 .agent.md
  ├─ 是：需要限制工具？ → tools: ['read', 'search']
  ├─ 是：需要整合 MCP？ → 添加 mcp-servers 設定
  └─ 否：使用預設所有工具

定義編碼標準？ → 使用 .instructions.md
  ├─ 針對特定檔案？ → applyTo: '**.ts, **.js'
  └─ 排除某些 agent？ → excludeAgent: 'agent-name'

打包可重用知識？ → 使用 SKILL.md
  ├─ 包含腳本？ → 建立 scripts/ 目錄
  └─ 需要範例？ → 建立 examples/ 目錄
```

### Step 2: 下載範本

```bash
# Clone awesome-copilot
git clone https://github.com/github/awesome-copilot.git
cd awesome-copilot

# 複製需要的 agent
cp agents/se-security-reviewer.agent.md ../my-project/.github/agents/

# 或下載單一檔案
curl -o .github/agents/security.agent.md \
  https://raw.githubusercontent.com/github/awesome-copilot/main/agents/se-security-reviewer.agent.md
```

### Step 3: 客製化

```yaml
# 編輯 .github/agents/security.agent.md
---
name: 'My Security Reviewer'  # 改名稱
description: 'Security review for [YOUR PROJECT] focusing on [SPECIFIC RISKS]'  # 加專案脈絡
tools: ['read', 'search', 'github/*']  # 限制工具
model: 'GPT-4'  # 選擇模型
metadata:
  team: 'your-team'  # 加團隊資訊
  compliance: 'SOC2, HIPAA'  # 加合規要求
---

# 在指令中添加專案特定規則
## Your Project Specific Rules
- Check for [specific vulnerability in your stack]
- Verify [custom authentication flow]
- Validate [business logic constraints]
```

### Step 4: 測試

```bash
# VS Code
# 在 Copilot Chat 輸入：
@my-security-reviewer Review auth.ts for security issues

# CLI
gh copilot suggest --agent my-security-reviewer "review authentication code"
```

### Step 5: 迭代改進

```bash
# 收集回饋
# 1. Agent 有沒有漏掉重要檢查？ → 補充到指令
# 2. 工具權限是否足夠？ → 調整 tools
# 3. 輸出格式是否清楚？ → 改進模板

# 版本控制
git add .github/agents/
git commit -m "feat: add custom security reviewer agent"
```

---

## 🎓 十二、進階技巧

### 🔹 **Agent 協作模式**

定義多個專門 agents 協作：

```yaml
# .github/agents/lead-reviewer.agent.md
---
name: 'Lead Reviewer'
description: 'Orchestrates comprehensive code review by delegating to specialist agents'
tools: ['read', 'search', 'agent']  # 包含 'agent' 工具
---

When reviewing code:

1. **Delegate Security Review**
   - Invoke @security-reviewer for auth, crypto, input validation
   - Wait for security report

2. **Delegate Performance Review**
   - Invoke @performance-analyzer for DB queries, algorithms
   - Wait for performance report

3. **Delegate Architecture Review**
   - Invoke @architect-reviewer for design patterns, scalability
   - Wait for architecture report

4. **Synthesize Results**
   - Combine all reports
   - Prioritize findings
   - Generate executive summary

Output format:
\`\`\`markdown
## Comprehensive Review: [Component]

### Executive Summary
[Overall assessment from all specialists]

### Security Findings (@security-reviewer)
[Security report here]

### Performance Findings (@performance-analyzer)
[Performance report here]

### Architecture Findings (@architect-reviewer)
[Architecture report here]

### Consolidated Recommendations
[Prioritized action items]
\`\`\`
```

### 🔹 **條件式 Instructions**

針對不同檔案類型套用不同規則：

```bash
# .github/instructions/
├── frontend.instructions.md      # applyTo: '**.tsx, **.jsx'
├── backend.instructions.md       # applyTo: '**.ts (src/api/**)'
├── database.instructions.md      # applyTo: '**.sql, **.prisma'
└── test.instructions.md          # applyTo: '**.test.ts, **.spec.ts'
```

### 🔹 **MCP 伺服器整合**（組織層級）

```yaml
# org/.github/agents/database-expert.agent.md
---
name: 'Database Expert'
description: 'PostgreSQL specialist with schema analysis and query optimization'
tools: ['read', 'search', 'postgresql/*']
mcp-servers:
  postgresql:
    type: 'local'
    command: 'npx'
    args: ['-y', '@modelcontextprotocol/server-postgres']
    env:
      DATABASE_URL: ${{ secrets.STAGING_DB_URL }}
---

You have access to PostgreSQL MCP server tools:
- postgresql/list_tables
- postgresql/describe_table
- postgresql/execute_query

Use these to analyze database schema and optimize queries.
```

---

## 📝 十三、常見問題 FAQ

### Q1: .agent.md vs .instructions.md 何時用？

**A**:
- **Agent**: 明確的「角色」，需要主動呼叫或自動推斷（如 `@security-reviewer`）
- **Instructions**: 「規範」，自動套用到符合條件的檔案（`applyTo`）

**範例**:
- ✅ Agent: "Security reviewer" （專門角色）
- ✅ Instructions: "Security checklist for all JS files" （自動規範）

### Q2: 可以混用 Claude Code 和 Copilot 的模板嗎？

**A**: 部分相容
- **SKILL.md**: ✅ 完全相容（兩者都支援）
- **AGENTS.md**: ✅ 通用格式（多平台）
- **.agent.md**: ⚠️ 需調整 frontmatter 欄位

**轉換建議**:
```yaml
# Claude Code → Copilot
# FROM:
---
name: code-reviewer
description: ...
tools: Read, Write, Edit
model: sonnet
---

# TO:
---
name: code-reviewer
description: ...
tools: ['read', 'edit']  # 陣列格式
model: 'GPT-4'
---
```

### Q3: 如何測試 agent 是否正常運作？

**A**:
1. **VS Code**: Copilot Chat 中輸入 `@agent-name test prompt`
2. **CLI**: `gh copilot suggest --agent agent-name "test query"`
3. **驗證**:
   - Agent 是否被正確辨識？
   - 輸出格式是否符合預期？
   - 工具權限是否正確？

### Q4: Agent 數量有限制嗎？

**A**:
- **技術限制**: 無硬性上限
- **實務建議**: 保持 5-15 個專門 agents
- **原因**: 太多 agent 會降低自動推斷準確度

### Q5: 如何分享 agent 給團隊？

**A**:
```bash
# 方法 1: 版本控制（推薦）
git add .github/agents/
git add .github/instructions/
git commit -m "Add team agents"
git push

# 方法 2: 組織層級（企業功能）
# 放在 org/.github/agents/
# 自動套用到所有倉庫

# 方法 3: 手動分享
# 複製 .agent.md 檔案給團隊成員
```

---

## 🎉 結論

GitHub Copilot 的 agent/skill 系統現已成熟，提供：

✅ **127+ 社群 agents** 可立即使用
✅ **3 種檔案類型** 滿足不同需求
✅ **跨平台 SKILL.md** 與 Claude Code 相容
✅ **完整 MCP 支援** 擴展工具能力
✅ **官方文件齊全** 快速上手

### 🚀 **立即行動**

1. **Clone awesome-copilot**: `git clone https://github.com/github/awesome-copilot.git`
2. **選擇 agent**: 從 127 個中挑選適合的
3. **客製化**: 根據專案需求調整
4. **測試**: 在實際工作流中驗證
5. **分享**: 提交到版本控制，讓團隊受益

---

**文件版本**: 1.0
**最後更新**: 2025-12-28
**資料來源**: GitHub 官方文件 + awesome-copilot 倉庫
**相容性**: GitHub Copilot (2024-2025), VS Code, CLI

---

*本指南基於官方文件與社群最佳實踐整理而成。*

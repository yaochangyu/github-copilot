# AI 指令連結腳本

本目錄包含用於同步 AI 指令文件的 PowerShell 腳本。

## 用途

[link-ai-instructions.ps1](link-ai-instructions.ps1) 會將本目錄的 copilot-instructions.md 連結到下列位置：

- Windows 使用者家目錄：
  - %USERPROFILE%\.github\copilot-instructions.md
  - %USERPROFILE%\.copilot\copilot-instructions.md
  - %USERPROFILE%\.claude\CLAUDE.md
  - %USERPROFILE%\.gemini\GEMINI.md
- WSL (Ubuntu-24.04) 使用者家目錄：
  - /home/yao/.github/copilot-instructions.md
  - /home/yao/.copilot/copilot-instructions.md
  - /home/yao/.claude/CLAUDE.md
  - /home/yao/.gemini/GEMINI.md

## 使用方式

1. 確認 copilot-instructions.md 位於本目錄。
2. 以 PowerShell 5.1 以上版本執行 link-ai-instructions.ps1：

  ```powershell
  .\link-ai-instructions.ps1
  ```

## 注意事項

- 腳本會先移除既有目標檔案，再建立連結。
- 若 WSL 發行版或使用者家目錄不同，需修改腳本中的 wsl.exe 參數或 $wslHome。

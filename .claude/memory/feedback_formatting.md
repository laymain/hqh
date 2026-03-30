---
name: Code formatting rules
description: Formatting standards to apply to all GDScript files in this project
type: feedback
---

Always use **4 spaces** for indentation (never tabs) in all GDScript files.

**Why:** The project `.editorconfig` enforces `indent_style = space` / `indent_size = 4`. Using tabs causes linter corrections and inconsistency.

**How to apply:** Any time a `.gd` file is written or edited, verify indentation is 4 spaces. Also respect: `charset = utf-8`, `end_of_line = lf`, `trim_trailing_whitespace = true`, `insert_final_newline = true`.

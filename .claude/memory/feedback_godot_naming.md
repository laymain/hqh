---
name: Godot reserved field names to avoid
description: Field and parameter names that shadow Godot built-ins and must not be used
type: feedback
---

Two rules to follow strictly:

1. **`p_` prefix is allowed in `_init()` constructors only**, to avoid the SHADOWED_VARIABLE warning when parameters share names with class fields. Never use it in regular functions.

2. **Never use Godot built-in names as fields or parameters** — `owner`, `name`, `position`, `rotation`, etc. shadow `Node` properties and cause confusion even on non-Node classes.

**Why:** The user caught `p_caster`/`p_aim_pos` in `AbilityContext._init()` and `owner` as a field name in the same class.

**How to apply:** Parameters are always plain `snake_case`. For "who triggered this" fields, prefer `caster`, `source`, `instigator` over `owner`.

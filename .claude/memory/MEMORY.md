# Memory Index

## Reference
- [Project architecture guidelines](reference_architecture.md) — all code must follow ARCHITECTURE.md: layered design, strict typing, DI, signals-via-code, resource-first data, naming conventions

## Feedback
- [Code formatting rules](feedback_formatting.md) — 4-space indentation, follow .editorconfig in all GDScript files
- [Component design preferences](feedback_component_design.md) — don't cache `_stats` if `_character` is already held; use `_character.stats` directly
- [Godot reserved field names](feedback_godot_naming.md) — never use `owner` or other Node built-in names as field/param names; prefer `caster`, `source`, `character`

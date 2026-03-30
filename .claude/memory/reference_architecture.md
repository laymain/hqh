---
name: Project architecture guidelines
description: All code in this project must follow the SOLID, component-based, data-driven architecture described in ARCHITECTURE.md
type: reference
---

All code written for this project must follow the guidelines in `ARCHITECTURE.md` at the project root.

Key rules:
- **Layered architecture:** DNA (Resources) → Body (Components) → Messenger (Payloads)
- **Strict typing:** All variables, parameters, and return types must be statically typed
- **Signals via code:** Connect signals in `_ready()` / `init()`, never via the Editor tab
- **Dependency Injection:** Parent `Character` / `Spawner` injects references into components; no `get_parent().get_node(...)` chains
- **Resource-First Data:** Tunable values (damage, speed, cooldown) belong in `.tres` Resources, not hardcoded
- **Naming conventions:** Follow the table in section 9 (PascalCase classes, snake_case vars/funcs, _prefix for private, SCREAMING_SNAKE for constants/enum values)
- **No Godot built-in shadows:** Never use `owner`, `name`, `position`, etc. as field/param names
- **Singletons for cross-cutting concerns only:** Components emit signals to global managers, never call them to mutate own state
- **YAGNI / Open-Closed:** Extend via components and signals; avoid rewriting core orchestrators to add features

---
name: Component design preferences
description: How components should reference character data and dependencies
type: feedback
---

When a component already holds a `_character: Character` reference, **do not cache a separate `_stats` field** — access stats directly via `_character.stats`.

**Why:** Avoids redundant references and keeps the component's state minimal. The user refactored `CombatComponent` to remove `_stats` in favour of `_character.stats`.

**How to apply:** In any component that receives a `Character` in `setup()`, prefer `_character.stats.x` over storing `_stats = character.stats` as a separate member.

# Guild of Highly Questionable Heroes - Global Roadmap

This roadmap outlines the long-term vision for *Guild of Highly Questionable Heroes*, inspired by the tactical depth and comedic chaos of *Raiders of Blackveil*.

---

## 🟢 Milestone 1: The SOLID Core (Foundation)
*Goal: Move from "prototype code" to a scalable system where adding a new hero takes minutes.*
- [ ] **Data-Driven DNA:** Implement `CharacterStats` resources to replace hardcoded exports.
- [ ] **The Messenger Layer:** Implement `DamageInfo` payloads for all combat interactions.
- [ ] **Body Layer (Components):** Extract `Health`, `Combat`, and `Defense` logic into reusable nodes.
- [ ] **Unified Orchestrator:** Refactor `Character.gd` to act as a pure component coordinator.
- [ ] **Command Interface:** Standardize the `CharacterController` to handle Player and AI inputs identically.

## 🟡 Milestone 2: Tactical Combat & Mitigation
*Goal: Implement the deep, layered math and comedic modifiers.*
- [ ] **Layered Defense:** Implementation of **Dodge → Barrier → Armor → Health** logic.
- [ ] **The Interceptor System:** Create a synchronous `PerkRegistry` for complex modifiers (e.g., *"Certified Fire Inspector"*).
- [ ] **Authority Isolation:** Decouple all visual feedback (Floating Text, Shakes, SFX) from game logic.
- [ ] **Status Effect System:** Implement duration-based and stacking debuffs (Bleed, Burn, Bureaucratic Delay).

## 🟠 Milestone 3: The Dungeon Loop
*Goal: Connect the combat to the procedural world.*
- [ ] **Generator Integration:** Spawn characters and interactive objects into procedurally generated maps.
- [ ] **Interaction Framework:** Standardize how heroes interact with doors, chests, and "Questionable" shrines.
- [ ] **Enemy AI Loop:** Implement patrol, chase, and ability-use states for dungeon denizens.
- [ ] **Combat Encounters:** Define "Rooms" and "Waves" for tactical positioning challenges.

## 🔴 Milestone 4: The Meta & Progression
*Goal: Create persistent value and "Guild" management.*
- [ ] **Inventory & Gear:** Use resources to define items that modify a character's base `CharacterStats`.
- [ ] **Squad Management:** Logic for switching between heroes or managing a small group of questionable characters.
- [ ] **The Guild Hub:** A persistent "Home Base" for upgrades and hero recruitment.
- [ ] **Persistent Fail State:** Handling hero death and meta-progression currency.

---

## Current Status: 🏗️ Milestone 1 in Progress
*Next Step: Implement `DamageInfo` and `CharacterStats` resources.*

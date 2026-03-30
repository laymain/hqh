# Guild of Highly Questionable Heroes - Global Roadmap

This roadmap outlines the long-term vision for *Guild of Highly Questionable Heroes*, inspired by the tactical depth and comedic chaos of *Raiders of Blackveil*.

---

## 🟢 Milestone 1: The SOLID Core (Foundation)
*Goal: Move from "prototype code" to a scalable system where adding a new hero takes minutes.*
- [x] **Data-Driven DNA:** Implement `CharacterStats` resources to replace hardcoded exports.
- [x] **The Messenger Layer:** Implement `DamageInfo` payloads for all combat interactions.
- [x] **Body Layer (Components):** Extract `Health`, `Combat`, and `Defense` logic into reusable nodes.
- [x] **Unified Orchestrator:** Refactor `Character.gd` to act as a pure component coordinator.
- [x] **Command Interface:** Standardize the `CharacterController` to handle Player and AI inputs identically.
- [x] **MOBA Aiming:** Decoupled movement and facing direction for action-oriented feel.

## 🟡 Milestone 2: Tactical Combat & Mitigation
*Goal: Implement the deep, layered math and comedic modifiers.*
- [ ] **Layered Defense:** Implementation of **Dodge → Barrier → Armor → Health** logic in `DefenseComponent`.
- [ ] **The Interceptor System:** Create a synchronous `PerkRegistry` for complex modifiers (e.g., *"Certified Fire Inspector"*).
- [ ] **Authority Isolation:** Decouple all visual feedback (Floating Text, Shakes, SFX) from game logic (Currently partially done in `CharacterVisuals`).
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

## Current Status: 🏗️ Milestone 2 Starting
*Next Step: Implement Layered Mitigation (Dodge/Barrier/Armor) in DefenseComponent.*

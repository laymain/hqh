  ## Collision-First Character Controller Integration Plan

  ### Summary

  Add robust GridMap collisions in dungeon_ml.meshlib using simple primitive colliders, then introduce a CharacterBody3D player controller that replaces free-
  fly gameplay camera. Keep mesh/collision alignment deterministic, verify with physics debug, then hook spawn to map markers.

  ### Scope

  - In scope:
      - MeshLibrary collision authoring for all tile types used by MapManager (W, F, C, R, G)
      - Player controller scene + script (movement, gravity, jump/crouch optional, mouse look)
      - Main scene integration and camera ownership transfer
      - Validation pass on generated maps (data/maps/test.json)
  - Out of scope (for this pass):
      - Enemy AI/combat
      - Full marker-driven encounter spawning
      - Network/multiplayer

  ### Important Interface Changes

  - Runtime scene structure:
      - Add Player (CharacterBody3D) to main.tscn
      - Remove or disable free_look_camera.gd control path for gameplay
  - Script-level contract:
      - MapManager remains map builder, but no longer owns gameplay camera positioning
  - Data contract (next-step ready, not mandatory in this pass):
      - Read markers from map JSON and spawn player at first START marker when available

  ### Implementation Plan

  1. Normalize tile collision design in MeshLibrary

  - Open dungeon_ml.meshlib in MeshLibrary editor.
  - For each mesh item name used by scripts/map/map_manager.gd:
      - template-wall, template-corner, gate: add blocking BoxShape3D approximating visual bounds.
      - template-floor, template-floor-detail, corridor: add thin walkable BoxShape3D (flat top, minimal thickness).
  - Keep collision profiles consistent:
      - Same floor-top Y for all walkable tiles.
      - Same wall thickness behavior to avoid corner gaps.

  2. Resolve mesh/collision transform mismatch risk

  - Current setup_mesh_transforms() shifts mesh visuals at runtime (scripts/map/map_manager.gd:92) but does not explicitly shift collision shapes.
  - Chosen approach:
      - Move alignment responsibility into MeshLibrary item setup (or source tile pivots), then remove runtime mesh shifting logic.
  - Result:
      - Visual mesh and collider stay perfectly aligned for all GridMap instances.

  3. Enable and verify GridMap physics behavior

  - Confirm each generated GridMap has expected collision layer/mask (default world layer for static geometry).
  - Keep Jolt physics (project.godot) as-is.
  - Validation:
      - Use “Visible Collision Shapes” in editor.
      - Walk test corridor joins, gate thresholds, corners, and room edges.

  4. Add player controller

  - Create scenes/player.tscn:
      - CharacterBody3D root
      - CollisionShape3D (capsule)
      - Node3D head pivot + Camera3D
  - Create scripts/player_controller.gd:
      - Grounded movement + gravity
      - Jump optional (Space)

  5. Spawn and map integration

  - Initial default: spawn at map center if no marker integration yet.
  - Next immediate step: read markers array from map JSON and spawn at type == "START" position.

  6. Stability polish

  - Controller tuning targets:
      - No wall snagging at 90° corners
      - Smooth transition room↔corridor↔gate
      - Predictable head height vs gate clearance
  - If snagging appears:
      - Slightly reduce capsule radius
      - Simplify nearby wall/gate collider bounds
      - Keep floor colliders flat and non-overlapping at seams

  ### Test Cases and Scenarios

  1. Load data/maps/test.json and verify player stands on all walkable tile variants (F, detail floor, R).
  2. Run into every blocker type (W, C, G) and confirm no penetration.
  3. Traverse gate transitions both directions; no popping/sticking.
  4. Walk across tile boundaries at shallow angles; no micro-catches.
  5. Validate in collision debug that visual and collider positions match exactly.
  6. Confirm camera is player-owned and no free-fly camera interference remains.

  ### Assumptions and Defaults

  - Collision strategy: Simple primitives (selected).
  - Gameplay target: first-person controller, single player.
  - MapManager continues to generate level geometry from JSON layers unchanged.
  - Marker-driven spawning is treated as the immediate follow-up after controller baseline is stable.

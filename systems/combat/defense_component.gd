class_name DefenseComponent extends DamageProcessor

var _character: Character

func setup(character: Character) -> void:
    _character = character

## Processes the incoming DamageInfo
func process_damage(_info: DamageInfo) -> void:
    # Placeholder for Layered Mitigation logic (Phase 3)
    # 1. Dodge Check
    # 2. Barrier Check
    # 3. Armor Check
    pass

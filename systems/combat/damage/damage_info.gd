class_name DamageInfo extends RefCounted

## Raw damage amount before any mitigation.
var raw_amount: float = 0.0

## The amount that will actually be applied to health after all layers.
var final_amount: float = 0.0

## Reference to the character that caused this damage.
var attacker: Character = null

## The type of damage (Physical, Fire, etc.)
var damage_type: Enums.DamageType = Enums.DamageType.PHYSICAL

## Whether this hit was a critical strike.
var is_crit: bool = false

## Knockback impulse force to apply to the target.
var knockback_force: float = 0.0

## Normalized direction the knockback should push the target.
var knockback_direction: Vector3 = Vector3.ZERO

## A log of what reduced or increased the damage (e.g. ["Barrier -10", "Armor -2"]).
var mitigation_history: Array[String] = []

func _init(_raw_amount: float = 0.0, _attacker: Character = null, _type: Enums.DamageType = Enums.DamageType.PHYSICAL) -> void:
    raw_amount = _raw_amount
    final_amount = _raw_amount
    attacker = _attacker
    damage_type = _type

## For future multiplayer/persistence.
func to_dict() -> Dictionary:
    return {
        "raw_amount": raw_amount,
        "final_amount": final_amount,
        "damage_type": damage_type,
        "is_crit": is_crit,
        "mitigation_history": mitigation_history
        # 'attacker' reference usually handled by NodePath or ID in netcode.
    }

func from_dict(data: Dictionary) -> void:
    raw_amount = data.get("raw_amount", 0.0)
    final_amount = data.get("final_amount", 0.0)
    damage_type = data.get("damage_type", Enums.DamageType.PHYSICAL)
    is_crit = data.get("is_crit", false)
    mitigation_history = data.get("mitigation_history", [])

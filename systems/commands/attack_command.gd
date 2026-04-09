class_name AttackCommand extends RefCounted

var targets: Array[Character]
var multiplier: float
var damage_type: Enums.DamageType
var knockback_force: float

func _init(p_targets: Array[Character], p_multiplier: float, p_damage_type: Enums.DamageType, p_knockback_force: float) -> void:
    targets = p_targets
    multiplier = p_multiplier
    damage_type = p_damage_type
    knockback_force = p_knockback_force

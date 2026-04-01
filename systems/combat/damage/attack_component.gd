class_name AttackComponent extends Node

var _character: Character

func setup(character: Character) -> void:
    _character = character

func roll_damage(multiplier: float, damage_type: Enums.DamageType) -> DamageInfo:
    var raw := _character.stats.base_power * multiplier
    var is_crit := randf() < _character.stats.crit_chance
    if is_crit:
        raw *= _character.stats.crit_multiplier
    var info := DamageInfo.new(raw, _character, damage_type)
    info.is_crit = is_crit
    return info

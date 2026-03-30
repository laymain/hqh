class_name AbilityContext extends RefCounted

var caster: Character
var aim_pos: Vector3

func _init(p_caster: Character, p_aim_pos: Vector3) -> void:
    caster = p_caster
    aim_pos = p_aim_pos

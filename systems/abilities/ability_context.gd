class_name AbilityContext extends RefCounted

var caster: Character
var aim_pos: Vector3
var combo_index: int

func _init(p_caster: Character, p_aim_pos: Vector3, p_combo_index: int = 0) -> void:
    caster = p_caster
    aim_pos = p_aim_pos
    combo_index = p_combo_index

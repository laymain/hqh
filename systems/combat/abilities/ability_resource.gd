class_name AbilityResource extends Resource

@export var id: String
@export var animations: Array[StringName] = []
@export var cooldown: float
@export var damage_multipliers: Array[float] = [1.0]
@export var handler_scene: PackedScene


func get_animation(index: int) -> StringName:
    if animations.is_empty():
        return &""
    return animations[index % animations.size()]


func get_multiplier(index: int) -> float:
    if damage_multipliers.is_empty():
        return 1.0
    return damage_multipliers[index % damage_multipliers.size()]

class_name AbilityResource extends Resource

@export var id: String
@export var icon: Texture2D
@export var animations: Array[StringName] = []
@export var cooldown: float
@export var can_combo: bool = true
@export var damage_multipliers: Array[float] = [1.0]
@export var handler_scene: PackedScene
@export var knockback_forces: Array[float] = []
@export var dash_force: float = 0.0


func get_animation(index: int) -> StringName:
    if animations.is_empty():
        return &""
    return animations[index % animations.size()]


func get_multiplier(index: int) -> float:
    if damage_multipliers.is_empty():
        return 1.0
    return damage_multipliers[index % damage_multipliers.size()]


func get_knockback_force(index: int) -> float:
    if knockback_forces.is_empty():
        return 0.0
    return knockback_forces[index % knockback_forces.size()]

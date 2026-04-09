class_name DashCommand extends RefCounted

var direction: Vector3
var force: float
var reset_velocity: bool

func _init(p_direction: Vector3, p_force: float, p_reset_velocity: bool) -> void:
    direction = p_direction
    force = p_force
    reset_velocity = p_reset_velocity

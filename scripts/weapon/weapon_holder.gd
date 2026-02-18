class_name WeaponHolder extends Node3D

@onready var _weapon:Node3D = get_node_or_null("Sword")

func _physics_process(delta: float) -> void:
    if _weapon:
        _weapon.position.y = sin(Time.get_ticks_msec() * delta * 0.8) * 0.025

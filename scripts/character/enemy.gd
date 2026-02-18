class_name Enemy extends CharacterBody3D

var _gravity := float(ProjectSettings.get_setting("physics/3d/default_gravity"))

func _physics_process(delta: float) -> void:
    if not is_on_floor():
        velocity.y -= _gravity * delta
    elif velocity.y < 0.0:
        velocity.y = 0.0
    move_and_slide()

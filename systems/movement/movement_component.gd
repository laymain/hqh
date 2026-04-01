class_name MovementComponent extends Node

var _character: Character
var _gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func setup(character: Character) -> void:
    _character = character

func _physics_process(delta: float) -> void:
    if not _character: return

    if _character.stats.gravity_enabled and not _character.is_on_floor():
        _character.velocity.y -= _gravity * delta

    _character.move_and_slide()

func handle_movement(move_cmd: CharacterController.MovementCommand, delta: float, speed_multiplier: float = 1.0) -> void:
    if not _character: return

    var move_direction := Vector3(move_cmd.lateral_input, 0.0, -move_cmd.forward_input).normalized()
    var horizontal_velocity := Vector3(_character.velocity.x, 0.0, _character.velocity.z)

    if move_direction == Vector3.ZERO:
        horizontal_velocity = horizontal_velocity.move_toward(Vector3.ZERO, _character.stats.deceleration * delta)
    else:
        horizontal_velocity = horizontal_velocity.move_toward(move_direction * _character.stats.move_speed * speed_multiplier, _character.stats.acceleration * delta)

    _character.velocity.x = horizontal_velocity.x
    _character.velocity.z = horizontal_velocity.z

    if move_cmd.jump_pressed and _character.is_on_floor():
        _character.velocity.y = _character.stats.jump_velocity

func handle_aiming(aim_pos: Vector3, delta: float) -> void:
    if not _character: return

    var look_target := Vector3(aim_pos.x, _character.global_position.y, aim_pos.z)
    if _character.global_position.distance_squared_to(look_target) > 0.1:
        var look_direction := (look_target - _character.global_position).normalized()
        var target_basis := Basis.looking_at(look_direction)
        _character.basis = _character.basis.slerp(target_basis, _character.stats.turn_speed * delta)

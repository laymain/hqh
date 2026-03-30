class_name MovementComponent extends Node

var _stats: CharacterStats
var _body: CharacterBody3D
var _gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func setup(body: CharacterBody3D, stats: CharacterStats) -> void:
    _body = body
    _stats = stats

func _physics_process(delta: float) -> void:
    if not _body or not _stats: return

    if _stats.gravity_enabled and not _body.is_on_floor():
        _body.velocity.y -= _gravity * delta

    _body.move_and_slide()

func handle_movement(move_cmd: CharacterController.MovementCommand, delta: float) -> void:
    if not _body or not _stats: return

    var move_direction := Vector3(move_cmd.lateral_input, 0.0, -move_cmd.forward_input).normalized()
    var horizontal_velocity := Vector3(_body.velocity.x, 0.0, _body.velocity.z)

    if move_direction == Vector3.ZERO:
        horizontal_velocity = horizontal_velocity.move_toward(Vector3.ZERO, _stats.deceleration * delta)
    else:
        horizontal_velocity = horizontal_velocity.move_toward(move_direction * _stats.move_speed, _stats.acceleration * delta)

    _body.velocity.x = horizontal_velocity.x
    _body.velocity.z = horizontal_velocity.z

    if move_cmd.jump_pressed and _body.is_on_floor():
        _body.velocity.y = _stats.jump_velocity

func handle_aiming(aim_pos: Vector3, delta: float) -> void:
    if not _body or not _stats: return

    var look_target := Vector3(aim_pos.x, _body.global_position.y, aim_pos.z)
    if _body.global_position.distance_squared_to(look_target) > 0.1:
        var look_direction := (look_target - _body.global_position).normalized()
        var target_basis := Basis.looking_at(look_direction)
        _body.basis = _body.basis.slerp(target_basis, _stats.turn_speed * delta)

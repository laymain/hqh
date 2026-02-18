class_name Character extends CharacterBody3D

@export var move_speed := 7.5
@export var acceleration := 28.0
@export var deceleration := 32.0
@export var jump_velocity := 5.0
@export var turn_speed := 2.8
@export var gravity_enabled := true
@export var controller_path: NodePath

var _gravity := float(ProjectSettings.get_setting("physics/3d/default_gravity"))
var _controller: CharacterController
var _last_movement_command : CharacterController.MovementCommand = null

func _ready() -> void:
    _controller = get_node_or_null(controller_path) as CharacterController

func _physics_process(delta: float) -> void:
    var command := _last_movement_command
    if _controller != null:
        command = _controller.get_movement_command(self, delta)
        if command == null:
            command = CharacterController.MovementCommand.new()
    elif command == null:
        command = CharacterController.MovementCommand.new()
    _last_movement_command = command

    if absf(command.turn_input) > 0.0:
        rotation.y += command.turn_input * turn_speed * delta

    var local_move := Vector3(command.lateral_input, 0.0, -command.forward_input)
    if local_move.length() > 1.0:
        local_move = local_move.normalized()

    var direction := (transform.basis * local_move).normalized()
    var horizontal_velocity := Vector3(velocity.x, 0.0, velocity.z)
    if direction == Vector3.ZERO:
        horizontal_velocity = horizontal_velocity.move_toward(Vector3.ZERO, deceleration * delta)
    else:
        horizontal_velocity = horizontal_velocity.move_toward(direction * move_speed, acceleration * delta)

    velocity.x = horizontal_velocity.x
    velocity.z = horizontal_velocity.z

    if gravity_enabled:
        if not is_on_floor():
            velocity.y -= _gravity * delta
        elif velocity.y < 0.0:
            velocity.y = 0.0

    if command.jump_pressed and is_on_floor():
        velocity.y = jump_velocity

    move_and_slide()

func set_hovering(enabled: bool) -> void:
    var sprite := get_node_or_null("AnimatedSprite3D") as AnimatedSprite3D
    if sprite:
        if sprite.material_override and not sprite.material_override.resource_local_to_scene:
             sprite.material_override = sprite.material_override.duplicate()
        var mat := sprite.material_override as ShaderMaterial
        if mat:
            mat.set_shader_parameter("hovering", enabled)

func get_last_movement_command() -> CharacterController.MovementCommand:
    return _last_movement_command

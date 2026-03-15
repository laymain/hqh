class_name Character extends CharacterBody3D

@export var move_speed := 7.5
@export var acceleration := 28.0
@export var deceleration := 32.0
@export var jump_velocity := 5.0
@export var turn_speed := 2.8
@export var gravity_enabled := true
@export var controller_path: NodePath
@export var attack_distance := 2.5
@export var attack_speed := 1.0

var _gravity := float(ProjectSettings.get_setting("physics/3d/default_gravity"))
var _controller: CharacterController
var _last_movement_command : CharacterController.MovementCommand = null
var _target : Character = null
var _weapon_holder: WeaponHolder

const FLOATING_TEXT_SCENE := preload("res://scenes/ui/floating_text.tscn")

func _ready() -> void:
    _controller = get_node_or_null(controller_path) as CharacterController
    _weapon_holder = get_node_or_null("WeaponHolder") as WeaponHolder

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

func _process(delta: float) -> void:
    if _controller != null:
        var command := _controller.get_action_command(self, delta)
        if command and command.attack != null:
            _target = command.attack

    if _target != null and is_instance_valid(_target) and _weapon_holder != null:
        if global_position.distance_to(_target.global_position) <= attack_distance:
            _weapon_holder.attack(attack_speed)

func set_hovering(enabled: bool) -> void:
    var sprite := get_node_or_null("AnimatedSprite3D") as AnimatedSprite3D
    if sprite:
        if sprite.material_override and not sprite.material_override.resource_local_to_scene:
             sprite.material_override = sprite.material_override.duplicate()
        var mat := sprite.material_override as ShaderMaterial
        if mat:
            mat.set_shader_parameter("hovering", enabled)

func do_damage(weapon: Weapon) -> void:
    if _target != null and is_instance_valid(_target) and _weapon_holder != null:
        if global_position.distance_to(_target.global_position) <= attack_distance:
            _target.take_damage(self, randi_range(1, 3))


func take_damage(attacker: Character, amount: int) -> void:
    if FLOATING_TEXT_SCENE:
        var text_instance := FLOATING_TEXT_SCENE.instantiate() as FloatingText
        text_instance.set_amount(amount)
        get_tree().root.add_child(text_instance)
        text_instance.position = global_position + Vector3(0, 0.8, 0)
        text_instance.start()

    var sprite := get_node_or_null("AnimatedSprite3D") as AnimatedSprite3D
    if sprite:
        var tween := create_tween()
        tween.tween_property(sprite, "offset", Vector2(randf_range(-5, 5), randf_range(-5, 5)), 0.05)
        tween.tween_property(sprite, "offset", Vector2.ZERO, 0.05)

func get_last_movement_command() -> CharacterController.MovementCommand:
    return _last_movement_command

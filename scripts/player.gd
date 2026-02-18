class_name Player extends CharacterBody3D

const MOVE_FORWARD_ACTION := "move_forward"
const MOVE_BACK_ACTION := "move_back"
const MOVE_LEFT_ACTION := "move_left"
const MOVE_RIGHT_ACTION := "move_right"
const JUMP_ACTION := "jump"
const AUTORUN_TOGGLE_ACTION := "autorun_toggle"
const TURN_DEADZONE := 0.0005

@export var move_speed := 7.5
@export var acceleration := 28.0
@export var deceleration := 32.0
@export var jump_velocity := 5.0

@onready var _sprite: AnimatedSprite3D = $AnimatedSprite3D

var _gravity := float(ProjectSettings.get_setting("physics/3d/default_gravity"))
var _autorun_toggled := false
var _prev_yaw := 0.0
var _facing_right := true

func _ready() -> void:
    _ensure_input_action_bindings()
    _prev_yaw = rotation.y
    _apply_facing()

func _physics_process(delta: float) -> void:
    if Input.is_action_just_pressed(AUTORUN_TOGGLE_ACTION):
        _autorun_toggled = not _autorun_toggled

    var input_2d := Input.get_vector(
        MOVE_LEFT_ACTION,
        MOVE_RIGHT_ACTION,
        MOVE_BACK_ACTION,
        MOVE_FORWARD_ACTION
    )

    if _autorun_toggled:
        input_2d.y += 1.0
    if input_2d.length() > 1.0:
        input_2d = input_2d.normalized()

    _update_sprite_facing(input_2d.x)

    # Move relative to player's own basis (Tank/FPS style)
    var direction := (transform.basis * Vector3(input_2d.x, 0, -input_2d.y)).normalized()

    var horizontal_velocity := Vector3(velocity.x, 0.0, velocity.z)
    if direction == Vector3.ZERO:
        horizontal_velocity = horizontal_velocity.move_toward(Vector3.ZERO, deceleration * delta)
    else:
        horizontal_velocity = horizontal_velocity.move_toward(direction * move_speed, acceleration * delta)

    velocity.x = horizontal_velocity.x
    velocity.z = horizontal_velocity.z

    if not is_on_floor():
        velocity.y -= _gravity * delta
    elif velocity.y < 0.0:
        velocity.y = 0.0

    if Input.is_action_just_pressed(JUMP_ACTION) and is_on_floor():
        velocity.y = jump_velocity

    move_and_slide()
    _prev_yaw = rotation.y

func _update_sprite_facing(move_lr: float) -> void:
    var yaw_delta := wrapf(rotation.y - _prev_yaw, -PI, PI)
    var turn_lr := 0.0
    if absf(yaw_delta) > TURN_DEADZONE:
        turn_lr = -sign(yaw_delta)

    if move_lr > 0.0:
        _facing_right = true
    elif move_lr < 0.0:
        _facing_right = false
    elif turn_lr > 0.0:
        _facing_right = true
    elif turn_lr < 0.0:
        _facing_right = false

    _apply_facing()

func _apply_facing() -> void:
    _sprite.flip_h = not _facing_right

func _ensure_input_action_bindings() -> void:
    _ensure_key_action(MOVE_FORWARD_ACTION, KEY_W)
    _ensure_key_action(MOVE_BACK_ACTION, KEY_S)
    _ensure_key_action(MOVE_LEFT_ACTION, KEY_A)
    _ensure_key_action(MOVE_RIGHT_ACTION, KEY_D)
    _ensure_key_action(JUMP_ACTION, KEY_SPACE)
    _ensure_key_action(AUTORUN_TOGGLE_ACTION, KEY_R)

func _ensure_key_action(action_name: StringName, key_code: int) -> void:
    if not InputMap.has_action(action_name):
        InputMap.add_action(action_name)

    for event in InputMap.action_get_events(action_name):
        if event is InputEventKey and event.physical_keycode == key_code:
            return

    var key_event := InputEventKey.new()
    key_event.physical_keycode = key_code as Key
    InputMap.action_add_event(action_name, key_event)

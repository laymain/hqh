class_name Player extends Node

const TURN_DEADZONE := 0.01

@onready var _character: Character = $Character
@onready var _sprite: AnimatedSprite3D = $Character/AnimatedSprite3D

var _facing_right := true
var _prev_yaw := 0.0

func _ready() -> void:
    _prev_yaw = _character.rotation.y
    _apply_facing()

func _physics_process(_delta: float) -> void:
    var command := _character.get_last_movement_command()
    if command != null:
        _update_sprite_facing(command.lateral_input)
    _prev_yaw = _character.rotation.y

func _update_sprite_facing(lateral_input: float) -> void:
    var yaw_delta := wrapf(_character.rotation.y - _prev_yaw, -PI, PI)
    var turn_lr := 0.0
    if absf(yaw_delta) > TURN_DEADZONE:
        turn_lr = -sign(yaw_delta)

    if turn_lr > 0.0:
        _facing_right = true
    elif turn_lr < 0.0:
        _facing_right = false
    elif lateral_input > 0.0:
        _facing_right = true
    elif lateral_input < 0.0:
        _facing_right = false

    _apply_facing()

func _apply_facing() -> void:
    _sprite.flip_h = not _facing_right

func set_spawn_position(spawn_position: Vector3) -> void:
    if _character == null:
        return
    _character.global_position = spawn_position + Vector3(0.0, _character.global_position.y, 0.0)

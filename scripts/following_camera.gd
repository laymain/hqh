class_name FollowingCamera extends Node

@export var target: Node3D
@export var offset: Vector3 = Vector3(0, 1.6, 0)
@export var zoom_min: float = 3.0
@export var zoom_max: float = 14.0
@export var zoom_step: float = 0.5
@export var zoom_smooth_speed: float = 12.0
@export var sensitivity: Vector2 = Vector2(0.0025, 0.0015)
@export var min_pitch: float = -10.0
@export var max_pitch: float = 15.0
@export_flags_3d_physics var collision_mask: int = 1
@export var collision_margin: float = 0.15

var _yaw: float = 0.0
var _pitch: float = deg_to_rad(20.0)
var _target_distance: float = 8.0

var _spring_arm: SpringArm3D
var _camera: Camera3D

func _ready() -> void:
    _spring_arm = SpringArm3D.new()
    _spring_arm.collision_mask = collision_mask
    _spring_arm.margin = collision_margin
    _spring_arm.spring_length = _target_distance
    if target is CharacterBody3D or target is RigidBody3D:
        _yaw = target.global_rotation.y
        _spring_arm.add_excluded_object(target.get_rid())
    add_child(_spring_arm)

    _camera = Camera3D.new()
    _spring_arm.add_child(_camera)
    _camera.current = true

    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
    if not _camera.is_current():
        return

    if event.is_action_pressed("ui_cancel"):
        if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
            Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
        else:
            Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
        return

    if event is InputEventMouseButton:
        var mouse_button := event as InputEventMouseButton
        if mouse_button.pressed:
            if mouse_button.button_index == MOUSE_BUTTON_WHEEL_UP:
                _target_distance = clampf(_target_distance - zoom_step, zoom_min, zoom_max)
            elif mouse_button.button_index == MOUSE_BUTTON_WHEEL_DOWN:
                _target_distance = clampf(_target_distance + zoom_step, zoom_min, zoom_max)
            elif Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
                Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

    if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
        var motion := event as InputEventMouseMotion
        _yaw -= motion.relative.x * sensitivity.x
        _pitch = clampf(
            _pitch - motion.relative.y * sensitivity.y,
            deg_to_rad(min_pitch),
            deg_to_rad(max_pitch)
        )

func _process(delta: float) -> void:
    if not target or not _camera.is_current():
        return

    target.rotation.y = _yaw

    _spring_arm.spring_length = move_toward(_spring_arm.spring_length, _target_distance, zoom_smooth_speed * delta)
    _spring_arm.global_position = target.global_position + offset
    _spring_arm.rotation.y = _yaw
    _spring_arm.rotation.x = _pitch

class_name FollowingCamera extends Node

@export var target: Node3D
@export var offset: Vector3 = Vector3(0, 1.6, 0)
@export var angle: float = 50.0
@export var zoom_min: float = 8.0
@export var zoom_max: float = 12.0
@export var zoom_step: float = 1.0
@export var zoom_smooth_speed: float = 12.0

var _target_distance: float = 8.0
var _current_distance: float = 8.0

var _camera: Camera3D

func get_camera_3d() -> Camera3D:
    return _camera

func _ready() -> void:
    _camera = Camera3D.new()
    add_child(_camera)
    _camera.current = true

func _unhandled_input(event: InputEvent) -> void:
    if not _camera.is_current():
        return

    if event is InputEventMouseButton:
        var mouse_button := event as InputEventMouseButton
        if mouse_button.pressed:
            if mouse_button.button_index == MOUSE_BUTTON_WHEEL_UP:
                _target_distance = clampf(_target_distance - zoom_step, zoom_min, zoom_max)
            elif mouse_button.button_index == MOUSE_BUTTON_WHEEL_DOWN:
                _target_distance = clampf(_target_distance + zoom_step, zoom_min, zoom_max)

func _process(delta: float) -> void:
    if target == null or not _camera.is_current():
        return

    _current_distance = move_toward(_current_distance, _target_distance, zoom_smooth_speed * delta)

    var angle_rad := deg_to_rad(angle)
    var pivot: Vector3 = target.global_position + offset
    _camera.global_position = pivot + Vector3(0.0, sin(angle_rad), cos(angle_rad)) * _current_distance
    _camera.look_at(pivot, Vector3.UP)

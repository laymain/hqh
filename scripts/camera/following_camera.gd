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

signal screen_locked(enabled: bool)

var _yaw: float = 0.0
var _pitch: float = deg_to_rad(20.0)
var _target_distance: float = 8.0
const RMB_DRAG_THRESHOLD_PX := 6.0

var _rmb_down: bool = false
var _rmb_started_drag: bool = false
var _rmb_drag_distance_px: float = 0.0
var _cursor_restore_pos: Vector2 = Vector2.ZERO
var _has_cursor_restore_pos: bool = false

var _spring_arm: SpringArm3D
var _camera: Camera3D

func get_camera_3d() -> Camera3D:
    return _camera

func _ready() -> void:
    _spring_arm = SpringArm3D.new()
    _spring_arm.collision_mask = collision_mask
    _spring_arm.margin = collision_margin
    _spring_arm.spring_length = _target_distance

    if target != null:
        _yaw = target.global_rotation.y
        if target is CollisionObject3D:
            _spring_arm.add_excluded_object((target as CollisionObject3D).get_rid())

    add_child(_spring_arm)

    _camera = Camera3D.new()
    _spring_arm.add_child(_camera)
    _camera.current = true

    _set_screen_locked(false)

func _unhandled_input(event: InputEvent) -> void:
    if not _camera.is_current():
        return

    if event.is_action_pressed("ui_cancel"):
        _clear_rmb_state()
        _set_screen_locked(false)
        return

    if event is InputEventMouseButton:
        var mouse_button := event as InputEventMouseButton
        if mouse_button.button_index == MOUSE_BUTTON_RIGHT:
            if mouse_button.pressed:
                _cursor_restore_pos = mouse_button.position
                _has_cursor_restore_pos = true
                _rmb_down = true
                _rmb_started_drag = false
                _rmb_drag_distance_px = 0.0
            else:
                if _rmb_started_drag:
                    _set_screen_locked(false)
                else:
                    _handle_selection_mode_right_click(mouse_button)
                _clear_rmb_state()
            return
        if mouse_button.pressed:
            if mouse_button.button_index == MOUSE_BUTTON_WHEEL_UP:
                _target_distance = clampf(_target_distance - zoom_step, zoom_min, zoom_max)
            elif mouse_button.button_index == MOUSE_BUTTON_WHEEL_DOWN:
                _target_distance = clampf(_target_distance + zoom_step, zoom_min, zoom_max)
            elif not _rmb_down and mouse_button.button_index == MOUSE_BUTTON_LEFT:
                _handle_selection_mode_left_click(mouse_button)

    if event is InputEventMouseMotion and _rmb_down:
        var motion := event as InputEventMouseMotion
        _rmb_drag_distance_px += motion.relative.length()

        if not _rmb_started_drag and _rmb_drag_distance_px >= RMB_DRAG_THRESHOLD_PX:
            _rmb_started_drag = true
            _set_screen_locked(true)

        if _rmb_started_drag:
            _yaw -= motion.relative.x * sensitivity.x
            _pitch = clampf(
                _pitch - motion.relative.y * sensitivity.y,
                deg_to_rad(min_pitch),
                deg_to_rad(max_pitch)
            )

func _process(delta: float) -> void:
    if target == null or not _camera.is_current():
        return

    if _rmb_started_drag:
        target.rotation.y = _yaw
    else:
        _yaw = target.rotation.y

    _spring_arm.spring_length = move_toward(_spring_arm.spring_length, _target_distance, zoom_smooth_speed * delta)
    _spring_arm.global_position = target.global_position + offset
    _spring_arm.rotation.y = _yaw
    _spring_arm.rotation.x = _pitch

func _set_screen_locked(enabled: bool) -> void:
    if enabled:
        Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
    else:
        Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
        if _has_cursor_restore_pos:
            Input.warp_mouse(_cursor_restore_pos)
            _has_cursor_restore_pos = false
    screen_locked.emit(enabled)

func _clear_rmb_state() -> void:
    _rmb_down = false
    _rmb_started_drag = false
    _rmb_drag_distance_px = 0.0

func _handle_selection_mode_left_click(_event: InputEventMouseButton) -> void:
    pass

func _handle_selection_mode_right_click(_event: InputEventMouseButton) -> void:
    pass

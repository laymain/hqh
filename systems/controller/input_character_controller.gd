class_name InputCharacterController extends CharacterController

const MOVE_FORWARD_ACTION := &"move_forward"
const MOVE_BACK_ACTION := &"move_back"
const MOVE_LEFT_ACTION := &"move_left"
const MOVE_RIGHT_ACTION := &"move_right"
const ABILITY_0_ACTION := &"ability_0"
const ABILITY_1_ACTION := &"ability_1"
const ABILITY_2_ACTION := &"ability_2"
const ABILITY_3_ACTION := &"ability_3"
const ABILITY_4_ACTION := &"ability_4"

@export var camera : FollowingCamera = null

var _last_aim_position: Vector3 = Vector3.ZERO

# ------------------------------------------------------------------------------
# 1. Lifecycle
# ------------------------------------------------------------------------------

func _ready() -> void:
    _setup_input_bindings()

func _process(_delta: float) -> void:
    _update_sensing()

# ------------------------------------------------------------------------------
# 2. Intent Translation (CharacterController API)
# ------------------------------------------------------------------------------

func get_movement_command(character: Character, _delta: float) -> MovementCommand:
    var command := MovementCommand.new()
    if !character.health.is_dead:
        command.forward_input = Input.get_action_strength(MOVE_FORWARD_ACTION) - Input.get_action_strength(MOVE_BACK_ACTION)
        command.lateral_input = Input.get_action_strength(MOVE_RIGHT_ACTION) - Input.get_action_strength(MOVE_LEFT_ACTION)
    return command

func get_action_command(character: Character, _delta: float) -> ActionCommand:
    var command := ActionCommand.new()
    if !character.health.is_dead:
        if Input.is_action_pressed(ABILITY_0_ACTION): command.pressed_slots.append(0)
        #if Input.is_action_pressed(ABILITY_1_ACTION): command.pressed_slots.append(1)
        #if Input.is_action_pressed(ABILITY_2_ACTION): command.pressed_slots.append(2)
        #if Input.is_action_pressed(ABILITY_3_ACTION): command.pressed_slots.append(3)
        if Input.is_action_pressed(ABILITY_4_ACTION): command.pressed_slots.append(4)
        command.aim_position = _last_aim_position

    return command

# ------------------------------------------------------------------------------
# 3. Environmental Sensing (Raycasting)
# ------------------------------------------------------------------------------

func _update_sensing() -> void:
    var result := _perform_mouse_raycast()
    if not result.is_empty():
        _last_aim_position = result.position

func _perform_mouse_raycast() -> Dictionary:
    if camera == null or Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
        return {}

    var cam := camera.get_camera_3d()
    if cam == null:
        return {}

    var mouse_pos := get_viewport().get_mouse_position()
    var origin := cam.project_ray_origin(mouse_pos)
    var dir := cam.project_ray_normal(mouse_pos)

    if abs(dir.y) < 0.001:
        return {}
    var t := -origin.y / dir.y
    if t < 0.0:
        return {}

    return {"position": origin + dir * t}

# ------------------------------------------------------------------------------
# 4. Input Configuration (Boilerplate)
# ------------------------------------------------------------------------------

func _setup_input_bindings() -> void:
    _bind_key(MOVE_FORWARD_ACTION, KEY_W)
    _bind_key(MOVE_BACK_ACTION, KEY_S)
    _bind_key(MOVE_LEFT_ACTION, KEY_A)
    _bind_key(MOVE_RIGHT_ACTION, KEY_D)

    _bind_mouse(ABILITY_0_ACTION, MOUSE_BUTTON_LEFT)
    _bind_mouse(ABILITY_1_ACTION, MOUSE_BUTTON_RIGHT)
    _bind_key(ABILITY_2_ACTION, KEY_Q)
    _bind_key(ABILITY_3_ACTION, KEY_E)
    _bind_key(ABILITY_4_ACTION, KEY_SPACE)

func _bind_key(action_name: StringName, key_code: int) -> void:
    if not InputMap.has_action(action_name):
        InputMap.add_action(action_name)
    if InputMap.action_get_events(action_name).is_empty():
        var event := InputEventKey.new()
        event.physical_keycode = key_code as Key
        InputMap.action_add_event(action_name, event)

func _bind_mouse(action_name: StringName, button_index: int) -> void:
    if not InputMap.has_action(action_name):
        InputMap.add_action(action_name)
    if InputMap.action_get_events(action_name).is_empty():
        var event := InputEventMouseButton.new()
        event.button_index = button_index as MouseButton
        InputMap.action_add_event(action_name, event)

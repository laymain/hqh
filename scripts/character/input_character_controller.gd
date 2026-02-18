class_name InputCharacterController extends CharacterController

const MOVE_FORWARD_ACTION := "move_forward"
const MOVE_BACK_ACTION := "move_back"
const MOVE_LEFT_ACTION := "move_left"
const MOVE_RIGHT_ACTION := "move_right"
const JUMP_ACTION := "jump"
const AUTORUN_TOGGLE_ACTION := "autorun_toggle"

var _autorun_toggled := false
var _strafe_mode := false
var _hovered_character: Character = null

@export var camera : FollowingCamera = null

func _ready() -> void:
    camera.screen_locked.connect(set_strafe_mode)
    _ensure_input_action_bindings()

func _process(_delta: float) -> void:
    _update_hover()

func get_movement_command(_character: Character, _delta: float) -> MovementCommand:
    if Input.is_action_just_pressed(AUTORUN_TOGGLE_ACTION):
        _autorun_toggled = not _autorun_toggled

    var command := MovementCommand.new()
    command.forward_input = Input.get_action_strength(MOVE_FORWARD_ACTION) - Input.get_action_strength(MOVE_BACK_ACTION)
    var side_input := Input.get_action_strength(MOVE_RIGHT_ACTION) - Input.get_action_strength(MOVE_LEFT_ACTION)
    if _strafe_mode:
        command.lateral_input = side_input
        command.turn_input = 0.0
    else:
        command.lateral_input = 0.0
        command.turn_input = -side_input

    if _autorun_toggled:
        command.forward_input += 1.0

    command.jump_pressed = Input.is_action_just_pressed(JUMP_ACTION)
    return command

func set_strafe_mode(enabled: bool) -> void:
    _strafe_mode = enabled

func _update_hover() -> void:
    unhover()
    if camera == null or Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
        return

    var cam := camera.get_camera_3d()
    if cam == null:
        return

    var mouse_pos := get_viewport().get_mouse_position()
    var from := cam.project_ray_origin(mouse_pos)
    var to := from + cam.project_ray_normal(mouse_pos) * 1000.0

    var query := PhysicsRayQueryParameters3D.create(from, to)
    var space_state := get_viewport().world_3d.direct_space_state
    var result := space_state.intersect_ray(query)

    if not result.is_empty():
        var collider = result.collider
        if collider is Character and collider.get_parent() is not Player:
            hover(collider as Character)

func unhover() -> void:
    if _hovered_character != null:
        _hovered_character.set_hovering(false)
        _hovered_character = null

func hover(character: Character) -> void:
    if _hovered_character != character:
        character.set_hovering(true)
        _hovered_character = character

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

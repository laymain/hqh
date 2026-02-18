extends Camera3D

@export var move_speed: float = 10.0
@export var fast_move_speed: float = 20.0
@export var mouse_sensitivity: float = 0.002

var _rotation_x: float = 0.0
var _rotation_y: float = 0.0

func _ready():
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent):
    if event is InputEventMouseMotion:
        _rotation_y -= event.relative.x * mouse_sensitivity
        _rotation_x -= event.relative.y * mouse_sensitivity
        _rotation_x = clamp(_rotation_x, -PI/2, PI/2)  # Limit vertical rotation
        
        transform.basis = Basis()
        rotate_object_local(Vector3.UP, _rotation_y)
        rotate_object_local(Vector3.RIGHT, _rotation_x)
    
    if event.is_action_pressed("ui_cancel"):
        if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
            Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
        else:
            Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta: float) -> void:
    if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
        return
    
    var input_dir := Vector3.ZERO
    
    if Input.is_key_pressed(KEY_W):
        input_dir -= transform.basis.z
    if Input.is_key_pressed(KEY_S):
        input_dir += transform.basis.z
    if Input.is_key_pressed(KEY_A):
        input_dir -= transform.basis.x
    if Input.is_key_pressed(KEY_D):
        input_dir += transform.basis.x
    if Input.is_key_pressed(KEY_E) or Input.is_key_pressed(KEY_SPACE):
        input_dir += Vector3.UP
    if Input.is_key_pressed(KEY_Q) or Input.is_key_pressed(KEY_CTRL):
        input_dir -= Vector3.UP
    
    input_dir = input_dir.normalized()
    var speed := fast_move_speed if Input.is_key_pressed(KEY_SHIFT) else move_speed
    position += input_dir * speed * delta

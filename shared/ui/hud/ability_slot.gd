class_name AbilitySlot
extends Control

@onready var _icon: TextureRect = $Icon
@onready var _cooldown_overlay: ColorRect = $CooldownOverlay
@onready var _cooldown_label: Label = $CooldownLabel

var _overlay_mat: ShaderMaterial
var _total_cooldown: float = 0.0
var _remaining_cooldown: float = 0.0


func _ready() -> void:
    _overlay_mat = _cooldown_overlay.material as ShaderMaterial


func setup(ability: AbilityResource) -> void:
    if ability and ability.icon:
        _icon.texture = ability.icon


func start_cooldown(total: float) -> void:
    _total_cooldown = total
    _remaining_cooldown = total
    _overlay_mat.set_shader_parameter("progress", 1.0)
    _cooldown_overlay.visible = true
    _cooldown_label.visible = true


func mark_ready() -> void:
    _total_cooldown = 0.0
    _remaining_cooldown = 0.0
    _cooldown_overlay.visible = false
    _cooldown_label.visible = false


func _process(delta: float) -> void:
    if _remaining_cooldown <= 0.0:
        return
    _remaining_cooldown = maxf(_remaining_cooldown - delta, 0.0)
    var ratio: float = _remaining_cooldown / _total_cooldown
    _overlay_mat.set_shader_parameter("progress", ratio)
    _cooldown_label.text = "%.1f" % _remaining_cooldown
    if _remaining_cooldown == 0.0:
        mark_ready()

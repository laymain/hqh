class_name CharacterVisuals extends Node

@onready var _sprite: AnimatedSprite3D = get_node_or_null("../AnimatedSprite3D")
const FLOATING_TEXT_SCENE := preload("res://shared/ui/floating_text.tscn")

var _health: HealthComponent
var _abilities: AbilityComponent

func setup(health: HealthComponent, abilities: AbilityComponent) -> void:
    _health = health
    _abilities = abilities

    if _health:
        _health.health_changed.connect(_on_health_changed)
        _health.died.connect(_on_died)

    if _abilities:
        _abilities.ability_activated.connect(_on_ability_activated)

func _on_health_changed(amount: float, _current: float, _max: float) -> void:
    if amount < 0:
        _spawn_floating_text(absf(amount))
        if _sprite:
            var tween := create_tween()
            tween.tween_property(_sprite, "offset", Vector2(randf_range(-5, 5), randf_range(-5, 5)), 0.05)
            tween.tween_property(_sprite, "offset", Vector2.ZERO, 0.05)
    else:
        _spawn_floating_text(amount, Color.GREEN)

func _on_died() -> void:
    if _sprite:
        var tween := create_tween()
        tween.tween_property(_sprite, "modulate:a", 0.0, 0.5)
        tween.finished.connect(func(): get_parent().queue_free())

func _on_ability_activated(_ability: AbilityResource, _aim_pos: Vector3) -> void:
    # Basic animation trigger placeholder
    pass

func _spawn_floating_text(amount: float, _color: Color = Color.WHITE) -> void:
    if FLOATING_TEXT_SCENE:
        var text_instance := FLOATING_TEXT_SCENE.instantiate() as FloatingText
        text_instance.set_amount(int(amount))
        get_tree().root.add_child(text_instance)
        text_instance.global_position = _sprite.global_position + Vector3(0, 0.8, 0)
        text_instance.start()

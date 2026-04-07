class_name HUD
extends CanvasLayer

@export var ability_slot_scene: PackedScene

@onready var _player_name: Label = $HUDRoot/BottomBar/NameplatePanel/Inner/PlayerName
@onready var _health_bar: TextureProgressBar = $HUDRoot/BottomBar/NameplatePanel/Inner/HealthBar
@onready var _ability_bar: HBoxContainer = $HUDRoot/BottomBar/AbilityPanel/AbilityBar

var _slots: Array[AbilitySlot] = []


func setup(player: Character) -> void:
    _player_name.text = player.name
    _health_bar.max_value = player.health.max_health
    _health_bar.value = player.health.current_health
    player.health.health_changed.connect(_on_health_changed)
    player.abilities.ability_started.connect(_on_ability_started)
    player.abilities.ability_ready.connect(_on_ability_ready)
    _build_ability_bar(player)


func _build_ability_bar(player: Character) -> void:
    for child in _ability_bar.get_children():
        child.queue_free()
    _slots.clear()
    for i in player.abilities.get_ability_count():
        var slot := ability_slot_scene.instantiate() as AbilitySlot
        _ability_bar.add_child(slot)
        slot.setup(player.abilities.get_ability_resource(i))
        _slots.append(slot)


func _on_health_changed(_amount: float, current: float, max_hp: float) -> void:
    _health_bar.max_value = max_hp
    _health_bar.value = current


func _on_ability_started(slot: int, total_cooldown: float) -> void:
    if slot < _slots.size():
        _slots[slot].start_cooldown(total_cooldown)


func _on_ability_ready(slot: int) -> void:
    if slot < _slots.size():
        _slots[slot].mark_ready()

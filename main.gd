extends Node3D

@onready var _map_manager: MapManager = $MapManager
@onready var _hud: HUD = $HUD


func _ready() -> void:
    _hud.setup(_map_manager.player)

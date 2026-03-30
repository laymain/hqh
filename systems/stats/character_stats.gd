class_name CharacterStats extends Resource

@export_group("Health")
@export var max_health: float = 100.0

@export_group("Offense")
@export var base_power: float = 10.0
@export var crit_chance: float = 0.1
@export var crit_multiplier: float = 1.5

@export_group("Movement")
@export var move_speed: float = 7.5
@export var acceleration: float = 28.0
@export var deceleration: float = 32.0
@export var turn_speed: float = 10.0
@export var jump_velocity: float = 5.0
@export var gravity_enabled: bool = true

@export_group("Abilities")
@export var abilities: Array[String] = []

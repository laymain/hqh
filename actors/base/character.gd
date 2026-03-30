class_name Character extends CharacterBody3D

@export var stats: CharacterStats
@export var ability_library: AbilityLibrary

@onready var controller: CharacterController = get_node_or_null("CharacterController")
@onready var abilities: AbilityComponent = $AbilityComponent
@onready var attack: AttackComponent = $AttackComponent
@onready var defense: DefenseComponent = $DefenseComponent
@onready var health: HealthComponent = $HealthComponent
@onready var movement: MovementComponent = $MovementComponent
@onready var visuals: CharacterVisuals = $CharacterVisuals

var _damage_pipeline: Array[DamageProcessor] = []

func _ready() -> void:
    if stats == null: stats = CharacterStats.new()

    abilities.setup(self, ability_library)
    attack.setup(self)
    defense.setup(self)
    health.setup(self)
    movement.setup(self, stats)
    visuals.setup(health, abilities)

    _damage_pipeline = [
        defense,
        health
    ]

func handle_hit(info: DamageInfo) -> void:
    for processor in _damage_pipeline:
        processor.process_damage(info)
        if info.final_amount <= 0:
            break

func _physics_process(delta: float) -> void:
    if health.is_dead: return
    if not controller: 
        return

    var move_cmd := controller.get_movement_command(self, delta)
    var act_cmd := controller.get_action_command(self, delta)
    if not move_cmd or not act_cmd: return
    
    movement.handle_aiming(act_cmd.aim_position, delta)
    movement.handle_movement(move_cmd, delta)

    for slot in act_cmd.pressed_slots:
        abilities.execute(slot, act_cmd.aim_position)

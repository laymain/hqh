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
    if controller == null: controller = CharacterController.new()

    abilities.setup(self, ability_library)
    attack.setup(self)
    defense.setup(self)
    health.setup(self)
    movement.setup(self)
    visuals.setup(health, abilities)
    visuals.death_visuals_finished.connect(queue_free)

    _damage_pipeline = [
        defense,
        health
    ]

func handle_hit(info: DamageInfo) -> void:
    for processor in _damage_pipeline:
        processor.process_damage(info)
        if info.final_amount <= 0:
            break
    movement.apply_impulse(info.knockback_direction, info.knockback_force, true)

func _physics_process(delta: float) -> void:
    var move_cmd := controller.get_movement_command(self, delta)
    var act_cmd := controller.get_action_command(self, delta)
    if not move_cmd or not act_cmd: return

    for slot in act_cmd.pressed_slots:
        abilities.execute(slot, act_cmd.aim_position)

    if not abilities.is_casting and not abilities.is_buffered:
        movement.handle_aiming(act_cmd.aim_position, delta)
        movement.handle_movement(move_cmd, delta)
    else:
        movement.handle_movement(move_cmd, delta, 0.4)

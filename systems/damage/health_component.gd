class_name HealthComponent extends DamageProcessor

signal health_changed(amount: float, current: float, max_hp: float)
signal died

var current_health: float = 0.0
var max_health: float = 0.0
var is_dead: bool = false

var _character: Character

func setup(character: Character) -> void:
    _character = character
    max_health = _character.stats.max_health
    current_health = max_health
    is_dead = false

func process_damage(info: DamageInfo) -> void:
    if is_dead or info.final_amount <= 0: return

    current_health = clampf(current_health - info.final_amount, 0.0, max_health)
    health_changed.emit(-info.final_amount, current_health, max_health)

    if current_health <= 0:
        is_dead = true
        died.emit()

func heal(amount: float) -> void:
    if is_dead or amount <= 0: return

    current_health = clampf(current_health + amount, 0.0, max_health)
    health_changed.emit(amount, current_health, max_health)

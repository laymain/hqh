class_name AbilityComponent extends Node

signal ability_activated(ability: AbilityResource, aim_pos: Vector3)

var _character: Character
var _library: AbilityLibrary
var _cooldowns: Array[float] = []
var _handlers: Array[AbilityHandler] = []

func setup(character: Character, library: AbilityLibrary) -> void:
    _character = character
    _library = library

    # Clear existing handlers
    for handler in _handlers:
        if handler: handler.queue_free()
    _handlers.clear()

    var ability_ids := _character.stats.abilities
    _cooldowns.resize(ability_ids.size())
    _cooldowns.fill(0.0)
    _handlers.resize(ability_ids.size())

    for i in range(ability_ids.size()):
        var ability := _library.get_ability(ability_ids[i])
        if ability and ability.handler_scene:
            var handler := ability.handler_scene.instantiate() as AbilityHandler
            _character.add_child(handler)
            _handlers[i] = handler

func _process(delta: float) -> void:
    for i in range(_cooldowns.size()):
        if _cooldowns[i] > 0.0:
            _cooldowns[i] -= delta

func execute(slot: int, aim_pos: Vector3) -> void:
    if slot < 0 or slot >= _handlers.size():
        push_error("[AbilityComponent] Slot out of range: ", slot, " (handlers size: ", _handlers.size(), ")")
        return

    var ability_id := _character.stats.abilities[slot]
    var ability := _library.get_ability(ability_id)
    if ability == null:
        push_error("[AbilityComponent] Ability not found: ", ability_id)
        return

    if _cooldowns[slot] > 0.0:
        return

    _cooldowns[slot] = ability.cooldown
    ability_activated.emit(ability, aim_pos)

    var ctx := AbilityContext.new(_character, aim_pos)
    var handler := _handlers[slot]
    if handler:
        # Orient the handler toward the target
        if handler is Node3D:
            var look_target := Vector3(aim_pos.x, handler.global_position.y, aim_pos.z)
            if handler.global_position.distance_squared_to(look_target) > 0.01:
                handler.look_at(look_target)

        handler.execute(ability, ctx)

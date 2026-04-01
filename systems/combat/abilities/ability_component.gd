class_name AbilityComponent extends Node

signal ability_activated(ability: AbilityResource, aim_pos: Vector3)


var is_casting: bool = false
var is_buffered: bool:
    get: return _queued_action != null

var _active_slot: int = -1
var _character: Character
var _library: AbilityLibrary
var _handlers: Array[AbilityHandler] = []
var _cooldowns: Array[float] = []
var _queued_action: BufferedAction = null
var _combo_count: int = 0


func setup(character: Character, library: AbilityLibrary) -> void:
    _character = character
    _library = library
    _cleanup_handlers()
    _init_handlers()


func _cleanup_handlers() -> void:
    _active_slot = -1
    for handler in _handlers:
        if is_instance_valid(handler):
            handler.queue_free()
    _handlers.clear()


func _init_handlers() -> void:
    if not _character or not _library: return

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
    for i in _cooldowns.size():
        _cooldowns[i] = maxf(_cooldowns[i] - delta, 0.0)


func execute(slot: int, aim_pos: Vector3) -> void:
    if slot < 0 or slot >= _handlers.size():
        push_error("[AbilityComponent] Slot out of range: %d" % slot)
        return

    if is_casting:
        if slot == _active_slot:
            _queued_action = BufferedAction.new(slot, aim_pos)
        return

    if _cooldowns[slot] > 0.0:
        return

    is_casting = true
    var next_action := BufferedAction.new(slot, aim_pos)
    while next_action != null:
        _active_slot = next_action.slot
        await _perform_cast(next_action.slot, next_action.aim_pos)
        next_action = _pop_next_action()

    is_casting = false
    _active_slot = -1
    _combo_count = 0


func _perform_cast(slot: int, aim_pos: Vector3) -> void:
    var ability_id := _character.stats.abilities[slot]
    var ability := _library.get_ability(ability_id)
    if not ability:
        push_error("[AbilityComponent] Ability not found: %s" % ability_id)
        return

    ability_activated.emit(ability, aim_pos)

    var handler := _handlers[slot]
    if handler:
        _orient_handler(handler, aim_pos)
        await handler.execute(ability, AbilityContext.new(_character, aim_pos, _combo_count))
        _cooldowns[slot] = ability.cooldown
        _combo_count += 1


func _pop_next_action() -> BufferedAction:
    var next := _queued_action
    _queued_action = null
    if next == null or next.is_expired():
        return null
    return next


func _orient_handler(handler: AbilityHandler, aim_pos: Vector3) -> void:
    var look_target := Vector3(aim_pos.x, handler.global_position.y, aim_pos.z)
    if handler.global_position.distance_squared_to(look_target) > 0.01:
        handler.look_at(look_target)


class BufferedAction:
    var slot: int
    var aim_pos: Vector3
    var timestamp_msec: int

    const QUEUE_EXPIRY_MSEC: int = 500

    func _init(p_slot: int, p_aim_pos: Vector3) -> void:
        slot = p_slot
        aim_pos = p_aim_pos
        timestamp_msec = Time.get_ticks_msec()

    func is_expired() -> bool:
        return Time.get_ticks_msec() - timestamp_msec > QUEUE_EXPIRY_MSEC

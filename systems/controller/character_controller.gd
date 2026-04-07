class_name CharacterController extends Node

func get_movement_command(_character: Character, _delta: float) -> MovementCommand:
    return MovementCommand.NONE

func get_action_command(_character: Character, _delta: float) -> ActionCommand:
    return ActionCommand.NONE

class MovementCommand extends RefCounted:
    static var NONE := MovementCommand.new()
    var forward_input := 0.0
    var lateral_input := 0.0

class ActionCommand extends RefCounted:
    static var NONE := ActionCommand.new()
    var pressed_slots: Array[int] = []
    var aim_position: Vector3 = Vector3.ZERO

@abstract class_name CharacterController extends Node

func get_movement_command(_character: Character, _delta: float) -> MovementCommand:
    return null

class MovementCommand extends RefCounted:

    var forward_input := 0.0
    var lateral_input := 0.0
    var turn_input := 0.0
    var jump_pressed := false

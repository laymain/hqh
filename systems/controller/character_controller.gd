@abstract class_name CharacterController extends Node

func get_movement_command(_character: Character, _delta: float) -> MovementCommand:
    return null

func get_action_command(_character: Character, _delta: float) -> ActionCommand:
    return null

class MovementCommand extends RefCounted:
    var forward_input := 0.0
    var lateral_input := 0.0
    var jump_pressed := false

class ActionCommand extends RefCounted:
    ## List of ability slot indices that were just pressed.
    var pressed_slots: Array[int] = []

    ## The 3D world position being aimed at.
    var aim_position: Vector3 = Vector3.ZERO


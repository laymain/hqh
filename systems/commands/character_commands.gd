class_name CharacterCommands extends RefCounted

signal dispatched(cmd: Object)

func emit(cmd: Object) -> void:
    dispatched.emit(cmd)

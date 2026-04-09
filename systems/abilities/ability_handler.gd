class_name AbilityHandler extends Node3D

func execute(_resource: AbilityResource, _ctx: AbilityContext) -> void:
    await get_tree().process_frame

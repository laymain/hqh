class_name Weapon extends Node3D

@onready var character := $"../.." as Character

func do_damage() -> void:
    if character:
        character.do_damage(self)

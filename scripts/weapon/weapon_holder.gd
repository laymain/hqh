class_name WeaponHolder extends Node3D

@onready var _weapon:Node3D = get_node_or_null("Sword")

func _physics_process(delta: float) -> void:
    if _weapon:
        _weapon.position.y = sin(Time.get_ticks_msec() * delta * 0.8) * 0.025

func attack(speed: float) -> void:
    if _weapon:
        var anim_player := _weapon.get_node_or_null("AnimationPlayer") as AnimationPlayer
        if anim_player and not anim_player.is_playing():
            var anim := anim_player.get_animation("attack")
            if anim:
                anim_player.speed_scale = anim.length * speed
            anim_player.play("attack")

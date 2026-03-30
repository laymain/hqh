class_name MeleeAbility extends AbilityHandler

@export var arc_angle: float = 90.0

@onready var _hitbox: Area3D = $Area3D
@onready var _animation_player: AnimationPlayer = $AnimationPlayer

var _current_ctx: AbilityContext

func execute(_resource: AbilityResource, ctx: AbilityContext) -> void:
    _current_ctx = ctx
    _animation_player.play("attack")

func _on_attack_frame() -> void:
    # Called by AnimationPlayer event
    var info := _current_ctx.caster.attack.roll_damage(1.0, Enums.DamageType.PHYSICAL)
    
    var overlapping := _hitbox.get_overlapping_bodies()
    var forward := -global_transform.basis.z.normalized()
    
    for body in overlapping:
        if body == _current_ctx.caster: continue
        if body is Character:
            var dir_to_target := (body.global_position - global_position).normalized()
            # Ignore vertical difference for the angle check
            dir_to_target.y = 0
            forward.y = 0
            
            var dot := forward.dot(dir_to_target)
            var angle := rad_to_deg(acos(dot))
            
            if angle <= arc_angle / 2.0:
                body.handle_hit(info)

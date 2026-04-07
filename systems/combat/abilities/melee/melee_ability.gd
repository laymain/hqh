class_name MeleeAbility extends AbilityHandler

@onready var _hitbox: Area3D = $Area3D
@onready var _animation_player: AnimationPlayer = $AnimationPlayer
@onready var _vfx_sprite: Sprite3D = $VfxSprite

var _current_ctx: AbilityContext
var _current_resource: AbilityResource

func _exit_tree() -> void:
    _hitbox.monitoring = false
    _animation_player.stop()

func execute(resource: AbilityResource, ctx: AbilityContext) -> void:
    _current_resource = resource
    _current_ctx = ctx
    var mat := _vfx_sprite.material_override as ShaderMaterial
    if mat:
        mat.set_shader_parameter(&"rotation", global_rotation.y - _vfx_sprite.rotation.y)
    _animation_player.play(resource.get_animation(ctx.combo_index))
    await _animation_player.animation_finished

func _on_attack_frame() -> void:
    var shape_query := PhysicsShapeQueryParameters3D.new()
    shape_query.shape = (_hitbox.get_child(0) as CollisionShape3D).shape
    shape_query.transform = _hitbox.global_transform
    shape_query.collision_mask = (2 | 4) & ~_current_ctx.caster.collision_layer
    shape_query.exclude = [_current_ctx.caster.get_rid()]
    for result in get_world_3d().direct_space_state.intersect_shape(shape_query):
        var body := result["collider"] as Node3D
        if body is Character:
            var multiplier := _current_resource.get_multiplier(_current_ctx.combo_index)
            var info := _current_ctx.caster.attack.roll_damage(multiplier, Enums.DamageType.PHYSICAL)
            info.knockback_force = _current_resource.get_knockback_force(_current_ctx.combo_index)
            info.knockback_direction = (_current_ctx.caster.global_position - body.global_position).normalized() * -1.0
            body.handle_hit(info)

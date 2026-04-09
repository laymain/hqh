class_name DashAbility extends AbilityHandler

@export var dash_duration: float = 0.15

func execute(resource: AbilityResource, ctx: AbilityContext) -> void:
    var flat_aim := Vector3(ctx.aim_pos.x, ctx.caster.global_position.y, ctx.aim_pos.z)
    var direction := (flat_aim - ctx.caster.global_position).normalized()
    if direction == Vector3.ZERO:
        direction = -ctx.caster.global_basis.z
    ctx.caster.commands.emit(DashCommand.new(direction, resource.dash_force, false))
    await get_tree().create_timer(dash_duration).timeout

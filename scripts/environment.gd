extends Node

func _ready() -> void:
    var env := Environment.new()
    
    var sky_mat := ProceduralSkyMaterial.new()
    sky_mat.sky_top_color = Color.html("#1a1512")
    sky_mat.sky_horizon_color = Color.html("#2a2018")
    sky_mat.ground_bottom_color = Color.html("#1a1512")
    sky_mat.ground_horizon_color = Color.html("#2a2018")
    sky_mat.sun_angle_max = 0.0
    sky_mat.sun_curve = 0.0
    
    var sky := Sky.new()
    sky.sky_material = sky_mat
    
    env.background_mode = Environment.BG_SKY
    env.sky = sky
    
    env.ambient_light_source = Environment.AMBIENT_SOURCE_SKY
    env.ambient_light_color = Color.html("#554433")
    env.ambient_light_energy = 0.1
    
    env.glow_enabled = true
    env.glow_intensity = 0.5
    env.glow_bloom = 0.2
    env.glow_blend_mode = Environment.GLOW_BLEND_MODE_SOFTLIGHT
    
    var world_env := WorldEnvironment.new()
    world_env.environment = env
    add_child(world_env)

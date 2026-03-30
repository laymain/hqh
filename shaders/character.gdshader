shader_type spatial;
render_mode blend_mix, depth_prepass_alpha, cull_disabled, skip_vertex_transform, shadows_disabled;

uniform sampler2D albedo_tex : source_color, filter_nearest, repeat_disable;
uniform vec4 albedo_color : source_color = vec4(1.0);
uniform vec3 backlight_color : source_color = vec3(1.0);
uniform float backlight_strength : hint_range(0.0, 4.0) = 1.0;
uniform float alpha_cutoff : hint_range(0.0, 1.0) = 0.01;

#include "billboard.gdshaderinc"
void vertex() {
    VERTEX = get_billboard_vertex(VERTEX, MODEL_MATRIX, VIEW_MATRIX);
    NORMAL = vec3(0.0, 0.0, 1.0);
}

void fragment() {
    vec4 tex = texture(albedo_tex, UV) * albedo_color;
    ALBEDO = tex.rgb;
    ALPHA = tex.a;
    ALPHA_SCISSOR_THRESHOLD = alpha_cutoff;
    BACKLIGHT = backlight_color * backlight_strength;
}

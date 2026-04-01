shader_type spatial;
render_mode blend_mix, depth_prepass_alpha, cull_disabled, skip_vertex_transform, shadows_disabled, unshaded, depth_test_disabled;

uniform sampler2D albedo_tex : source_color, filter_nearest, repeat_disable;
uniform vec4 albedo_color : source_color = vec4(1.0);
uniform float alpha_cutoff : hint_range(0.0, 1.0) = 0.01;

#include "billboard.gdshaderinc"

void vertex() {
    VERTEX = get_billboard_vertex(VERTEX, MODEL_MATRIX, VIEW_MATRIX);
}

void fragment() {
    vec4 tex = texture(albedo_tex, UV) * albedo_color;
    ALBEDO = tex.rgb;
    ALPHA = tex.a;
    ALPHA_SCISSOR_THRESHOLD = alpha_cutoff;
}

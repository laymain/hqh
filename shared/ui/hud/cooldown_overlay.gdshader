shader_type canvas_item;

uniform sampler2D mask_texture : hint_default_white;
uniform float progress : hint_range(0.0, 1.0) = 1.0;

void fragment() {
    float shape = texture(mask_texture, UV).a;
    float clip = step(UV.y, progress);
    COLOR = vec4(0.0, 0.0, 0.0, 0.65 * shape * clip);
}

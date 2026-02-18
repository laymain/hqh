uniform bool hovering = false;

vec4 get_hovering_texture(vec4 tex, vec2 uv, sampler2D tex_sampler) {
    if (!hovering) {
        return tex;
    }

    // Subtler pulse: slower and with less variation
    float pulse = 0.85 + 0.15 * sin(TIME * 4.0);
    vec2 size = 1.2 / vec2(textureSize(tex_sampler, 0));

    // Sample 4 nearby points to detect edges
    float a = 0.0;
    a += texture(tex_sampler, uv + vec2(size.x, 0.0)).a;
    a += texture(tex_sampler, uv + vec2(-size.x, 0.0)).a;
    a += texture(tex_sampler, uv + vec2(0.0, size.y)).a;
    a += texture(tex_sampler, uv + vec2(0.0, -size.y)).a;

    // If we are on an opaque pixel but near a transparent edge
    if (tex.a > 0.1 && a < 4.0) {
        return vec4(mix(tex.rgb, vec3(1.0, 1.0, 1.0), 0.15 * pulse), tex.a);
    }

    return tex;
}

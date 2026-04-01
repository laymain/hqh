uniform float rotation = 0.0; // radians
uniform bool billboard_enabled = true;

vec3 get_billboard_vertex(vec3 original_vertex, mat4 model_matrix, mat4 view_matrix) {
    if (!billboard_enabled) {
        return (view_matrix * model_matrix * vec4(original_vertex, 1.0)).xyz;
    }

    vec3 center_ws = model_matrix[3].xyz;
    vec3 center_vs = (view_matrix * vec4(center_ws, 1.0)).xyz;

    // Keep Sprite3D/node scale from transform.
    float sy = length(model_matrix[1].xyz);
    float sx = length(model_matrix[0].xyz);

    vec2 p = original_vertex.xy;
    float s = sin(rotation);
    float c = cos(rotation);
    vec2 rp = vec2(p.x * c - p.y * s, p.x * s + p.y * c) * vec2(sx, sy);
    return vec3(center_vs.xy + rp, center_vs.z);
}

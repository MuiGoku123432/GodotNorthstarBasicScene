shader_type canvas_item;

uniform sampler2D main_texture;
uniform sampler2D lut_texture;
uniform mat4 uv_to_rect_x;
uniform mat4 uv_to_rect_y;
uniform mat4 matrix_p;

float polyval2d(float x, float y, mat4 C) {
    float x2 = x * x;
    float x3 = x2 * x;
    float y2 = y * y;
    float y3 = y2 * y;
    
    return (
        (C[0][0] + C[0][1] * y + C[0][2] * y2 + C[0][3] * y3) +
        (C[1][0] * x + C[1][1] * x * y + C[1][2] * x * y2 + C[1][3] * x * y3) +
        (C[2][0] * x2 + C[2][1] * x2 * y + C[2][2] * x2 * y2 + C[2][3] * x2 * y3) +
        (C[3][0] * x3 + C[3][1] * x3 * y + C[3][2] * x3 * y2 + C[3][3] * x3 * y3)
    );
}

vec2 resolve_with_poly(vec2 uv) {
    float x = polyval2d(uv.x, uv.y, uv_to_rect_x);
    float y = -polyval2d(uv.x, uv.y, uv_to_rect_y);  // Flip Y for correct coordinate space.
    vec3 view_space = vec3(x, y, -1.0);
    vec4 clip_space = matrix_p * vec4(view_space, 1.0);
    vec2 screen_pos = clip_space.xy / clip_space.w;
    return screen_pos;
}

void fragment() {
    vec2 uv = FRAGCOORD.xy / SCREEN_PIXEL_SIZE.xy;
    vec2 distorted_uv = resolve_with_poly(uv);
    vec4 base_color = texture(main_texture, distorted_uv);
    COLOR = base_color;
}

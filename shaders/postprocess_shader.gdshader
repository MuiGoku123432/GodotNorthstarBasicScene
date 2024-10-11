shader_type canvas_item;

uniform sampler2D left_eye_texture;
uniform sampler2D right_eye_texture;
uniform vec2 screen_size;

void fragment() {
    vec2 uv = FRAGCOORD.xy / screen_size;

    if (uv.x < 0.5) {
        // Render the left eye in the left half of the screen
        vec2 left_uv = vec2(uv.x * 2.0, uv.y);
        COLOR = texture(left_eye_texture, left_uv);
    } else {
        // Render the right eye in the right half of the screen
        vec2 right_uv = vec2((uv.x - 0.5) * 2.0, uv.y);
        COLOR = texture(right_eye_texture, right_uv);
    }
}

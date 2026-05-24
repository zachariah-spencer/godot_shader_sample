shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform sampler2D displacement_map : repeat_enable, filter_linear;

uniform float displacement_perc = 0.02;

void fragment() {
	vec2 moving_uv = UV + vec2(TIME * 0.05, TIME * 0.03);
	vec4 displacement_color = texture(displacement_map, moving_uv);

    vec2 displacement_uv = SCREEN_UV + vec2(
        displacement_color.r * displacement_perc - displacement_perc / 2.0
    );

    if (
		displacement_uv.x < 0.0 ||
		displacement_uv.x > 1.0 ||
		displacement_uv.y < 0.0 ||
		displacement_uv.y > 1.0
	) {
		COLOR = vec4(0.0, 0.0, 0.0, 1.0);
	} else {
		COLOR = texture(screen_texture, displacement_uv);
	}
}
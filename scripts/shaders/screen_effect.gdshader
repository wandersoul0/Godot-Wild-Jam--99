shader_type canvas_item;

render_mode unshaded;

uniform float scanline_count : hint_range(10.0, 1000.0, 1.0) = 180.0;
uniform float scanline_strength : hint_range(0.0, 1.0, 0.05) = 0.3;

uniform sampler2D screen_texture: hint_screen_texture;

void fragment() {
	float line_pattern = sin(2.0 * UV.y * scanline_count);
	vec3 scanlines = vec3(line_pattern * scanline_strength + (1.0 - scanline_strength));
	vec3 final_rgb = texture(screen_texture, SCREEN_UV).rgb * scanlines;
	COLOR = vec4(final_rgb, 1.0);
}

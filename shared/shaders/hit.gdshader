shader_type canvas_item;

uniform bool enable = false;

void fragment() {
	COLOR = texture(TEXTURE, UV);
	if (enable) {
		COLOR.rgb = vec3(1, 1, 1);
	}
}

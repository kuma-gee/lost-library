shader_type canvas_item;

//uniform float width : hint_range(0, 10) = 1.0;
//uniform vec4 line_color: source_color = vec4(0.0);
uniform vec4 color: source_color = vec4(1.0);

void fragment() {
	COLOR = color;
}
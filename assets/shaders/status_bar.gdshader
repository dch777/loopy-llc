shader_type canvas_item;

uniform vec4 happy_color : source_color = vec4(0.357, 0.702, 0.38, 1.0);
uniform vec4 tired_color : source_color = vec4(0.969, 0.894, 0.463, 1.0);
uniform vec4 angry_color : source_color = vec4(0.788, 0.141, 0.392, 1.0);

uniform float tired_size = 0.0;
uniform float angry_size = 0.0;

void fragment() {
	if (1.0 - UV.x < tired_size) {
		COLOR = tired_color;
	}
	else if (1.0 - UV.x < tired_size + angry_size) {
		COLOR = angry_color;
	}
	else {
		COLOR = happy_color;
	}
}

shader_type canvas_item;

uniform vec4 happy_color : source_color = vec4(0.357, 0.702, 0.38, 1.0);
uniform vec4 tired_color : source_color = vec4(0.969, 0.894, 0.463, 1.0);
uniform vec4 angry_color : source_color = vec4(0.788, 0.141, 0.392, 1.0);

uniform float happy_size = 0.7;
uniform float tired_size = 0.2;
uniform float angry_size = 0.1;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 uv = UV;
	
	if (uv.x < happy_size) {
		COLOR = happy_color;
	}
	else if (uv.x < happy_size + tired_size) {
		COLOR = tired_color;
	}
	else {
		COLOR = angry_color;
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}

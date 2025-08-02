shader_type canvas_item;

uniform float length;
uniform float width;

void fragment(){
	float l = length * UV.x;
	float w = width * UV.y;
	float speed = 3.0;

	if ((length - l) < width) {
		COLOR = vec4(1.0);
	} else if (l > 10.0) {
		COLOR = vec4(step(sin(speed * TIME + (length - l) / 3.0), 0.0));
	} else {
		COLOR = vec4(0.0);
	}
}
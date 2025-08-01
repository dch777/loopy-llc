shader_type canvas_item;

uniform float selected;
void fragment(){
	if (COLOR.a > 0.0 && selected == 1.0) {
		COLOR = vec4(0.969, 0.808, 0.463, 1.0);
	}
}
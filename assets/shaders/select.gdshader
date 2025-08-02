shader_type canvas_item;

uniform float selected;

void fragment(){
	float intensity = 0.8 + (0.2 * sin(PI * TIME));
	//vec4 outline_color = vec4(0.631, 0.898, 0.353, 1.0);
	//vec4 outline_color = vec4(0.788, 0.141, 0.392, intensity);
	vec4 outline_color = vec4(0.98, 0.57, 0.32, intensity);
	vec2 offset = 1.0 * TEXTURE_PIXEL_SIZE;
	
	vec4 sum_alpha = texture(TEXTURE, UV + vec2(1.0, 0.0) * offset) +
						texture(TEXTURE, UV + vec2(-1.0, 0.0) * offset) +
						texture(TEXTURE, UV + vec2(0.0, 1.0) * offset) +
						texture(TEXTURE, UV + vec2(0.0, -1.0) * offset)+
						texture(TEXTURE, UV + vec2(1.0, 1.0) * offset) +
						texture(TEXTURE, UV + vec2(1.0, -1.0) * offset) +
						texture(TEXTURE, UV + vec2(-1.0, 1.0) * offset) +
						texture(TEXTURE, UV + vec2(-1.0, -1.0) * offset);
	
	if (COLOR.a == 0.0 && sum_alpha.a > 0.0 && selected == 1.0) {
		COLOR = outline_color;
	}
	
	//float intensity = 0.1 * (sin(PI * TIME) + 2.0);
	//COLOR = vec4(1.0, 1.0, 1.0, intensity);
}
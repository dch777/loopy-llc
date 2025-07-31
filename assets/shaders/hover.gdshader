shader_type canvas_item;

varying flat vec2 vertexPos;
uniform vec2 highlighted_cell;
uniform float active;

void vertex() {
	vertexPos = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

void fragment() {
	float withinX = step(highlighted_cell.x, vertexPos.x + 16.0) * step(vertexPos.x, highlighted_cell.x);
	float withinY = step(highlighted_cell.y, vertexPos.y + 16.0) * step(vertexPos.y, highlighted_cell.y);
	float intensity = active * 0.1 * (sin(PI * TIME) + 2.0);

	vec4 textureColor = texture(TEXTURE, UV);
	COLOR = mix(textureColor, vec4(1.0, 1.0, 1.0, textureColor.a), intensity * withinX * withinY);
}
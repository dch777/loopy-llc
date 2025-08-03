shader_type canvas_item;

void fragment() {
	// Called for every pixel the material is visible on.
	COLOR = COLOR * step(UV.y, 0.05 * sin(UV.x * 4.0 * PI) + 0.5);
}
shader_type sky;

uniform vec3 SkyColor: source_color;
uniform vec3 HorizonColor: source_color;

void sky() {
	float col = clamp(EYEDIR.y / 0.5, 0.1, 1.0);
	vec3 FinalColor = mix(HorizonColor, SkyColor, col);
	COLOR = FinalColor;
	
}

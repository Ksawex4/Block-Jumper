shader_type canvas_item;

//void vertex() {
	//// Called for every vertex the material is visible on.
//}

float random (vec2 uv) {
	return fract(sin(dot(uv.xy,vec2(12.9898,78.233))) * 43758.5453123);
}

void fragment() {
	vec4 inputColor = texture(TEXTURE, UV);
	vec2 seed = FRAGCOORD.xy;
	float r = random(seed * SCREEN_PIXEL_SIZE * 100.0);
	float g = random(seed + SCREEN_PIXEL_SIZE * 100.0);
	float b = random(seed + TEXTURE_PIXEL_SIZE * 100.0);
	COLOR = vec4(r, g, b, inputColor.a);
}

//void fragment() {
	//vec4 inputColor = texture(TEXTURE, UV);
	//COLOR = vec4(vec3(1.0) - inputColor.rgb, inputColor.a);
//}
//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}

shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
//void vertex() {
	//// Called for every vertex the material is visible on.
//}
uniform float seed : hint_range(0.0, 1.0) = 0.0;

float random (float uv) {
	return fract(sin(uv * 12.9898) * 43758.5453);
	//return fract(sin(dot(uv.xy,vec2(12.9898,78.233))) * 43758.5453123);
}

void fragment() {
	vec4 inputColor = texture(SCREEN_TEXTURE, SCREEN_UV);
	//vec2 seed = FRAGCOORD.xy;
	float v = clamp(seed, 0.0, 1.0);
	float r = random(inputColor.r + 0.1 + v);
	float g = random(inputColor.g + 1.23134 + v);
	float b = random(inputColor.b + 2.35313 + v);
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

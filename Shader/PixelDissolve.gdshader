shader_type spatial;

uniform sampler2D albedo : filter_nearest;
uniform sampler2D noise;
uniform float amount : hint_range(0.0, 1.0, 0.01);


void fragment() {
	vec4 main_texture = texture(albedo,UV);
	
	//ALBEDO = main_texture.rgb;
	
	
	float noise_texture = texture(noise,UV).r;
	
	
	float dissolve = noise_texture - 1.0 + amount * 2.0;
	
	ALPHA = main_texture.a - dissolve;
}

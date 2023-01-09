shader_type canvas_item;

uniform float colors_count;
uniform float amount;

uniform bool pixelization_enabled = true;

void fragment() {
	vec2 pixel_uv;
	if (pixelization_enabled)
	{
		ivec2 size = textureSize(SCREEN_TEXTURE,0);
		vec2 aspect = vec2(float(size.x)/amount,float(size.y)/amount);
		
		pixel_uv = round(SCREEN_UV*aspect)/aspect;
	}
	else{
		pixel_uv = SCREEN_UV;
	}
	
	vec4 col = texture(SCREEN_TEXTURE,pixel_uv);
	col.rgb = round(col.rgb * colors_count)/colors_count;
	
	COLOR = col;
}

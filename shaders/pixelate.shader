shader_type canvas_item;

uniform int pixel_size : hint_range(0, 500);
uniform int resolution : hint_range(0, 1000);

void fragment() {
	vec2 grid_uv = round(UV * float(pixel_size)) / float(pixel_size);
	vec4 tex = texture(TEXTURE, grid_uv);
	COLOR = tex;
	if(resolution > 0) {
		if (mod(round(UV.x * float(resolution)), 2.0) == 0.0) {
			COLOR.a = 0.0;
		}
		if (mod(round(UV.y * float(resolution)), 2.0) == 0.0) {
			COLOR.a = 0.0;
		}	
	}
}
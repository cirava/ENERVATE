shader_type spatial;

void fragment() 
{
	vec2 _uv = UV;
	
	_uv.x += sin(TIME + (_uv.x + _uv.y) * 25.0) * 0.01;
	_uv.y += cos(TIME + (_uv.x - _uv.y) * 25.0) * 0.01;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}

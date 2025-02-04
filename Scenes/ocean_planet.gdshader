shader_type canvas_item;



void fragment() {
	float dist = length(UV - vec2(0.5,0.5));
	if (dist >= 0.5 + sin(TIME + UV.x + UV.y)/800.0){
		COLOR.a = 0.0;
	}
	else{
		COLOR.a = 0.8;
	}
}

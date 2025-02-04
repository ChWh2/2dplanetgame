shader_type canvas_item;

void vertex(){
	COLOR.xy = COLOR.xy + UV * vec2(cos(TIME), sin(TIME));
}

void fragment() {
	float dist = length(UV - vec2(0.5,0.5));
	if (dist >= 0.5){
		COLOR.a = 0.0;
	}
	else{
		COLOR.a = 1.0;
	}
}

shader_type canvas_item;

uniform vec4 water_color: source_color = vec4(1, 0, 0, 1);
uniform float water_wave_speed : hint_range(-100, 100, 0.01) = 2;
uniform float water_wave_ci: hint_range(0, 2, 0.01) = 0.05;
uniform float water_back_lightness: hint_range(0, 1, 0.01) = 0.8;
uniform vec4 ball_color: source_color = vec4(vec3(1), 1);
uniform float ball_border_ci : hint_range(0, 50, 1) = 5;
uniform float ball_light_speed : hint_range(-100, 100, 0.01) = 2;
uniform bool light_effect = false;
uniform bool border_exclusion_effect = false;
uniform float wave_num : hint_range(2, 8, 1) = 2;
uniform bool wave_fix_on_border = false;
uniform float height : hint_range(0, 1, 0.01) = 0.5;

vec4 ontop(vec4 base, vec4 blend){
	return mix(base,blend,blend.a);
}

vec4 exclusion(vec4 base, vec4 blend){
	return base + blend - 2.0 * base * blend;
}

void fragment() {

	vec2 uv = UV*0.5 - 0.5;

	float a = wave_fix_on_border ? 2. : 1.;
	float b = wave_fix_on_border ? 1. : 0.5;

	if (distance(UV, vec2(0.5,0.5)) > 1.0/2.0) {

		COLOR = vec4(0.);
	} else {

		if (height == 1. || height == 0.) {

			COLOR = vec4(water_color.rgb,height);
		} else {

			if (sin((cos(uv.x*PI*a) + TIME*water_wave_speed)*wave_num)*water_wave_ci + (1. - height) > UV.y) { 

				COLOR = vec4(0.);
			} else {

				COLOR = vec4(water_color*water_back_lightness);
			}
			
			if (sin((cos(uv.x*PI*a + PI*b) + TIME*water_wave_speed)*wave_num)*water_wave_ci + (1. - height) < UV.y) { 

				COLOR = vec4(water_color);
			}
		}

		float L = 0.;

		if (light_effect) {L = cos(distance(UV, sin(uv*uv) + TIME*ball_light_speed))*0.25;}

		COLOR = border_exclusion_effect ? exclusion(COLOR, vec4(vec3(1.),pow(distance(UV, vec2(0.5,0.5))*2.,ball_border_ci) + L)*ball_color) : ontop(COLOR, vec4(vec3(1.),pow(distance(UV, vec2(0.5,0.5))*2.,ball_border_ci) + L)*ball_color);
	}
}
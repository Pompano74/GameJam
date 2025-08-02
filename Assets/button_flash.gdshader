shader_type canvas_item;

uniform vec4 colour : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float tint_factor : hint_range(0.0, 1.0) = 0.5;
uniform float fade : hint_range(0.0, 1.0) = 1.0;

uniform float border_fade_size : hint_range(0.0, 0.5) = 0.1;
uniform float pixel_size : hint_range(1.0, 128.0) = 8.0;

uniform vec2 fade_origin = vec2(0.5, 0.5);
uniform float fade_outer_limit : hint_range(0.0, 1.0) = 0.5;

uniform float corner_roundness : hint_range(0.0, 1.0) = 0.0; // 0 = square, 1 = circular
uniform float shader_alpha : hint_range(0.0, 1.0) = 1.0;

void fragment() {
    // Pixelation
    vec2 pixel_uv = floor(UV * pixel_size) / pixel_size;
    vec4 main_texture = texture(TEXTURE, pixel_uv);
    vec4 final_output = main_texture;

    // Tinting
    float original_modulation = 1.0 - tint_factor;
    final_output.rgb = mix(main_texture.rgb * original_modulation, colour.rgb * tint_factor, tint_factor);
	
	
	
    // Distances
    float square_dist = max(abs(pixel_uv.x - fade_origin.x), abs(pixel_uv.y - fade_origin.y));
    float circle_dist = distance(pixel_uv, fade_origin);

    // Blend between square and circle shape
    float blended_dist = mix(square_dist, circle_dist, corner_roundness);

    // Smooth fade at edge
    float alpha = smoothstep(fade_outer_limit, fade_outer_limit - border_fade_size, blended_dist);

    final_output.a *= fade * alpha * shader_alpha;

    COLOR = final_output;
}


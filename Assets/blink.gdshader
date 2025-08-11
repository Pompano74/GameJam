shader_type canvas_item;
uniform float alpha_color = 1;

void fragment() {
vec4 color = texture(TEXTURE, UV);
color.a = alpha_color;

COLOR = color;

}

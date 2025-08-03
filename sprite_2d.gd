extends Sprite2D

# Fade values
var shader_alpha := 0.5
var alpha_increasing := true

var fade_outer := 0.3
var fade_increasing := true

# Speeds (tweak in editor)
@export var lerp_speed := 4.0           # For shader_alpha
@export var fade_speed := 4.0           # For fade_outer_limit

func _process(delta):
	# -- Shader Alpha (0.0 to 1.0)
	if alpha_increasing:
		shader_alpha = lerp(shader_alpha, 1.0, delta * lerp_speed)
		if abs(shader_alpha - 1.0) < 0.2:
			shader_alpha = 1.0
			alpha_increasing = false
	else:
		shader_alpha = lerp(shader_alpha, 0.0, delta * lerp_speed)
		if abs(shader_alpha - 0.0) < 0.1:
			shader_alpha = 0.5
			alpha_increasing = true
	material.set_shader_parameter("shader_alpha", shader_alpha)

	# -- Fade Outer Limit (0.3 to 0.45)
	if fade_increasing:
		fade_outer = lerp(fade_outer, 0.45, delta * fade_speed)
		if abs(fade_outer - 0.45) < 0.001:
			fade_outer = 0.45
			fade_increasing = false
	else:
		fade_outer = lerp(fade_outer, 0.3, delta * fade_speed)
		if abs(fade_outer - 0.3) < 0.001:
			fade_outer = 0.3
			fade_increasing = true
	material.set_shader_parameter("fade_outer_limit", fade_outer)

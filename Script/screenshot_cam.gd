extends Camera2D


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("move_down"):
		var img = get_viewport().get_texture().get_image()
		img.save_png("user://screenshot.png")
		print("screenshot!")

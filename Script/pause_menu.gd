extends Control

@onready var texture_button: TextureButton = $TextureButton

func _ready() -> void:
	Engine.time_scale = 0

	texture_button.pressed.connect(_on_texture_button_pressed)

func _process(delta: float) -> void:
	if Engine.time_scale == 0:
		texture_button.position = Vector2(395, 170)
	elif Engine.time_scale == 1:
		texture_button.position = Vector2(840, 0)

func _on_texture_button_pressed() -> void:
	if Engine.time_scale == 0:
		Engine.time_scale = 1
	else:
		Engine.time_scale = 0
	print("Paused:", Engine.time_scale)

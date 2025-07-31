extends Control

@onready var texture_button: TextureButton = $TextureButton

func _ready() -> void:
	get_tree().paused = true

func _process(delta: float) -> void:
	if get_tree().paused:
		texture_button.position = Vector2(395, 170)
	else:
		texture_button.position = Vector2(840, 0)

func _on_texture_button_pressed() -> void:
	get_tree().paused = !get_tree().paused
	print("Paused:", get_tree().paused)

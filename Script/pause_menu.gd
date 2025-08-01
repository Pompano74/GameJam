extends Control

@onready var png: Sprite2D = $CanvasLayer/TextureButton/Png
@onready var animation_player: AnimationPlayer = $CanvasLayer/AnimationPlayer

@export var pause: Texture
@export var reload: Texture
func _ready() -> void:
	Engine.time_scale = 0
	animation_player.play("basic")
	pausePosition = Vector2(440, 170)
	gamePosition = Vector2(900, 25)
	pauseScale = Vector2(2,2)
	gameScale = Vector2(1, 1)


func _process(delta: float) -> void:
	if Engine.time_scale == 0:
		png.texture = pause
	elif Engine.time_scale == 1:
		png.texture = reload
	
func _on_texture_button_pressed() -> void:
	if Engine.time_scale == 0:
		Engine.time_scale = 1
		animation_player.play_backwards("blur")
	else:
		get_tree().reload_current_scene()
	print("Paused:", Engine.time_scale)

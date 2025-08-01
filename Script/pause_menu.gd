extends Control

@onready var png: Sprite2D = $CanvasLayer/TextureButton/Png
@onready var animation_player: AnimationPlayer = $CanvasLayer/AnimationPlayer
@onready var beat_manager = get_parent()

@export var pause: Texture
@export var reload: Texture
func _ready() -> void:
	Engine.time_scale = 0
	animation_player.play("basic")



func _process(delta: float) -> void:
	if Engine.time_scale == 0:
		png.texture = pause
	elif Engine.time_scale == 1:
		png.texture = reload
	
func _on_texture_button_pressed() -> void:
	if Engine.time_scale == 0:
		if beat_manager.conditionMet == true:
			Engine.time_scale = 1
			animation_player.play_backwards("blur")
		else: pass
	else:
		get_tree().reload_current_scene()
	print("Paused:", Engine.time_scale)

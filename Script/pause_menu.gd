extends Control

@onready var png: Sprite2D = $CanvasLayer/TextureButton/Png
@onready var animation_player: AnimationPlayer = $CanvasLayer/AnimationPlayer
@onready var beat_manager = get_parent()
@onready var sprite_2d: Sprite2D = $"../CanvasLayer/Sprite2D"
@export var pause: Texture
@export var reload: Texture
@onready var player: Player = $"../../.."

signal game_pause
signal game_resume

func _ready() -> void:
	await player.get_player_camera()
	Engine.time_scale = 0
	animation_player.play("basic")
	game_pause.emit() #vers characterbody2d
	print("fin")
	



func _process(delta: float) -> void:
	if Engine.time_scale == 0:
		png.texture = pause
		sprite_2d.visible = false
	elif Engine.time_scale == 1:
		png.texture = reload
		sprite_2d.visible = true
	
func _on_texture_button_pressed() -> void:
	if Engine.time_scale == 0:
		Engine.time_scale = 1
		animation_player.play_backwards("blur")
		game_resume.emit()
	
	else:
		get_tree().reload_current_scene()
	print("Paused:", Engine.time_scale)

extends Control

@onready var texture_button: TextureButton = $CanvasLayer/TextureButton

var pausePosition: Vector2 
var gamePosition: Vector2 
var pauseScale: Vector2 
var gameScale: Vector2 
@export var unpause: Sprite2D
@export var reload: Sprite2D
func _ready() -> void:
	Engine.time_scale = 0
	pausePosition = Vector2(440, 170)
	gamePosition = Vector2(900, 25)
	pauseScale = Vector2(2,2)
	gameScale = Vector2(1, 1)

func _process(delta: float) -> void:
	if Engine.time_scale == 0:
		texture_button.position = pausePosition
		texture_button.scale = pauseScale
	elif Engine.time_scale == 1:
		texture_button.position = gamePosition
		texture_button.scale = gameScale
	
func _on_texture_button_pressed() -> void:
	if Engine.time_scale == 0:
		Engine.time_scale = 1
	else:
		get_tree().reload_current_scene()
	print("Paused:", Engine.time_scale)

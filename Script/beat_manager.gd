extends Node

var bpm: float
var beatDuration: float
@onready var timer: Timer = $Timer
var powersIndex: int = 0
@export var actions: Array[String] = ["Nothing", "Jump", "Dash", "Gravity"]
@onready var animated_sprite: AnimatedSprite2D = $CanvasLayer/AnimatedSprite2D

@export var drumRolls: Array[ButtonSelect]
var maxRolls: int = 8
@onready var audio_stream_player_2d = $AudioStreamPlayer2D
@onready var label = $"../../Label"
@onready var player: Player = $"../.."



func _ready() -> void:
	bpm = player.modifyBpm
	label.text = "bpm: " + str(bpm)
	print("------ Arbre de la scène ------")
	get_tree().get_root().print_tree_pretty()
	print("-------------------------------")

	Engine.time_scale = 0
	
	beatDuration = 60.0 / bpm
	timer.wait_time = beatDuration
	timer.start()
	

func _process(_delta: float) -> void:
	bpm = player.modifyBpm
	var limitedDrumRolls = drumRolls.slice(0, maxRolls)
	
	for drumRoll in limitedDrumRolls:
		if drumRoll:  # vérifie que le bouton existe
			var index = drumRoll.currentActionIndex
			if index >= 0 and index < actions.size():
				drumRoll.text = actions[index]
			else:
				drumRoll.text = "Invalid"
	var newBeatDuration = 60.0 / bpm
	if newBeatDuration != beatDuration:
		beatDuration = newBeatDuration
		timer.wait_time = beatDuration

	# Optionally update the text display each frame for the active drumRoll
	if powersIndex >= 0 and powersIndex < drumRolls.size():
		var drumRoll = drumRolls[powersIndex]
		if drumRoll:
			var index = drumRoll.currentActionIndex
			if index >= 0 and index < actions.size():
				drumRoll.text = actions[index]
			else:
				drumRoll.text = "Invalid"

func _on_timer_timeout() -> void:
	# Reset powersIndex if it goes past the limit
	if powersIndex >= 8:
		powersIndex = 0

	# Update and trigger the action for the current powersIndex
	if powersIndex >= 0 and powersIndex < drumRolls.size():
		var drumRoll = drumRolls[powersIndex]
		if drumRoll:
			var index = drumRoll.currentActionIndex
			if index >= 0 and index < actions.size():
				drumRoll.text = actions[index]
				
				Blink()
				print("Bouton", powersIndex, "→", drumRoll.text)

				match drumRoll.text:
					"Nothing":
						audio_stream_player_2d.play()
						pass
					"Jump":
						audio_stream_player_2d.play()
						player.jump()
					"Dash":
						audio_stream_player_2d.play()
						player.dash()
					"Gravity":
						audio_stream_player_2d.play()
						player.gravity()
			else:
				drumRoll.text = "Invalid"

	powersIndex += 1
	
func Blink():
	var tween = get_tree().create_tween()
	tween.tween_method(SetShader, 1.0, 0.0, 0.5)
	
func SetShader(newValue: float):
	animated_sprite.material.set_shader_parameter("alpha_color", newValue)

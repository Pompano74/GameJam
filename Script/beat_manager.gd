extends Node

var bpm: int = 30
var beatDuration: float
@onready var timer: Timer = $Timer
var powersIndex: int = 0
@onready var input_manager: Node = get_node("InputManager")
@onready var player: CharacterBody2D = get_node("../Player/CharacterBody2D")


func _ready() -> void:
	beatDuration = 60.0 / bpm
	timer.wait_time = beatDuration
	timer.start()

func _process(_delta: float) -> void:
	var newBeatDuration = 60.0 / bpm
	if newBeatDuration != beatDuration:
		beatDuration = newBeatDuration
		timer.wait_time = beatDuration

	# Optionally update the text display each frame for the active drumRoll
	if powersIndex >= 0 and powersIndex < input_manager.drumRolls.size():
		var drumRoll = input_manager.drumRolls[powersIndex]
		if drumRoll:
			var index = drumRoll.currentActionIndex
			if index >= 0 and index < input_manager.actions.size():
				drumRoll.text = input_manager.actions[index]
			else:
				drumRoll.text = "Invalid"

func _on_timer_timeout() -> void:
	# Reset powersIndex if it goes past the limit
	if powersIndex >= 8:
		powersIndex = 0

	# Update and trigger the action for the current powersIndex
	if powersIndex >= 0 and powersIndex < input_manager.drumRolls.size():
		var drumRoll = input_manager.drumRolls[powersIndex]
		if drumRoll:
			var index = drumRoll.currentActionIndex
			if index >= 0 and index < input_manager.actions.size():
				drumRoll.text = input_manager.actions[index]
				print("Bouton", powersIndex, "→", drumRoll.text)

				match drumRoll.text:
					"Nothing":
						pass
					"Jump":
						player.jump()
					"Dash":
						player.dash()
					"Gravity":
						player.gravity()
			else:
				drumRoll.text = "Invalid"

	powersIndex += 1
	#print("Nouveau powersIndex :", powersIndex)

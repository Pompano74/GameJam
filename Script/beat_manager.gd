extends Node

var bpm: int = 30
var beatDuration: float
@onready var timer: Timer = $Timer
var powersIndex: int = 0
@export var actions: Array[String] = ["Nothing", "Jump", "Dash", "Gravity"]

@export var drumRolls: Array[ButtonSelect]
var maxRolls: int = 8
@onready var player = get_parent().get_parent()




func _ready() -> void:
	print("------ Arbre de la scène ------")
	get_tree().get_root().print_tree_pretty()
	print("-------------------------------")

	Engine.time_scale = 0
	beatDuration = 60.0 / bpm
	timer.wait_time = beatDuration
	timer.start()
	

func _process(_delta: float) -> void:
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

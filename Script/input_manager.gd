extends Node

@export var actions: Array[String] = ["Nothing", "Jump", "Dash", "Attack"]

@export var drumRolls: Array[ButtonSelect]
var maxRolls: int = 8

func _process(_delta: float) -> void:
	var limitedDrumRolls = drumRolls.slice(0, maxRolls)
	
	for drumRoll in limitedDrumRolls:
		if drumRoll:  # vérifie que le bouton existe
			var index = drumRoll.currentActionIndex
			if index >= 0 and index < actions.size():
				drumRoll.text = actions[index]
			else:
				drumRoll.text = "Invalid"

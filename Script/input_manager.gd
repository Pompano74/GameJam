extends Node

var actions: Array[String] = ["Nothing", "Jump", "Dash", "Attack"]

var currentAction: String
var drumRolls: Array[Button]
var maxRolls: int = 8

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	drumRolls


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	drumRolls.slice(0, maxRolls)
	currentAction = actions[0]
	
	for drumRoll in drumRolls: 
	pass

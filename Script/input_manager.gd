extends Node

var actions: Array[String] = ["Jump", "Dash", "Attack"]
var drumRolls: Array[String]
var maxRolls: int = 8
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	drumRolls


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	drumRolls.slice(0, maxRolls)
	
	for drumRoll in drumRolls:
		pass

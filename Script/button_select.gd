class_name ButtonSelect
extends Button

@export var currentActionIndex: int = 0
@export var maxActionIndex: int = 3
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(currentActionIndex)
	if currentActionIndex > maxActionIndex:
		currentActionIndex = 0



func _on_pressed():
	currentActionIndex += 1
	print(currentActionIndex)

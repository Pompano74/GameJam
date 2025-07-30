class_name ButtonSelect
extends Button

@export var currentActionIndex: int = 0
@export var maxActionIndex: int = 4
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	print("Au moins t'a click")
	currentActionIndex = currentActionIndex + 1
	print(currentActionIndex)

	if currentActionIndex >= maxActionIndex:
		currentActionIndex = 0
		print("oui")



	

class_name ButtonSelect
extends Button

@export var currentActionIndex: int = 0
@export var maxActionIndex: int = 4

func _ready() -> void:
	self.pressed.connect(_on_button_pressed)

func _on_button_pressed() -> void:
	currentActionIndex += 1
	print("Au moins t'as cliqué")
	print(currentActionIndex)

	if currentActionIndex >= maxActionIndex:
		currentActionIndex = 0
		print("oui")

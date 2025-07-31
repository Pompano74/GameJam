class_name ButtonSelect
extends Button

@export var currentActionIndex: int = 0
@export var maxActionIndex: int = 4
@export var canChange: bool
func _ready() -> void:
	self.pressed.connect(_on_button_pressed)
	Engine.time_scale = 0

func _process(delta: float) -> void:
	if Engine.time_scale == 0:
		canChange = true
	elif Engine.time_scale == 1:
		canChange = false
func _on_button_pressed() -> void:
	if canChange:
		currentActionIndex += 1
		print("Au moins t'as cliqué")
		print(currentActionIndex)

	if currentActionIndex >= maxActionIndex:
		currentActionIndex = 0
		print("oui")

extends Button

class_name LevelButton

@export var level_name: String
@export var is_locked: bool = true

signal level_selected(level_name: String)

func _ready():
	update_state()
	pressed.connect(_on_button_pressed)

func update_state():
	modulate = Color(0.5, 0.5, 0.5) if is_locked else Color(1, 1, 1)
	disabled = is_locked

func _on_button_pressed():
	if not is_locked:
		level_selected.emit(level_name)

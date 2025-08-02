extends Button

@onready var button_manager = get_tree().get_first_node_in_group("button_manager")
@onready var button_index := -1
var button_capacity

func _on_pressed():
	if button_manager:
		button_manager.button_call(self)

extends Button

@onready var click_sound = $"../click_sound"
@onready var button_manager = get_tree().get_first_node_in_group("button_manager")
@onready var button_index := -1
var button_capacity

func _on_pressed():
	click_sound.play()
	if button_manager:
		button_manager.button_call(self)

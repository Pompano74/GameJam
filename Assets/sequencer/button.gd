extends Button

@onready var click_sound = $"../click_sound"
@onready var button_manager = get_tree().get_first_node_in_group("button_manager")
@onready var button_index := -1
var button_capacity

func _on_pressed():
	click_sound.play()
	if button_manager:
		button_manager.button_call(self)


@export var min_brightness := 0.5  # 0.0 = full black, 1.0 = original brightness

func _on_mouse_entered() -> void:
	var parent = get_parent()
	if parent and parent.has_method("set_modulate"):
		print("PARENT FOUND WITH ITS PROPERTIES")
		var current_color = parent.modulate
		parent.modulate = Color(min_brightness, min_brightness, min_brightness, current_color.a)

func _on_mouse_exited() -> void:
	var parent = get_parent()
	if parent and parent.has_method("set_modulate"):
		var current_color = parent.modulate
		parent.modulate = Color(1.0, 1.0, 1.0, current_color.a)

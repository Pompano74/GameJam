extends Button
@onready var click_sound = $"../click_sound"
@onready var case_stop = get_tree().get_first_node_in_group("pause_button")
@onready var sequencer = get_tree().get_first_node_in_group("button_manager")
var is_on = false
@onready var animation_player = get_tree().get_first_node_in_group("animatedspriteplayer")

func _on_button_down():
	click_sound.play()
	
	print("pressed")
	if is_on == false:
		case_stop.visible = true
		sequencer.as_pressed_play = true
		sequencer.timer_start()
		print("timer_start")
	if is_on == true:
		animation_player.animation = "win"
		case_stop.visible = false
		sequencer.as_pressed_play = false
		sequencer.timer_stop()
		print("timer_stop")
func _on_button_up():
	if is_on == true:
		is_on = false
		print("on")
	elif is_on == false:
		is_on = true
		print("off")

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

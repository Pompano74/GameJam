extends Button
@onready var click_sound = $"../click_sound"

@onready var sequencer = get_tree().get_first_node_in_group("button_manager")
var is_on = false

func _on_button_down():
	click_sound.play()
	print("pressed")
	if is_on == false:
		sequencer.as_pressed_play = true
		sequencer.timer_start()
		print("timer_start")
	if is_on == true:
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

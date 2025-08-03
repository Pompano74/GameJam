extends Button

@onready var click_sound: AudioStreamPlayer2D = $click_sound
@onready var sequencer = get_tree().get_first_node_in_group("button_manager")
var is_on = false


func _on_button_down() -> void:
	print("pressed")
	if is_on == false:
		sequencer.screenshot.visible = true
		print("map opened")
	if is_on == true:
		sequencer.screenshot.visible = false
		print("map closed")


func _on_button_up() -> void:
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

func _process(delta: float) -> void:
	if sequencer.player.sequence_is_playing == true:
		sequencer.screenshot.visible = false

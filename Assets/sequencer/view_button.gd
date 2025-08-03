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

func _process(delta: float) -> void:
	if sequencer.player.sequence_is_playing == true:
		sequencer.screenshot.visible = false

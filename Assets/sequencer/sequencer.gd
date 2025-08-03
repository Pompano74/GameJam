extends Node2D

#-----button var------#
@onready var start_button_call = get_tree().get_first_node_in_group("start_button")
@export var capacity_texture_list: Array[Texture2D] # Index: 0 = default, 1 = jump, 2 = dash, 3 = gravity, 4 = rotate
@onready var buttons = get_tree().get_nodes_in_group("buttons")
@onready var sprite = get_tree().get_nodes_in_group("button_sprite")
var as_pressed_play = false
# Capacity limits

@export var MAX_CAPACITY_JUMP := 0
@export var MAX_CAPACITY_DASH := 0
@export var MAX_CAPACITY_GRAVITE := 0
@export var MAX_CAPACITY_ROTATE := 0

#level screenshot pour le mode pause
@export var lvl_screenshot: Texture2D
@onready var screenshot: Sprite2D = $Sprite2D/screenshot


var capacity_counts = {
	"jump": 0,
	"dash": 0,
	"gravity": 0,
	"rotate": 0
}
var max_capacities = {}
# One index per button, tracks which texture it's using
var button_states = []


#-----sequencer var------#
@onready var timer = $Timer
@export var bpm: float = 120
@onready var metronom = $metronom
var sequence_loop = 0
@onready var start_button = $start_button


#-----Player-------#
@onready var player = $"../.."

#-----UI labels-----#
@onready var ui_label = get_tree().get_nodes_in_group("UI_Label")

# Called when the node enters the scene tree
func _ready():
	screenshot.texture = lvl_screenshot
	
	await get_tree().process_frame
	
	
	
	
	max_capacities = {
	"jump": MAX_CAPACITY_JUMP,
	"dash": MAX_CAPACITY_DASH,
	"gravity": MAX_CAPACITY_GRAVITE,
	"rotate": MAX_CAPACITY_ROTATE
}
# Access the icon inside the button
	for i in range(buttons.size()):
		if buttons[i].material is ShaderMaterial:
			buttons[i].material = buttons[i].material.duplicate()
			buttons[i].material.set_shader_parameter("shader_alpha", 0.0)
		
		
		button_states.append(0) # Default state
		buttons[i].button_index = i
	ui_label[0].text = "BPM = " + str(bpm)
	ui_label[1].text = str(MAX_CAPACITY_JUMP)
	ui_label[2].text = str(MAX_CAPACITY_DASH)
	ui_label[3].text = str(MAX_CAPACITY_GRAVITE)
	ui_label[4].text = str(MAX_CAPACITY_ROTATE)
	
# Mapping index to capacity name
func get_capacity_name(index):
	match index:
		1: return "jump"
		2: return "dash"
		3: return "gravity"
		4: return "rotate"
		_: return null

# Called by button
func button_call(body):

	# Make sure the node exists and has a ShaderMaterial
	
	if as_pressed_play == false:
		var index = body.button_index
		var sprite = get_tree().get_nodes_in_group("button_sprite")[index]
		var current_capacity = button_states[index]
		
		# Free up old capacity
		var old_name = get_capacity_name(current_capacity)
		if old_name and capacity_counts[old_name]:
			capacity_counts[old_name] -= 1

		# Loop to next capacity
		var next_capacity = (current_capacity + 1) % capacity_texture_list.size()
		var looped = false

		# Skip over full capacities
		while true:
			var cap_name = get_capacity_name(next_capacity)
			if cap_name == null:
				break
			elif capacity_counts[cap_name] < max_capacities[cap_name]:
				break
				
			next_capacity = (next_capacity + 1) % capacity_texture_list.size()
			if next_capacity == (current_capacity + 1) % capacity_texture_list.size():
				# All capacities full — reset to default
				next_capacity = 0
				looped = true
				break
		
		sprite.texture = capacity_texture_list[next_capacity]
		
		button_states[index] = next_capacity
		
		# Assign new capacity count if not default
		var new_name = get_capacity_name(next_capacity)
		if new_name and capacity_counts.has(new_name):
			capacity_counts[new_name] += 1
		
		ui_label[1].text = str(MAX_CAPACITY_JUMP - capacity_counts["jump"])
		ui_label[2].text = str(MAX_CAPACITY_DASH - capacity_counts["dash"])
		ui_label[3].text = str(MAX_CAPACITY_GRAVITE - capacity_counts["gravity"])
		ui_label[4].text = str(MAX_CAPACITY_ROTATE - capacity_counts["rotate"])
		print("Button", index, " → ", new_name if new_name else "default")
		print("Current counts: ", capacity_counts)
		return current_capacity
		
	
func _on_timer_timeout():
	
	if buttons.is_empty():
		return
 
	match button_states[sequence_loop]:
		1:
			player.jump()
		2:
			player.dash()
		3:
			player.gravity()
		4:
			player.rotate_world()
		_:
			metronom.play()
			print("No action")
	buttons[sequence_loop].material.set_shader_parameter("shader_alpha", 1.0)
	if sequence_loop > 0:
		buttons[sequence_loop - 1].material.set_shader_parameter("shader_alpha", 0.0)
	sequence_loop += 1
	if sequence_loop >= buttons.size():
		sequence_loop = 0
	else:
		buttons[7].material.set_shader_parameter("shader_alpha", 0.0)
	
	print("action: " + str(button_states[sequence_loop]))
	
func timer_start():
	player.sequence_is_playing = true
	timer.wait_time = 60 / bpm
	timer.start()
func timer_stop():
	buttons[sequence_loop - 1].material.set_shader_parameter("shader_alpha", 0.0)
	player.sequence_is_playing = false
	sequence_loop = 0
	player.game_restart()
	timer.stop()
func restart_timer_stop():
	start_button_call.restart_button()
	buttons[sequence_loop - 1].material.set_shader_parameter("shader_alpha", 0.0)
	player.sequence_is_playing = false
	sequence_loop = 0
	timer.stop()
func level_finish_paude():
	var sprite = get_tree().get_nodes_in_group("button_sprite")
	player.sequence_is_playing = false
	timer.stop()
	for i in buttons.size():
		if sprite != null:
			sprite[i].texture = capacity_texture_list[0]
	for n in buttons.size():
		if buttons[n].material is ShaderMaterial:
			buttons[n].material.set_shader_parameter("shader_alpha", 1.0)

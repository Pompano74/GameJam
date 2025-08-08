extends Node2D

#@onready var _dummy_level_1 := preload("res://level/MainLevel/level_1.tscn")
#@onready var _dummy_level_2 := preload("res://Level/MainLevel/level_2.tscn")
#@onready var _dummy_level_3 := preload("res://Level/MainLevel/level_3.tscn")
#@onready var _dummy_level_4 := preload("res://Level/MainLevel/level_4.tscn")
#@onready var _dummy_level_5 := preload("res://Level/MainLevel/level_5.tscn")
#@onready var _dummy_level_6 := preload("res://Level/MainLevel/level_6.tscn")
#@onready var _dummy_level_7 := preload("res://Level/MainLevel/level_7.tscn")
#@onready var _dummy_level_8 := preload("res://Level/MainLevel/level_8.tscn")
#@onready var _dummy_level_9 := preload("res://Level/MainLevel/level_9.tscn")
#@onready var _dummy_level_10 := preload("res://Level/MainLevel/level_10.tscn")
#@onready var _dummy_level_11 := preload("res://Level/MainLevel/level_11.tscn")
#@onready var _dummy_level_12 := preload("res://Level/MainLevel/level_12.tscn")
#@onready var _dummy_level_13 := preload("res://Level/MainLevel/level_13.tscn")
#@onready var _dummy_level_14 := preload("res://Level/MainLevel/level_14.tscn")
#@onready var _dummy_level_15 := preload("res://Level/MainLevel/level_15.tscn")
#@onready var _dummy_level_16 := preload("res://Level/MainLevel/level_16.tscn")
#@onready var _dummy_level_17 := preload("res://Level/MainLevel/level_17.tscn")

var level_buttons: Array[Button] = []
# Static variable to track unlocked levels across scene changes
static var unlocked_levels: Array[int] = [1]  # Start with level 1 unlocked

func _ready():
	# Add this node to the level_manager group
	add_to_group("level_manager")
	
	# Collect all level buttons
	collect_level_buttons()
	
	# Wait one frame to ensure all buttons are ready
	await get_tree().process_frame
	
	# Set all buttons based on unlocked_levels array
	setup_buttons_from_progress()

func collect_level_buttons():
	# Clear the array first
	level_buttons.clear()
	
	# Get all children that start with "ButtonNiveau"
	for child in get_children():
		if child.name.begins_with("ButtonNiveau") and child is Button:
			level_buttons.append(child)
			
			# Set the level number based on button name
			var level_num = extract_level_number(child.name)
			child.level_number = level_num
			print("Found button ", child.name, " with level_number: ", level_num)
			
			# Set scene path dynamically for all levels
			child.level_scene_path = "res://Level/MainLevel/level_%d.tscn" % level_num
			
			# Set label text with zero-padded numbers (01, 02, 03, etc.)
			var label = child.get_node_or_null("Label")
			if label:
				label.text = "%02d" % level_num
	
	print("Total buttons collected: ", level_buttons.size())

func extract_level_number(button_name: String) -> int:
	# Extract number from "ButtonNiveau1", "ButtonNiveau2", etc.
	var regex = RegEx.new()
	regex.compile("ButtonNiveau(\\d+)")
	var result = regex.search(button_name)
	if result:
		return result.get_string(1).to_int()
	return 1

func setup_buttons_from_progress():
	"""Set button states based on unlocked_levels array"""
	for button in level_buttons:
		if button.level_number in unlocked_levels:
			button.unlock_button()
		else:
			button.lock_button()
	
	print("Buttons setup complete. Unlocked levels: ", unlocked_levels)

func unlock_level(completed_level: int):
	"""
	Call this function when a level is completed to unlock the next one.
	Usage from another script: get_node("path/to/your/Node2D").unlock_level(2)
	"""
	var next_level = completed_level + 1
	
	# Add to static unlocked_levels array if not already there
	if next_level not in unlocked_levels:
		unlocked_levels.append(next_level)
		print("Level ", next_level, " added to unlocked levels!")
	
	# If we're currently in the level selection scene, update the button
	unlock_level_button(next_level)

func unlock_level_button(level_num: int):
	"""Unlock a specific level button"""
	print("=== UNLOCK_LEVEL_BUTTON DEBUG ===")
	print("Looking for level: ", level_num)
	print("Total buttons in array: ", level_buttons.size())
	
	for i in range(level_buttons.size()):
		var button = level_buttons[i]
		print("Button [", i, "]: name=", button.name, " level_number=", button.level_number)
		
		if button.level_number == level_num:
			print("FOUND MATCH! Unlocking button: ", button.name)
			button.unlock_button()
			print("Level ", level_num, " is now unlocked!")
			return
			
	print("Level ", level_num, " not found!")
	print("=== END DEBUG ===")

extends Node2D

var level_buttons: Array[Button] = []

func _ready():
	# Collect all level buttons
	collect_level_buttons()
	
	# Lock all buttons first, then unlock only level 1
	lock_all_buttons()
	unlock_level_button(1)

func lock_all_buttons():
	"""Lock all level buttons initially"""
	for button in level_buttons:
		if button.has_method("lock_button"):
			button.lock_button()

func unlock_level_button(level_num: int):
	"""Unlock a specific level button"""
	for button in level_buttons:
		if button.level_number == level_num:
			if button.has_method("unlock_button"):
				button.unlock_button()
			print("Level ", level_num, " is now unlocked!")
			return
	print("Level ", level_num, " not found!")

func collect_level_buttons():
	# Get all children that start with "ButtonNiveau"
	for child in get_children():
		if child.name.begins_with("ButtonNiveau") and child is Button:
			level_buttons.append(child)
			
			# Set the level number based on button name
			var level_num = extract_level_number(child.name)
			if child.has_method("set_level_number"):
				child.level_number = level_num
			
			# Set scene path dynamically for all levels
			child.level_scene_path = "res://level/MainLevel/Level_%d.tscn" % level_num
			
			# Set label text with zero-padded numbers (01, 02, 03, etc.)
			var label = child.get_node_or_null("Label")
			if label:
				label.text = "%02d" % level_num
			
			# Alternative methods:
			# Method 1: Using format strings
			# child.level_scene_path = "res://level/MainLevel/Level_{0}.tscn".format([level_num])
			
			# Method 2: Using string concatenation
			# child.level_scene_path = "res://level/MainLevel/Level_" + str(level_num) + ".tscn"

func extract_level_number(button_name: String) -> int:
	# Extract number from "ButtonNiveau1", "ButtonNiveau2", etc.
	var regex = RegEx.new()
	regex.compile("ButtonNiveau(\\d+)")
	var result = regex.search(button_name)
	if result:
		return result.get_string(1).to_int()
	return 1

func unlock_level(completed_level: int):
	"""
	Call this function when a level is completed to unlock the next one.
	Usage from another script: get_node("path/to/your/Node2D").unlock_level(2)
	"""
	var next_level = completed_level + 1
	unlock_level_button(next_level)

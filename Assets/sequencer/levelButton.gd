extends Button

@export var level_number: int = 1
@export var level_scene_path: String = ""
@export var is_unlocked: bool = false

var locked_color = Color(0.4, 0.4, 0.4, 1.0)  # Darker color for locked state
var unlocked_color = Color(1.0, 1.0, 1.0, 1.0)  # Normal color for unlocked state

func _ready():
	# Connect the button press signal
	pressed.connect(_on_button_pressed)
	
	# The LevelManager will handle initial locking/unlocking
	# Don't set state here to avoid conflicts

func lock_button():
	is_unlocked = false
	disabled = true  # Disable the button (unclickable)
	modulate = locked_color  # Darken the button visually
	
	# Also dim the label if it exists
	var label = get_node_or_null("Label")
	if label:
		label.modulate = locked_color  # Darken the label text

func unlock_button():
	is_unlocked = true
	disabled = false  # Enable the button (clickable)
	modulate = unlocked_color  # Restore normal brightness
	
	# Restore label color if it exists
	var label = get_node_or_null("Label")
	if label:
		label.modulate = unlocked_color  # Restore normal label brightness

func _on_button_pressed():
	if is_unlocked and level_scene_path != "":
		# Load the level scene (only for the first button in this example)
		if level_number == 1:
			load_level_scene()

func load_level_scene():
	# Method 1: Direct scene change
	get_tree().change_scene_to_file(level_scene_path)

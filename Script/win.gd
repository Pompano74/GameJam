extends Area2D

@onready var animation_player = $AnimationPlayer
@onready var color_rect: ColorRect = $CanvasLayer/ColorRect
@onready var animation_player_2: AnimationPlayer = $CanvasLayer/AnimationPlayer
@onready var sequencer = get_tree().get_first_node_in_group("button_manager")
@onready var music_player = $CharacterBody2D/MusicPlayer
@onready var level_1 = get_tree().get_first_node_in_group("level_1")
@onready var pickup_sound_last_level = $"pickup Sound last level"
var last_level: bool
@onready var music_player_final = $"pickup Sound last level"
@onready var player = get_tree().get_first_node_in_group("player")

var current_scene_file
var next_level_number
var next_level_path

var level_finished = false
var finished_timer = 4


func _ready() -> void:
	color_rect.visible = false
	print(player)
	

func _on_body_entered(body):
	player = player.get_child(0)
	player.win_animation()
	current_scene_file = get_tree().current_scene.scene_file_path
	if current_scene_file == "res://Level/MainLevel/level_17.tscn":
		finished_timer = 11
		color_rect.visible = true
		animation_player.play("PickupSound_2")
		animation_player_2.play("fade_to_black")
		level_finished = true
		print("is last level")
		var bus_index = AudioServer.get_bus_index("Main Music")
		AudioServer.set_bus_volume_db(bus_index, -80)

	else:
		finished_timer = 4
		color_rect.visible = true
		animation_player.play("PickupSound")
		animation_player_2.play("fade_to_black")
		level_finished = true
		print("not last level")
		

func _process(delta):
	if level_finished == true:
		sequencer.level_finish_paude()
		finished_timer -= delta
		if finished_timer <= 0:
			level_finished == false
			next_level()
			animation_player_2.play("fade_to_normal")
func next_level():
	# Get the root scene name (like "Level_2")
	var scene_name = get_tree().current_scene.name
	print("Scene name: ", scene_name)
	
	# Extract number from "Level_2" -> 2
	var level_number = extract_number_from_scene_name(scene_name)
	print("Current level number: ", level_number)
	
	# Unlock the next level
	var level_manager = get_tree().get_first_node_in_group("level_manager")
	if level_manager: 
		level_manager.unlock_level(level_number)
		print("Unlocking level: ", level_number + 1)
	
	var next_level_number = level_number + 1
	
	if next_level_number == 18:
		get_tree().change_scene_to_file("res://Assets/sequencer/sequencer.tscn")  # Go to level selection
		print("go to level selection")
		level_finished = false
	else:
		var next_level_path = "res://Level/MainLevel/level_" + str(next_level_number) + ".tscn"
		get_tree().change_scene_to_file(next_level_path)
		print("go to level ", next_level_number)

func extract_number_from_scene_name(scene_name: String) -> int:
	# Extract number from "Level_2" -> 2
	var parts = scene_name.split("_")
	if parts.size() > 1:
		return parts[1].to_int()
	return 1  # Default to 1 if extraction fails

func extract_level_number_from_path(path: String) -> int:
	# For paths like "res://Level/MainLevel/level_2.tscn"
	# Extract the number between "level_" and ".tscn"
	var regex = RegEx.new()
	regex.compile("level_(\\d+)\\.tscn")
	var result = regex.search(path)
	if result:
		return result.get_string(1).to_int()
	return 1  # Default to level 1 if extraction fails

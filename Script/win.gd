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

var current_scene_file
var next_level_number
var next_level_path

var level_finished = false
var finished_timer = 4


func _ready() -> void:
	color_rect.visible = false
	

func _on_body_entered(body):
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
	var current_scene_file = get_tree().current_scene.scene_file_path
	var next_level_number = current_scene_file.to_int() + 1
	var next_level_path = "res://Level/MainLevel/level_" + str(next_level_number) + ".tscn"
	if next_level_number == 18:
		get_tree().change_scene_to_file("res://Level/MainLevel/level_1.tscn")
		print("go to level 1")
		level_finished = false
	else:
		next_level_number = current_scene_file.to_int() + 1
		get_tree().change_scene_to_file(next_level_path)
	

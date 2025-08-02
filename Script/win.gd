extends Area2D

@onready var animation_player = $AnimationPlayer
@onready var color_rect: ColorRect = $CanvasLayer/ColorRect
@onready var animation_player_2: AnimationPlayer = $CanvasLayer/AnimationPlayer
@onready var sequencer = get_tree().get_first_node_in_group("button_manager")

var current_scene_file
var next_level_number
var next_level_path

var level_finished = false
var finished_timer = 4

func _ready() -> void:
	color_rect.visible = false

func _on_body_entered(body):
	color_rect.visible = true
	animation_player.play("PickupSound")
	animation_player_2.play("fade_to_black")
	level_finished = true

func _process(delta):
	if level_finished == true:
		sequencer.level_finish_paude()
		finished_timer -= delta
		print("next level")
		print(finished_timer)
		if finished_timer <= 0:
			level_finished == false
			next_level()
			animation_player_2.play("fade_to_normal")
			print("poop")
			
func next_level():
	var current_scene_file = get_tree().current_scene.scene_file_path
	var next_level_number = current_scene_file.to_int() + 1
	var next_level_path = "res://Level/MainLevel/level_" + str(next_level_number) + ".tscn"
	get_tree().change_scene_to_file(next_level_path)

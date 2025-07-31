extends Area2D

@onready var animation_player = $AnimationPlayer

var current_scene_file
var next_level_number
var next_level_path

var level_finished = false
var finished_duration = 2.0
var finished_timer = 0.0


func _on_body_entered(body):
	animation_player.play("PickupSound")
	level_finished = true
	finished_timer = finished_duration

func _process(delta):
	if level_finished == true:
		finished_timer -= delta
		print("next level")
		if finished_timer <= 0:
			next_level()
			level_finished == false
			print("poop")
			
func next_level():
	var current_scene_file = get_tree().current_scene.scene_file_path
	var next_level_number = current_scene_file.to_int() + 1
	var next_level_path = "res://Level/MainLevel/level_" + str(next_level_number) + ".tscn"
	get_tree().change_scene_to_file(next_level_path)

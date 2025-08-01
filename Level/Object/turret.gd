extends Node2D

const BULLET = preload("res://Level/Object/bullet.tscn")

@onready var gun = $pivot
@onready var fire_point = $pivot
@onready var ray_cast_2d = $RayCast2D
@onready var timer = $RayCast2D/Timer

var player = null

func _ready():
	await get_tree().process_frame
	player = get_tree().get_nodes_in_group("player").front()
	timer.start()

func _process(delta):
	if player == null:
		return

	
	var dir = global_position.direction_to(player.global_position)
	var angle_to_target = dir.angle()
	
	
	ray_cast_2d.rotation = angle_to_target
	gun.rotation = angle_to_target

	
	if ray_cast_2d.is_colliding() and ray_cast_2d.get_collider().is_in_group("player"):
		if timer.is_stopped():
			shoot()

func shoot():
	print("pew")

	var bullet = BULLET.instantiate()
	get_tree().current_scene.add_child(bullet)
	
	bullet.global_position = fire_point.global_position
	bullet.rotation = gun.rotation
	
	timer.start()

func _on_timer_timeout():
	pass

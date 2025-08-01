class_name Player
extends CharacterBody2D

var origin_point = null
var target_rotation = 0.0
var rotation_amount = 45

@onready var player_sprite_2d = $Sprite2D
@onready var particles = $GPUParticles2D

var Dev_mode = false

#player movement
var gravity_direction = Vector2.DOWN
var gravity_force = 3
var jump_direction = 1
var player_speed = 300
var player_jump_strength = -850

var dash_force = 1000
var dash_direction = 1
var is_dashing = false
var dash_duration = 0.8
var dash_timer = 0.0

var is_in_killzone = false
	
func _ready():
	var origin_nodes = get_tree().get_nodes_in_group("origin_point")
	if origin_nodes.size() > 0:
		origin_point = origin_nodes[0] as Node2D
	print(origin_point)
	add_to_group("player")

func _process(delta):
	if Input.is_action_just_pressed("debug_2") && Dev_mode == false:
		Dev_mode = true
		print("dev_mode TRUE")
	elif Input.is_action_just_pressed("debug_2") && Dev_mode == true:
		Dev_mode = false
		print("dev_mode TRUE")
		
	#capacité debug
	if Input.is_action_just_pressed("debug_9"):
		jump()
	if Input.is_action_just_pressed("debug_8"):
		dash()
	if Input.is_action_just_pressed("debug_7"):
		rotate_world()
	if Input.is_action_just_pressed("debug_6"):
		gravity()
		
func _physics_process(delta):
	
	#variables
	var direction = Input.get_axis("move_left", "move_right")
	#player direction
	if Input.is_action_just_pressed("move_left"):
			dash_direction = -1
			player_sprite_2d.flip_h = true
	elif Input.is_action_just_pressed("move_right"):
		dash_direction = 1
		player_sprite_2d.flip_h = false
	#free movement
	if Dev_mode == true:
			# change gravity direction
		if Input.is_action_just_pressed("debug_1"):
			gravity()
		# dash
		if Input.is_action_just_pressed("dash"):
			dash()
		
		if Input.is_action_just_pressed("attack"):
			rotate_world()
				
		if Input.is_action_just_pressed("jump"):
			jump()
	#gravity
	if gravity_direction == Vector2.DOWN:
		if not is_on_floor():
			velocity += get_gravity() * gravity_direction * delta * gravity_force
			player_sprite_2d.flip_v = false
	elif gravity_direction == Vector2.UP:
		if not is_on_ceiling():
			velocity += get_gravity() * gravity_direction * delta * gravity_force
			player_sprite_2d.flip_v = true
	#side movement
	if not is_dashing:
		if direction:
			velocity.x = direction * player_speed
		else:
			velocity.x = move_toward(velocity.x, 0, player_speed)
	else:
		velocity.x = lerp(velocity.x, direction * player_speed, 2 * delta)
	# dash timer
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			particles.emitting = false
			is_dashing = false
			player_sprite_2d.modulate = Color(1,1,1,1)
			print("vulnerable")
			if is_in_killzone == true:
				die()
	
	if origin_point != null:
		origin_point.rotation = lerp_angle(origin_point.rotation, target_rotation, delta * 5)
	move_and_slide()

#Capacité joueur
func jump():
	velocity.y = player_jump_strength * jump_direction
func dash():
	particles.emitting = true
	is_dashing = true
	player_sprite_2d.modulate = Color(0,50,1,1)
	dash_timer = dash_duration
	velocity.y = -200 * jump_direction
	velocity.x = dash_direction * dash_force
	print("invicible")
func rotate_world():
	velocity.y = player_jump_strength * jump_direction * 0.05
	if origin_point != null:
		target_rotation += deg_to_rad(rotation_amount)
	else:
		print("no origin point")
func gravity():
		if gravity_direction == Vector2.DOWN:
			velocity.y = player_jump_strength * jump_direction
			gravity_direction = Vector2.UP
			jump_direction = -1
			print("GRAVITY UP")
		else:
			velocity.y = player_jump_strength * jump_direction
			gravity_direction = Vector2.DOWN
			jump_direction = 1
			print("GRAVITY DOWN")

#attack kill
func _on_area_2d_body_entered(body):
	body.queue_free()
	print("enemie killed")

#player fail condition
func on_killzone_enter():
	print("body entered")
	is_in_killzone = true
func on_killzone_exit():
	is_in_killzone = false
	print("body exited")
func die():
	if is_dashing == false:
		print("die func called")
		get_tree().reload_current_scene()

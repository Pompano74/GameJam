extends CharacterBody2D


@onready var player_sprite_2d = $Sprite2D
@onready var attack = $Attack
@onready var attack_area_2d = $Attack/Attack_Sprite/Area2D

#player movement
var gravity_direction = Vector2.DOWN
var gravity_force = 3
var jump_direction = 1
var player_speed = 300
var player_jump_strength = -700

var dash_force = 1000
var dash_direction = 1
var is_dashing = false
var dash_duration = 0.4
var dash_timer = 0.0

var is_attack = false
var attack_duration = 0.4
var attack_timer = 0.0
	

func _physics_process(delta):
	attack_area_2d.monitoring = false
	#player direction
	var direction = Input.get_axis("move_left", "move_right")
	
	if Input.is_action_just_pressed("move_left"):
		dash_direction = -1
		player_sprite_2d.flip_h = true
		attack.rotation = deg_to_rad(180)
	elif Input.is_action_just_pressed("move_right"):
		dash_direction = 1
		player_sprite_2d.flip_h = false
		attack.rotation = deg_to_rad(0)
		
	#Gravity change
	if gravity_direction == Vector2.DOWN:
		jump_direction = 1
	elif gravity_direction == Vector2.UP:
		jump_direction = -1
	
	if Input.is_action_just_pressed("debug_1"):
		if gravity_direction == Vector2.DOWN:
			velocity.y = player_jump_strength * jump_direction
			gravity_direction = Vector2.UP
			print("GRAVITY UP")
		else:
			velocity.y = player_jump_strength * jump_direction
			gravity_direction = Vector2.DOWN
			print("GRAVITY DOWN")

	
	# change gravity direction
	if gravity_direction == Vector2.DOWN:
		if not is_on_floor():
			velocity += get_gravity() * gravity_direction * delta * gravity_force
			player_sprite_2d.flip_v = false
	elif gravity_direction == Vector2.UP:
		if not is_on_ceiling():
			velocity += get_gravity() * gravity_direction * delta * gravity_force
			player_sprite_2d.flip_v = true
	
	# dash
	if Input.is_action_just_pressed("dash"):
		is_dashing = true
		collision_layer = 3
		player_sprite_2d.modulate = Color(0,50,1,1)
		dash_timer = dash_duration
		velocity.x = dash_direction * dash_force
		print("invicible")

	# dash timer
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false
			collision_layer = 2
			player_sprite_2d.modulate = Color(1,1,1,1)
			print("vulnerable")
	
	#attack
	if Input.is_action_just_pressed("attack"):
		is_attack = true
		attack.visible = true
		attack_area_2d.monitoring = true
		print("attacking")
		attack_timer = attack_duration
	
	if is_attack:
		attack_timer -= delta
		if attack_timer <= 0:
			is_attack = false
			attack.visible = false
			attack_area_2d.monitoring = false
	

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		velocity.y = player_jump_strength * jump_direction

	# movement
	if not is_dashing:
		if direction:
			velocity.x = direction * player_speed
		else:
			velocity.x = move_toward(velocity.x, 0, player_speed)
	else:
		velocity.x = lerp(velocity.x, direction * player_speed, 2 * delta)

	move_and_slide()


func _on_area_2d_body_entered(body):
	body.queue_free()
	print("enemie killed")

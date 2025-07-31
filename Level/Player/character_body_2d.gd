extends CharacterBody2D

var delta_time

@onready var player_sprite_2d = $Sprite2D
@onready var attack_object = $Attack
@onready var attack_area_2d = $Attack/Attack_Sprite/Area2D

var Dev_mode = false

#player movement
var gravity_direction = Vector2.DOWN
var gravity_force = 3
var jump_direction = 1
var player_speed = 300
var player_jump_strength = -700

var dash_force = 1000
var dash_direction = 1
var is_dashing = false
var dash_duration = 0.8
var dash_timer = 0.0

var is_attack = false
var attack_duration = 0.4
var attack_timer = 0.0

var is_in_killzone = false
	
func _ready():
	add_to_group("player")

func _process(delta):
	delta_time = delta
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
		attack()
	if Input.is_action_just_pressed("debug_6"):
		gravity()
		
func _physics_process(delta):
	
	var direction = Input.get_axis("move_left", "move_right")
	attack_area_2d.monitoring = false
	
	#player direction
	if Input.is_action_just_pressed("move_left"):
			dash_direction = -1
			player_sprite_2d.flip_h = true
			attack_object.rotation = deg_to_rad(180)
	elif Input.is_action_just_pressed("move_right"):
		dash_direction = 1
		player_sprite_2d.flip_h = false
		attack_object.rotation = deg_to_rad(0)
	
	#free movement
	if Dev_mode == true:
			# change gravity direction
		if Input.is_action_just_pressed("debug_1"):
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

		
		
		# dash
		
		if Input.is_action_just_pressed("dash"):
			is_dashing = true
			player_sprite_2d.modulate = Color(0,50,1,1)
			dash_timer = dash_duration
			velocity.x = dash_direction * dash_force
			print("invicible")

		# dash timer
		if is_dashing:
			dash_timer -= delta
			if dash_timer <= 0:
				is_dashing = false
				player_sprite_2d.modulate = Color(1,1,1,1)
				print("vulnerable")
				if is_in_killzone == true:
					die()
		
		#attack
		if Input.is_action_just_pressed("attack"):
			is_attack = true
			attack_object.visible = true
			attack_area_2d.monitoring = true
			print("attacking")
			attack_timer = attack_duration
		
		if is_attack:
			attack_timer -= delta
			if attack_timer <= 0:
				is_attack = false
				attack_object.visible = false
				attack_area_2d.monitoring = false
		

		# Handle jump.
		if Input.is_action_just_pressed("jump"):
			velocity.y = player_jump_strength * jump_direction
	
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
		dash_timer -= delta_time
		if dash_timer <= 0:
			is_dashing = false
			player_sprite_2d.modulate = Color(1,1,1,1)
			print("vulnerable")
			if is_in_killzone == true:
				die()
	
	#attack timer
	if is_attack:
		attack_timer -= delta_time
		if attack_timer <= 0:
			is_attack = false
			attack_object.visible = false
			attack_area_2d.monitoring = false		
	move_and_slide()
#Capacité joueur
func jump():
	velocity.y = player_jump_strength * jump_direction
func dash():
	is_dashing = true
	player_sprite_2d.modulate = Color(0,50,1,1)
	dash_timer = dash_duration
	velocity.x = dash_direction * dash_force
	print("invicible")
func attack():
	is_attack = true
	attack_object.visible = true
	attack_area_2d.monitoring = true
	print("attacking")
	attack_timer = attack_duration
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
func _on_area_2d_body_entered(body):
	body.queue_free()
	print("enemie killed")

func on_killzone_enter():
	print("body entered")
	is_in_killzone = true
func on_killzone_exit():
	is_in_killzone = false
	print("body exited")

func die():
	if is_dashing == false:
		print("die func called")
		queue_free()

extends CharacterBody2D

#player movement
var gravity_direction = Vector2.DOWN
var gravity_force = 3
var jump_direction = 1
var player_speed = 800
var player_jump_strength = -1500
var dash_force = 3000
var dash_direction = 1
	

func _physics_process(delta):
	
	var direction = Input.get_axis("move_left", "move_right")
	if Input.is_action_just_pressed("move_left"):
		dash_direction = -1
	elif Input.is_action_just_pressed("move_right"):
		dash_direction = 1
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

	
	# Add the gravity.
	if not is_on_floor() or is_on_ceiling():
		velocity += get_gravity() * gravity_direction * delta * gravity_force
	
	if Input.is_action_just_pressed("dash"):
		velocity.x  = dash_direction * dash_force
		velocity.y = -400
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = player_jump_strength * jump_direction
	elif Input.is_action_just_pressed("jump") and is_on_ceiling():
		velocity.y = player_jump_strength * jump_direction

	
	if is_on_floor() or is_on_ceiling():
		if direction:
			velocity.x = direction * player_speed
		else:
			velocity.x = move_toward(velocity.x, 0, player_speed)
	else:
		velocity.x = lerp(velocity.x, direction * player_speed, 2 * delta)

	move_and_slide()

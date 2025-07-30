extends CharacterBody2D


var gravity_direction = Vector2.DOWN
var jump_direction = 1
var player_speed = 300.0
var player_jump_strength = -400.0


func _physics_process(delta):
	
	
	
	if gravity_direction == Vector2.DOWN:
		jump_direction = 1
	elif gravity_direction == Vector2.UP:
		jump_direction = -1
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * gravity_direction * delta 

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = player_jump_strength * jump_direction

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * player_speed
	else:
		velocity.x = move_toward(velocity.x, 0, player_speed)

	move_and_slide()

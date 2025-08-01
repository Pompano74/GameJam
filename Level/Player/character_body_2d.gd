class_name Player
extends CharacterBody2D

@export var maxJump: int = 1
@export var maxDash: int = 1
@export var maxGravity: int = 1
@export var maxRotate: int = 1
@onready var origin_point = null
@onready var player_sprite_2d = $Sprite2D
@onready var particles = $GPUParticles2D

@export var modifyBpm: float = 60.0
var Dev_mode = false

# Mouvement joueur
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

# Rotation autour du joueur
var rotation_amount_deg = 45
var rotating = false
var rotation_duration = 0.15
var rotation_timer = 0.0
var origin_start_pos = Vector2.ZERO
var origin_start_rot = 0.0
var rotation_direction = 1
var angle_rotate = 0.0

var disable_player_input = false
signal inputs_disabled
signal game_resume

#variables pour la camera
var player_cam: Camera2D
var player_cam_global_position: Vector2
var player_cam_zoom: Vector2

# New: Counter to manage consecutive rotations
var remaining_rotations = 0

func _ready():
	var origin_nodes = get_tree().get_nodes_in_group("room")
	player_cam =  get_tree().get_nodes_in_group("camera").front()
	if origin_nodes.size() > 0:
		origin_point = origin_nodes[0] as Node2D
	add_to_group("player")
	print(player_cam)

func _process(delta):
	if rotating:
		rotation_timer += delta
		var t = clamp(rotation_timer / rotation_duration, 0, 1)
		var angle = lerp(0.0, deg_to_rad(rotation_amount_deg * rotation_direction), t)

		var pivot = player_sprite_2d.global_position
		var new_position = rotate_around(pivot, origin_start_pos, angle)

		origin_point.global_position = new_position
		origin_point.rotation = origin_start_rot + angle

		if t >= 1.0:
			rotating = false
			remaining_rotations -= 1

			if remaining_rotations > 0:
				# Set up the next rotation
				start_rotation_step()
	
	if Input.is_action_just_pressed("debug_2"):
		Dev_mode = !Dev_mode
		print("dev_mode", Dev_mode)

	if Input.is_action_just_pressed("debug_9"):
		jump()
	if Input.is_action_just_pressed("debug_8"):
		dash()
	if Input.is_action_just_pressed("debug_7"):
		rotate_world()
	if Input.is_action_just_pressed("debug_6"):
		gravity()

func _physics_process(delta):
	var direction = Input.get_axis("move_left", "move_right")

	if Input.is_action_just_pressed("move_left"):
		dash_direction = -1
		player_sprite_2d.flip_h = true
	elif Input.is_action_just_pressed("move_right"):
		dash_direction = 1
		player_sprite_2d.flip_h = false

	if Dev_mode:
		if Input.is_action_just_pressed("debug_1"):
			gravity()
		if Input.is_action_just_pressed("dash"):
			dash()
		if Input.is_action_just_pressed("attack"):
			rotate_world()
		if Input.is_action_just_pressed("jump"):
			jump()

	if gravity_direction == Vector2.DOWN:
		if not is_on_floor():
			velocity += get_gravity() * gravity_direction * delta * gravity_force
			player_sprite_2d.flip_v = false
	elif gravity_direction == Vector2.UP:
		if not is_on_ceiling():
			velocity += get_gravity() * gravity_direction * delta * gravity_force
			player_sprite_2d.flip_v = true

	if not is_dashing:
		if direction:
			velocity.x = direction * player_speed
		else:
			velocity.x = move_toward(velocity.x, 0, player_speed)
	else:
		velocity.x = lerp(velocity.x, direction * player_speed, 2 * delta)

	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			particles.emitting = false
			is_dashing = false
			player_sprite_2d.modulate = Color(1,1,1,1)
			print("vulnerable")
			if is_in_killzone:
				die()

	move_and_slide()

# Capacité joueur
func jump():
	if not disable_player_input:
		velocity.y = player_jump_strength * jump_direction
	else:
		pass

func dash():
	if not disable_player_input:
		particles.emitting = true
		is_dashing = true
		player_sprite_2d.modulate = Color(0,50,1,1)
		dash_timer = dash_duration
		velocity.y = -200 * jump_direction
		velocity.x = dash_direction * dash_force
		print("invicible")
	else:
		pass

func rotate_world():
	if not disable_player_input:
		if origin_point != null and not rotating:
			remaining_rotations = 2  # Two 45-degree steps = 90 degrees
			start_rotation_step()
		else:
			print("no origin point or already rotating")
	else:
		pass

func start_rotation_step():
	rotating = true
	rotation_timer = 0.0
	origin_start_pos = origin_point.global_position
	origin_start_rot = origin_point.rotation
	# You could randomize or invert direction if desired
	rotation_direction = 1

func gravity():
	if not disable_player_input:
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
	else:
		pass

func rotate_around(pivot: Vector2, point: Vector2, angle: float) -> Vector2:
	var relative = point - pivot
	var rotated = Vector2(
		relative.x * cos(angle) - relative.y * sin(angle),
		relative.x * sin(angle) + relative.y * cos(angle)
	)
	return pivot + rotated

# Ennemis
func _on_area_2d_body_entered(body):
	body.queue_free()
	print("enemie killed")

# Zone de mort
func on_killzone_enter():
	is_in_killzone = true
	print("body entered")

func on_killzone_exit():
	is_in_killzone = false
	print("body exited")

func die():
	if not is_dashing:
		print("die func called")
		velocity = Vector2.ZERO
		set_physics_process(false)
		await get_tree().create_timer(1).timeout
		get_tree().reload_current_scene()

# Quand le jeu est mis sur pause a partir de la node PauseMenu
func _on_pause_menu_game_pause() -> void:
	disable_player_input = true
	if player_cam != null:
		player_cam_global_position = player_cam.global_position
		player_cam_zoom = player_cam.zoom
		inputs_disabled.emit(disable_player_input, player_cam_global_position, player_cam_zoom) #vers pause_camera
	else:
		pass

func _on_pause_camera_switch_to_player_cam() -> void:
	player_cam.make_current()
	disable_player_input = false

func _on_pause_menu_game_resume() -> void:
	player_cam_global_position = player_cam.global_position
	player_cam_zoom = player_cam.zoom
	game_resume.emit(player_cam_global_position, player_cam_zoom)

extends Camera2D

#position globale des limites de la camera du niveau

#pause cam variables
var pause_cam
@onready var ui: Sprite2D = $"../CharacterBody2D/Camera2D/Sprite2D2"
@export var zoom_amount = Vector2(2,2)
@export var pause_cam_zoom = Vector2(1,1)
@export var ui_scale = Vector2(1,1)

var camera_position = Vector2 (0, 0)
var camera_zoom = Vector2 (1, 1)
var initial_zoom_out = Vector2 (2,2)
var zoom_out_speed: float = 3
var zoom_in_speed: float = 3

#camera control variables
var camera_controls: bool = false
var move_speed: float = 3
var zoom_speed: float = 3
var min_zoom = Vector2 (4,4)
var max_zoom = Vector2 (1,1)

#player cam variables
var player_camera_position = Vector2 (0, 0)
var player_camera_zoom = Vector2 (1, 1)

signal switch_to_player_cam

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_pause_camera()
	print(ui)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#check si le zoom out a fini
	if camera_zoom == initial_zoom_out:
		camera_controls = true
	
	#check si le camera reset a fini
	if camera_zoom == player_camera_zoom and camera_position == player_camera_position:
		switch_to_player_cam.emit()
	
	#controles camera
	if camera_controls == true:
		var move_direction = Vector2.ZERO
		if Input.is_action_pressed("move_left"):
			move_direction.x -= 1
		if Input.is_action_pressed("move_right"):
			move_direction.x += 1
		if Input.is_action_pressed("move_up"):
			move_direction.y -= 1
		if Input.is_action_pressed("move_down"):
			move_direction.y += 1
		
		if move_direction != Vector2.ZERO:
			move_direction = move_direction.normalized()
			camera_position += move_direction * move_speed * delta
		
		if Input.is_action_pressed("zoom_in"):
			camera_zoom -= Vector2.ONE * zoom_speed * delta
		if Input.is_action_pressed("zoom_out"):
			camera_zoom += Vector2.ONE * zoom_speed * delta
		
		camera_zoom.x = clamp(camera_zoom.x, max_zoom.x, min_zoom.x)
		camera_zoom.y = clamp(camera_zoom.y, max_zoom.y, min_zoom.y)
	
	pause_cam.position = pause_cam.position.lerp(camera_position, delta * move_speed)
	pause_cam.zoom = pause_cam.zoom.lerp(camera_zoom, delta * zoom_speed)
	
	if initial_zoom_out != ui.scale:
		ui.scale.x = initial_zoom_out.x * (ui.scale.x * ui.scale.x)
		ui.scale.y = initial_zoom_out.y * (ui.scale.y * ui.scale.y)
		pause_cam.zoom = initial_zoom_out
	else:
		pass
	
	print(ui.scale)
	print(pause_cam.zoom)
	
	#camera_zoom = lerp(camera_zoom, initial_zoom_out, delta * zoom_out_speed)

func _on_character_body_2d_inputs_disabled(is_input_disabled: bool, player_cam_global_position: Vector2, player_cam_zoom: Vector2) -> void:
	if is_input_disabled == true:
		camera_position = player_cam_global_position
		camera_zoom = player_cam_zoom
		if pause_cam != null:
			pass
		else:
			pass
		zoom_out()
	print (is_input_disabled)



func reset_cam(player_cam_global_position: Vector2, player_cam_zoom: Vector2):
	camera_controls = false
	player_camera_zoom = player_cam_zoom
	player_camera_position = player_cam_global_position
	camera_zoom = lerp (camera_zoom, player_camera_zoom, get_process_delta_time() * zoom_in_speed)
	camera_position = lerp (camera_position, player_camera_position, get_process_delta_time() * zoom_in_speed)


func _on_character_body_2d_game_resume(player_cam_global_position: Vector2, player_cam_zoom: Vector2) -> void:
	reset_cam(player_cam_global_position, player_cam_zoom)

func get_pause_camera():
	pause_cam = get_tree().get_nodes_in_group("pause_camera").front()
	print("pause cam get!")
	print(pause_cam)
	print(pause_cam.zoom)
	pause_cam.make_current()

func zoom_out():
	if pause_cam != null:
		camera_zoom = lerp(camera_zoom, initial_zoom_out, get_process_delta_time() * zoom_out_speed)
	print("nyooom")
	print(pause_cam)

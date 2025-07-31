@tool
extends Node2D

@onready var left_animated_sprite: AnimatedSprite2D = $LeftAnimatedSprite
@onready var right_animated_sprite: AnimatedSprite2D = $RightAnimatedSprite
@onready var middle_animated_sprite: AnimatedSprite2D = $MiddleAnimatedSprite
@onready var static_body_2d: StaticBody2D = $StaticBody2D
@onready var collision_shape_2d: CollisionShape2D = $StaticBody2D/CollisionShape2D

@export var conveyor_speed: float = 20:
	set(speed_value):
		if speed_value != conveyor_speed:
			conveyor_speed = speed_value
			call_deferred("change_speed", conveyor_speed)

@export var conveyor_length: int = 0:
	set(length_value):
		if length_value != conveyor_length:
			conveyor_length = length_value
			call_deferred("add_block", conveyor_length)

@export var flip: bool = false:
	set(bool_value):
		if bool_value != flip:
			flip = bool_value
			call_deferred("change_speed", conveyor_speed)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	change_speed(conveyor_speed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func add_block(_number: int):
	#resets duplicated middle sprites
	for child in get_children():
		if child != left_animated_sprite and child != right_animated_sprite and child != middle_animated_sprite and child != static_body_2d:
			child.queue_free()
	
	#reset scale and position
	collision_shape_2d.scale.x = 1
	collision_shape_2d.position.x = 0
	
	right_animated_sprite.position = Vector2(16 * conveyor_length + 8, 0)
	if conveyor_length > 0:
		middle_animated_sprite.visible = true
		for i in range(conveyor_length - 1):
			var duplicated_sprite = middle_animated_sprite.duplicate()
			duplicated_sprite.position = Vector2(16 * (i + 1) + 8, 0)
			add_child(duplicated_sprite)
		
		collision_shape_2d.scale.x += 0.5 * conveyor_length
		collision_shape_2d.position.x += 8 * conveyor_length
	else:
		middle_animated_sprite.visible = false

func change_speed(_value: float):
	var all_sprites = find_children("*", "AnimatedSprite2D", true)
	if flip == false:
		static_body_2d.constant_linear_velocity = Vector2(conveyor_speed, 0)
		for sprite in all_sprites:
			sprite.speed_scale = conveyor_speed / 20
	elif flip == true:
		static_body_2d.constant_linear_velocity = Vector2(conveyor_speed * -1, 0)
		for sprite in all_sprites:
			sprite.speed_scale = conveyor_speed / -20

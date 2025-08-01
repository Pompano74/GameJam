extends Node2D

@export var aim_speed = 7
@export var detect_radius = 100
@export var time_between_shots = 1

signal shoot

enum {
	IDLE, 
	ATTACK
	}

var target = null
var can_shoot = true
var state = IDLE

@onready var shotTimer: Timer = $Timer
@onready var detectRadius: Area2D = $DetectRadius

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var circle = CircleShape2D.new()
	$DetectRadius/CollisionShape2D.shape = circle
	$DetectRadius/CollisionShape2D.shape.radius = detect_radius

func _physics_process(delta: float) -> void:
	match state:
		IDLE:
			seek_player()
		ATTACK:
			target = detectRadius.target
			if target == null:
				state = IDLE
			attack_state(delta)

func seek_player():
	if detectRadius.can_see_player():
		state = ATTACK

func attack_state(delta):
	if target != null:
		var target_dir = (target.global_position - global_position).normalized()
		var current_dir = Vector2(1,0).rotated($Line2D.global_rotation)
		$Line2D.global_rotation = current_dir.lerp(target_dir, aim_speed * delta).angle()
		if target_dir.dot(current_dir) > 0.9 and can_shoot == true:
			shoot_projectile()

func shoot_projectile():
	var dir = Vector2(1,0).rotated($Line2D/Marker2D.global_rotation)
	emit_signal("shoot", $Line2D/Marker2D.global_position, dir)
	shotTimer.start(time_between_shots)
	can_shoot = false
	print("shot")

func _on_timer_timeout() -> void:
	can_shoot = true
	shotTimer.stop()

extends Area2D

@export var speed = 200
const RIGHT = Vector2.RIGHT

func _physics_process(delta):
	if not is_inside_tree():
		return
	var movement = RIGHT.rotated(rotation) * speed * delta
	global_position += movement

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

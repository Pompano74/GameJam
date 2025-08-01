extends Area2D

var target = null

func can_see_player():
	return target != null

func _on_body_entered(body: Node2D) -> void:
	if target == null:
		target = body
	print(target.get_name())

func _on_body_exited(body: Node2D) -> void:
	if body == target:
		target = null

extends Node2D


func _on_area_2d_body_entered(body):
	body.on_killzone_enter()


func _on_area_2d_body_exited(body):
	body.on_killzone_exit()

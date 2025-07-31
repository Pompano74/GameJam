extends Node2D


func _on_area_2d_body_entered(body):
	body.on_killzone_enter()
	body.die()

func _on_area_2d_body_exited(body):
	body.on_killzone_exit()

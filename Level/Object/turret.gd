extends Node2D

const BULLET = preload("res://Level/Object/bullet.tscn")
@onready var pivot = $pivot
var player: Node2D = null


func _ready():
	await get_tree().process_frame
	player = get_tree().get_first_node_in_group("player")
	if player == null:
		print("⚠️ Joueur introuvable dans le groupe 'player'.")
	

func _process(delta):
	if player and is_instance_valid(player):
		pivot.look_at(player.global_position)
		print("Joueur position:", player.global_position)

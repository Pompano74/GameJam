extends Node

var bpm: int = 30
var beatDuration: float
@onready var timer: Timer = $Timer
var powersIndex: int = 0
@onready var input_manager: Node = get_node("InputManager")
@onready var player: Player = $"../Player" as Player


func _ready() -> void:
	beatDuration = 60.0 / bpm
	timer.wait_time = beatDuration
	timer.start()
	if input_manager:
		print("InputManager trouvé :", input_manager)
	else:
		print("⚠️ InputManager introuvable !")
	
	if player:
		print("✅ Player trouvé :", player)
	else:
		print("❌ Erreur : Player non trouvé !")


func _process(_delta: float) -> void:
	var newBeatDuration = 60.0 / bpm
	if newBeatDuration != beatDuration:
		beatDuration = newBeatDuration
		timer.wait_time = beatDuration

	# Mise à jour d’un seul bouton : celui de powersIndex
	if powersIndex >= 0 and powersIndex < input_manager.drumRolls.size():
		var drumRoll = input_manager.drumRolls[powersIndex]
		if drumRoll:
			var index = drumRoll.currentActionIndex
			if index >= 0 and index < input_manager.actions.size():
				drumRoll.text = input_manager.actions[index]
				print("Bouton", powersIndex, "→", input_manager.actions[index])
				if drumRoll.text == "Nothing":
					pass
				if drumRoll.text == "Jump":
					player.jump()
				if drumRoll.text == "Dash":
					player.dash()
				if drumRoll.text == "Attack":
					pass
			else:
				drumRoll.text = "Invalid"
func _on_timer_timeout() -> void:
	powersIndex += 1
	if powersIndex >= 8:
		powersIndex = 0
	print(powersIndex)

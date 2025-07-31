extends Node

var bpm: int = 30
var beatDuration: float
@onready var timer: Timer = $Timer
var powersIndex: int
@onready var input_manager: Node = get_node("InputManager")

func _ready() -> void:
	beatDuration = 60.0 / bpm
	timer.wait_time = beatDuration
	timer.start()
	if input_manager:
		print("InputManager trouvé :", input_manager)
	else:
		print("⚠️ InputManager introuvable !")


func _process(_delta: float) -> void:
	# (optionnel) Si tu veux permettre de changer le bpm dynamiquement :
	var newBeatDuration = 60.0 / bpm
	if newBeatDuration != beatDuration:
		beatDuration = newBeatDuration
		timer.wait_time = beatDuration
		
	
func _on_timer_timeout() -> void:
	if powersIndex >= 8:
		powersIndex = 0
	powersIndex += 1
	print(powersIndex)

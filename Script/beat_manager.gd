extends Node

var bpm: int = 30
var beatDuration: float 
@onready var timer: Timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	beatDuration = bpm/60
	timer.wait_time = beatDuration


func _on_timer_timeout() -> void:
	print("Beat")

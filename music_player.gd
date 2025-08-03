extends AudioStreamPlayer2D

@export var level_music: AudioStreamMP3

func _ready():
	
	stream = level_music
	play()
	
func switch_music(new_music: AudioStream):
	if playing:
		stop()

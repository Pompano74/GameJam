extends Node2D


@export var movement_radius: float = 10.0
@export var speed: float = 0.5

var noise: FastNoiseLite
var time: float = 0.0

@onready var layers := [$Sprite2D, $Sprite2D2, $Sprite2D3, $Sprite2D4, $Sprite2D5, $Sprite2D6]
var original_positions: Array[Vector2] = []

func _ready():
	noise = FastNoiseLite.new()
	noise.seed = randi()
	noise.frequency = 0.2  # Lower = smoother, slower variation
	noise.fractal_octaves = 2
	noise.fractal_gain = 0.8
	noise.fractal_lacunarity = 2.0
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX  # Smooth noise

	for sprite in layers:
		original_positions.append(sprite.position)

func _process(delta: float) -> void:
	time += delta * speed

	for i in layers.size():
		var offset_x = noise.get_noise_2d(i * 10.0, time) * movement_radius
		var offset_y = noise.get_noise_2d(time, i * 10.0) * movement_radius
		layers[i].position = original_positions[i] + Vector2(offset_x, offset_y)

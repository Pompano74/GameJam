extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

@export var min_brightness := 0.5  # 0.0 = full black, 1.0 = original brightness
@onready var anim_sprite = $AnimatedSprite2D

func _on_mouse_entered() -> void:
	if self.has_method("set_modulate"):
		print("SELF FOUND WITH ITS PROPERTIES")
		var current_color = self.modulate
		self.modulate = Color(min_brightness, min_brightness, min_brightness, current_color.a)

func _on_mouse_exited() -> void:
	if self.has_method("set_modulate"):
		var current_color = self.modulate
		self.modulate = Color(1.0, 1.0, 1.0, current_color.a)


@onready var animation_sprite = $PlugAnim/AnimationPlayer

func _on_button_down() -> void:
	animation_sprite.play("UnplugAnimation", 4)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	get_tree().quit()

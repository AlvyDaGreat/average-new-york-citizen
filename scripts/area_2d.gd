extends Area2D

func _ready() -> void:
	pass

func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.is_pressed():
		self.on_click()

func on_click():
	get_tree().change_scene_to_file("res://scenes/idk.tscn")

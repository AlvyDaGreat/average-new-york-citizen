extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("idle")
	$AnimationPlayerTua.play("yur")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func kys() -> void:
	# get_tree().quit()
	get_tree().change_scene_to_file('res://scenes/3Dscene.tscn')

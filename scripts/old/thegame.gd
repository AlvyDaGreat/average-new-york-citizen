extends Node2D


@export var dead = false
signal death

func _ready() -> void:
	await death
	get_tree().paused = true
	$Death.play()
	$PlayerBear/Camera2D/Death.show()

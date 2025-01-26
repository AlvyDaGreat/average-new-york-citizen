extends Node2D

@export var speed = 1200
@export var lifetime = 1

@onready var life = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += Vector2(cos(rotation) * speed * delta,sin(rotation) * speed * delta)
	life += delta
	if life >= lifetime:
		queue_free()

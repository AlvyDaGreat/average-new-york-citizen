extends Node2D

@export var direction = 0
@export var speed = 1200
@export var lifetime = 1

@onready var life = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotation = direction
	position += Vector2(cos(direction) * speed * delta,sin(direction) * speed * delta)
	life += delta
	if life >= lifetime:
		queue_free()

extends Node2D


@export var speed = 100
@export var hp = 10

@onready var area = $Area2D
@onready var notMove = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $'..'.find_child('PlayerBear'):
		var bear = $'../PlayerBear'
		look_at(bear.position)
		if not notMove:
			position += Vector2(cos(rotation) * speed * delta, sin(rotation) * speed * delta)
		rotation = 0
		if hp <= 0:
			queue_free()
	if area.has_overlapping_areas():
		var areas = area.get_overlapping_areas()
		
		for i in areas:
			if i.name.match('Bullet'):
				i.get_parent().queue_free()
				hp -= 1
				if not notMove:
					notMove = true
					move()

				
func move():
	position.x += 5
	modulate = Color(1,0,0)
	await get_tree().create_timer(0.1).timeout
	position.x -= 10
	
	await get_tree().create_timer(0.1).timeout

	position.x += 5
	await get_tree().create_timer(0.1).timeout
	modulate = Color.WHITE
	notMove = false

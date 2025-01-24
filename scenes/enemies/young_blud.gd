extends Node2D


@export var speed = 100
@export var hp = 10

@onready var area = $Enemy
@onready var notMove = false
@onready var timer = 0.0
@onready var cooldown = 0

@onready var dashVel = Vector2()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $'..'.find_child('PlayerBear'):
		var bear = $'../PlayerBear'
		look_at(bear.position)
		if cooldown != 0:
			rotation += 1
			speed = 200
		else:
			speed = 100
		if not notMove:
			if fmod(timer,300) == 0.0:
				cooldown = 1.0
			if fmod(timer,600) == 0.0:
				look_at(bear.position)
				dashVel += Vector2(cos(rotation), sin(rotation)) * 10
				timer = 0
			position += Vector2(cos(rotation) * speed * delta, sin(rotation) * speed * delta) + dashVel
			dashVel = dashVel.lerp(Vector2(),5*delta)
			timer += 1
			cooldown = max(0,cooldown - delta)
		
		rotation = 0
		if hp <= 0:
			queue_free()
	if area.has_overlapping_areas():
		var areas = area.get_overlapping_areas()
		
		for i in areas:
			if not i: return
			if i.name.match('Bullet'):
				i.get_parent().queue_free()
				hp -= 1
				if not notMove:
					notMove = true
					move()
				modulate = Color(1,0,0)
				$Hit.play()
				await get_tree().create_timer(0.05).timeout
				modulate = Color.WHITE

				
func move():
	position.x += 5
	
	await get_tree().create_timer(0.1).timeout
	position.x -= 10
	
	await get_tree().create_timer(0.1).timeout

	position.x += 5
	await get_tree().create_timer(0.1).timeout
	notMove = false

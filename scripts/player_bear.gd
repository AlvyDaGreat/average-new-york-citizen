extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var dashVector = Vector2()

@onready var sprite = $BearSprite
@onready var animationPlayer = $BearSprite/AnimationPlayer

@onready var cooldown = 0
@onready var dashScene = preload('res://scenes/dash.tscn')
@onready var hold = false
@onready var power = 0

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&'Enter'):
		hold = true
	if event.is_action_released(&'Enter'):
		hold = false
		dashVector = Input.get_vector(&'Left',&'Right',&'Up',&'Down') * power
		for i in 5:
			print('bal;l;s')
			var inst = sprite.duplicate()
			inst.name = 'BearSprite'
			var scene = dashScene.instantiate()
			scene.add_child(inst)
			$'..'.add_child(scene)
			inst.global_position = global_position
			await get_tree().create_timer(0.05).timeout

func _physics_process(delta: float) -> void:
	# Add the gravity.
	var dir = Input.get_vector(&'Left',&'Right',&'Up',&'Down')
	if hold:
		power += 30
	else:
		power = 0
	if dir.x > 0:
		sprite.flip_h = false
	elif dir.x < 0:
		sprite.flip_h = true
	velocity = dir * SPEED + dashVector
	if dir.length() == 0:
		animationPlayer.play(&'idle')
	else:
		animationPlayer.stop()

	dashVector = dashVector.lerp(Vector2(),0.1)
	move_and_slide()

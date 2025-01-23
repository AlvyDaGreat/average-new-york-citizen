extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var dashVector = Vector2()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&'Enter'):
		dashVector = Input.get_vector(&'Left',&'Right',&'Up',&'Down') * 600

func _physics_process(delta: float) -> void:
	# Add the gravity.
	var dir = Input.get_vector(&'Left',&'Right',&'Up',&'Down')
	velocity = dir * SPEED + dashVector
	dashVector = dashVector.lerp(Vector2(),0.1)
	move_and_slide()

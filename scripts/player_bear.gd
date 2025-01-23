extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	var dir = Input.get_vector(&'Left',&'Right',&'Up',&'Down')
	velocity = dir * SPEED
	move_and_slide()

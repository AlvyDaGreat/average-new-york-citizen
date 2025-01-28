extends CharacterBody3D


@export var SPEED = 3.0
@export var IDLE_SPEED = 0.5
@export var state = 'idle'

@onready var anim_player : AnimationPlayer = $Sprite/AnimationPlayer
@onready var health_component : HealthComponent = $HealthComponent
@onready var sprite : Sprite3D = $Sprite

var anim_state = 'idle'
var idle_move = 2
var direction = 0

func idle_state(delta):
	if idle_move == 0:
		idle_move = 2
	if idle_move == 2:
		print('change direction?')
		direction = randf_range(-PI,PI)
		print(direction)
	if idle_move > 1:
		position += Vector3(cos(direction) * IDLE_SPEED * delta,sin(direction) * IDLE_SPEED * delta,0)
		anim_state = 'run'
	else:
		anim_state = 'idle'
	idle_move = max(0,idle_move-delta)

func _process(delta: float) -> void:
	if state == 'idle':
		idle_state(delta)
	elif state == 'spotted':
		pass
	if get_position_delta().x < 0:
		sprite.flip_h = true
	elif get_position_delta().x > 0:
		sprite.flip_h = false
	move_and_slide()
	update_animations(anim_state)

func start_phase2():
	print('yooo')
	pass

func update_animations(state):
	anim_player.current_animation = state

func question_mark():
	var question = preload('res://scenes/enemies/question_mark.tscn')
	var inst = question.instantiate()
	get_parent().add_child(inst,true)
	inst.global_position = global_position + Vector3.UP / 5

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player and state == 'idle':
		question_mark()
		state = 'spotting'

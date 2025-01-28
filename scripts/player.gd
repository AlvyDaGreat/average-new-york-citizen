extends CharacterBody3D
class_name Player

@export var SPEED = 2.5
@export var MAX_DASH = 30

var dashVector = Vector3()
var inflicted_velocity = Vector3()

@onready var sprite = $BearSprite
@onready var animationPlayer: AnimationPlayer = $BearSprite/AnimationPlayer
@onready var dashBar = $CameraOffset/Camera3D/UI/DashBar
@onready var healthBar = $CameraOffset/Camera3D/UI/HealthBar
@onready var ui = $CameraOffset/Camera3D/UI
@onready var camera = $CameraOffset/Camera3D

var cooldown = 0
var dashScene = preload('res://scenes/dash.tscn')
var hold = false
var power = 0
var last_dir = Vector2(1,0)

var dashCooldown = false
var skidCooldown = false

var state = 'idle'

func start_dash():
	dashBar.max_value = MAX_DASH
	dashBar.show()
	hold = true
func end_dash():
		dashBar.hide()
		hold = false
		var dir = last_dir * power
		dashVector = Vector3(dir.x,dir.y,0)
		$Sounds/Dash.play() 
		skidCooldown = false
		dash_visual()
func dash_visual():
	for i in 5:
		var inst = sprite.duplicate()
		var scene = dashScene.instantiate()
		inst.name = 'BearSprite'
		scene.add_child(inst)
		scene.prop[0] = sprite.texture
		scene.prop[1] = sprite.hframes
		scene.prop[2] = sprite.frame_coords
		print(scene.prop)
		$'..'.add_child(scene)
		inst.global_position = global_position
		inst.global_rotation = global_rotation
		await get_tree().create_timer(0.05).timeout

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&'Enter'):
		start_dash()
	if event.is_action_released(&'Enter'):
		end_dash()

func _process(delta: float) -> void:
	var dir = Input.get_vector(&'Left',&'Right',&'Down',&'Up')
	if dir.length() != 0:
		last_dir = dir
	position += Vector3(dir.x * SPEED *delta,dir.y * SPEED * delta,0) + Vector3(dashVector.x * delta,dashVector.y * delta,0) + (inflicted_velocity * delta)
	
	inflicted_velocity = inflicted_velocity.lerp(Vector3(),10*delta)
	dashVector = dashVector.lerp(Vector3(),5 * delta)
	
	if hold:
		power = clamp(power + 30 * delta,0,MAX_DASH)
		dashBar.value = power
	else:
		power = 0
	if dir.x > 0:
		sprite.flip_h = false
	elif dir.x < 0:
		sprite.flip_h = true
	
	move_and_slide()
	update_state(dir)
	update_animation(state)

func update_state(dir):
	if dir.length() == 0:
		state = 'idle'
	else:
		state = 'run'
	if dashVector.length() > 5:
		state = 'dash'
	elif dashVector.length() > 1:
		state = 'skid'

func update_animation(state):
	animationPlayer.current_animation = state

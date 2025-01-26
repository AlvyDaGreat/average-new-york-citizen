extends Node3D


const SPEED = 2.0
const JUMP_VELOCITY = -400.0
const MAX_DASH = 30
const MAX_HP = 10

var hp = MAX_HP
var lose_hp_cooldown = 0

var dashVector = Vector2()

@onready var sprite = $BearSprite
@onready var animationTree : AnimationTree = $BearSprite/AnimationTree
@onready var dashBar = $CameraOffset/Camera3D/UI/DashBar
@onready var healthBar = $CameraOffset/Camera3D/UI/HealthBar
@onready var ui = $CameraOffset/Camera3D/UI
@onready var camera = $CameraOffset/Camera3D

var cooldown = 0
var dashScene = preload('res://scenes/dash.tscn')
var hold = false
var power = 0

var dashCooldown = false
var skidCooldown = false



func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&'Enter'):
		dashBar.max_value = MAX_DASH
		dashBar.show()
		hold = true
	if event.is_action_released(&'Enter'):
		dashBar.hide()
		hold = false
		dashVector = Input.get_vector(&'Left',&'Right',&'Down',&'Up') * power
		$Sounds/Dash.play() 
		skidCooldown = false
		for i in 5:
			print('bal;l;s')
			var inst = sprite.duplicate()
			inst.name = 'BearSprite'
			
			var scene = dashScene.instantiate()
			scene.add_child(inst)
			$'..'.add_child(scene)
			inst.global_position = global_position
			await get_tree().create_timer(0.05).timeout

func _process(delta: float) -> void:
	var dir = Input.get_vector(&'Left',&'Right',&'Down',&'Up')
	position += Vector3(dir.x * SPEED *delta,dir.y * SPEED * delta,0) + Vector3(dashVector.x * delta,dashVector.y * delta,0)
	dashVector = dashVector.lerp(Vector2(),5 * delta)
	ui.position = camera.unproject_position(position)
	if hold:
		power = clamp(power + 30 * delta,0,MAX_DASH)
		dashBar.value = power
	else:
		power = 0
	if dir.x > 0:
		sprite.flip_h = false
	elif dir.x < 0:
		sprite.flip_h = true
	
	update_animation(dir)

func update_animation(dir):
	if dir.length() == 0:
		animationTree['parameters/conditions/walk'] = false
		animationTree['parameters/conditions/idle'] = true
	else:
		animationTree['parameters/conditions/idle'] = false
		animationTree['parameters/conditions/walk'] = true
	

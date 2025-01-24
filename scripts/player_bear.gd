extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const MAX_DASH = 3000.0
const MAX_HP = 10

var hp = MAX_HP
var lose_hp_cooldown = 0

@onready var dashVector = Vector2()

@onready var sprite = $BearSprite
@onready var animationPlayer = $BearSprite/AnimationPlayer
@onready var dashBar = $DashBar

@onready var cooldown = 0
@onready var dashScene = preload('res://scenes/dash.tscn')
@onready var hold = false
@onready var power = 0

@onready var dashCooldown = false
@onready var skidCooldown = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&'Enter'):
		dashBar.max_value = MAX_DASH
		dashBar.show()
		hold = true
	if event.is_action_released(&'Enter'):
		dashBar.hide()
		hold = false
		dashVector = Input.get_vector(&'Left',&'Right',&'Up',&'Down') * power
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
	# Add the gravity.
	var dir = Input.get_vector(&'Left',&'Right',&'Up',&'Down')
	if hold:
		power = clamp(power + 3000 * delta,0,MAX_DASH)
		dashBar.value = power
		
	else:
		power = 0
	if dir.x > 0:
		sprite.flip_h = false
	elif dir.x < 0:
		sprite.flip_h = true
	if dir.length() == 0:
		if not dashVector.length() > 50:
			animationPlayer.current_animation = 'idle'
	else:
		if not dashVector.length() > 50:
			animationPlayer.current_animation = 'walk'
	if dashVector.length() > 300:
		animationPlayer.current_animation = 'run'
	elif dashVector.length() > 50:
		animationPlayer.current_animation = 'slide'
		
		
	dashVector = dashVector.lerp(Vector2(),5 * delta)
	position += (dir * SPEED * delta )+ (dashVector * delta)
	
	lose_hp_cooldown = max(0,lose_hp_cooldown-delta)
	
	$HealthBar.value = hp
	
	if $Player.has_overlapping_areas():
		var areas = $Player.get_overlapping_areas()
		for i in areas:
			if i.name == 'Enemy' and lose_hp_cooldown == 0:
				$Sounds/Youch.play()
				hp -= 1
				hit()
				lose_hp_cooldown = 1
	if hp <= 0 and not $'..'.dead:
		$'..'.dead = true
		$'..'.emit_signal('death')
		
		
func hit():
	sprite.self_modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	sprite.self_modulate  = Color.WHITE
	await get_tree().create_timer(0.1).timeout
	sprite.self_modulate .a = 0
	await get_tree().create_timer(0.1).timeout
	sprite.self_modulate .a = 1
	await get_tree().create_timer(0.05).timeout
	sprite.self_modulate .a = 0
	await get_tree().create_timer(0.05).timeout
	sprite.self_modulate .a = 1

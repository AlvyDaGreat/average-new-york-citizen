extends Node2D


@export var type = ''

@onready var direction = 0
@onready var delay = 0
@onready var pastPos = Vector2()

@onready var sprite = $GlockSprite
@onready var barrel = $GlockSprite/Barrel
@onready var bulletPos = $GlockSprite/BulletPosition

@onready var sounds = $Sounds
@onready var pew = $Sounds/Pew

@onready var cooldown = 0
@onready var bulletScene = preload('res://scenes/bullet.tscn')
@onready var smokeScene = preload('res://scenes/bulletSmoke.tscn')

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	look_at(get_global_mouse_position())
	cooldown = max(0,cooldown - delta)
	sprite.rotation += (delay - rotation) / 5
	delay = rotation
	position += Input.get_vector(&'Left',&'Right',&'Up',&'Down')
	position = position.lerp(Vector2(),10*delta)
	sprite.rotation = lerp_angle(sprite.rotation,0,10*delta)
	if global_rotation_degrees > 90 or global_rotation_degrees < -90:
		sprite.scale = Vector2(0.057,-0.032)
		
	else:
		sprite.scale = Vector2(0.057,0.032)
	if Input.is_action_pressed(&'click'):
		if cooldown == 0:
			
			var sound : AudioStreamPlayer = pew.get_child(randi_range(0,pew.get_child_count() - 1))
			sound.play()
			var inst = bulletScene.instantiate()
			var smoke = smokeScene.instantiate()
			$'../..'.add_child(inst)
			$'../..'.add_child(smoke)
			inst.position = bulletPos.global_position
			smoke.position = barrel.global_position
			print(barrel.global_position)
			smoke.rotation = barrel.global_rotation
			inst.look_at(get_global_mouse_position())
			if global_rotation_degrees > 90 or global_rotation_degrees < -90:
				sprite.rotation = 0.5
			else:
				sprite.rotation = -0.5
			
			if $'../..'.find_child('Camera2D'):
				var cam = $'../..'.find_child('Camera2D')
				cam.position += Vector2(randf_range(-10,10),randf_range(-10,10))
			cooldown = 0.1
			

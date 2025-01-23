extends Node2D


@export var type = ''

@onready var direction = 0
@onready var sprite = $GlockSprite

@onready var cooldown = 0
@onready var bulletScene = preload('res://scenes/bullet.tscn')

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	look_at(get_global_mouse_position())
	cooldown = max(0,cooldown - delta)
	if global_rotation_degrees > 90 or global_rotation_degrees < -90:
		sprite.flip_v = true
		
	else:
		sprite.flip_v = false
	if Input.is_action_pressed(&'click'):
		if cooldown == 0:
			var inst = bulletScene.instantiate()
			$'../..'.add_child(inst)
			inst.direction = self.global_rotation
			inst.position = sprite.global_position
			if $'../..'.find_child('Camera2D'):
				var cam = $'../..'.find_child('Camera2D')
				cam.position += Vector2(randf_range(-10,10),randf_range(-10,10))
			cooldown = 0.1
			

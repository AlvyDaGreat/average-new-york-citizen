extends Sprite2D

const MRBLOOM = preload("res://sprites/TVtut.png")
const WOW = preload("res://sprites/TVwow.png")

var combo = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("spawn")
	$Area2D.input_pickable = false
	combo = 0
	set_process_input(true) 
	pass # Replace with function body.

func _input(ev):
	if ev is InputEventKey and ev.pressed == true and ev.echo == false:
		match ev.keycode:
			KEY_UP when combo == 0:
				combo=1
			KEY_UP when combo == 1:
				combo=2
			KEY_DOWN when combo == 2:
				combo=3
			KEY_DOWN when combo == 3:
				combo=4
			KEY_LEFT when combo == 4:
				combo=5
			KEY_RIGHT when combo == 5:
				combo=6
			KEY_LEFT when combo == 6:
				combo=7
			KEY_RIGHT when combo == 7:
				combo=8
			KEY_B when combo == 8:
				combo=9
			KEY_A when combo == 9:
				combo=10
			KEY_ENTER when combo == 10:
				combo=11
				self.texture = WOW
				self.hframes = 2
				$AnimationPlayer.play("wow")
				$"../AudioStreamPlayerWOW".play()
			_:
				combo = 0
		print(combo)
		print(ev)

func summonbloom():
	print("MRBLOOM HAS A GLOCK")
	self.texture = MRBLOOM
	self.hframes = 4
	$AnimationPlayer.play("tutorial")
	$Area2D.input_pickable = true
	pass

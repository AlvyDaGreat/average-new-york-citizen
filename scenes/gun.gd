extends Node3D

@onready var camera : Camera3D = $'../CameraOffset/Camera3D'
@onready var offset : Node3D = $Offset

var distance : float
var cooldown : float


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mouse = get_viewport().get_mouse_position()
	var pos : Vector2 = camera.unproject_position(global_position)
	rotation.z = atan2(mouse.x - pos.x,mouse.y - pos.y)
	distance = (mouse - pos).length() / 200
	print(distance)
	distance = min(0.5,distance)
	cooldown = max(0,cooldown - delta)
	offset.rotation.z = lerp_angle(offset.rotation.z,-PI / 2,10*delta)
	position = Vector3(sin(rotation.z) * distance,-cos(rotation.z) * distance,0)
	if rotation.z < 0 and rotation.z > -PI:
		offset.scale.y = -1
	else:
		offset.scale.y = 1
	if Input.is_action_pressed(&'click') and cooldown == 0:
		if rotation.z < 0 and rotation.z > -PI:
			offset.rotation.z += -0.2
		else:
			offset.rotation.z += 0.2
		cooldown = 0.05

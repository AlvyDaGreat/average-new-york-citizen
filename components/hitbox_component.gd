extends Area3D
class_name HitboxComponent

@export var inflicted_velocity: Vector3 = Vector3()

func hit(attack: Attack):
	inflicted_velocity += attack.attack_position - position * attack.knockback_force

func _process(delta: float) -> void:
	if get_parent() is Entity:
		position += inflicted_velocity * delta
		inflicted_velocity = inflicted_velocity.lerp(Vector3(),10 * delta)

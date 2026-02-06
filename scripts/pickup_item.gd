extends RigidBody2D

func pop() -> void:
	# Kick it up with a random impulse
	apply_impulse(Vector2(randf_range(-16, 16), randf_range(-42, -26)))

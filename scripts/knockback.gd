extends Node2D

@export var drag := 250
var knockback: Vector2 = Vector2.ZERO
var knockback_timer: float = 0.0

@onready var motor: Node2D = $"../Motor"

func _physics_process(delta: float) -> void:
	if knockback_timer > 0.0:
		motor.request_knockback(knockback)
		knockback = knockback.move_toward(Vector2.ZERO, drag * delta)
		knockback_timer -= delta
	else:
		knockback = Vector2.ZERO

func apply_knockback(dir: Vector2, force: float, duration: float) -> void:
	knockback = dir * force
	knockback_timer = duration

extends Node2D

@export var drag := 250
var knockback: Vector2 = Vector2.ZERO

@onready var motor: Node2D = $"../Motor"

func _physics_process(delta: float) -> void:
	motor.request_knockback(knockback)
	knockback = knockback.move_toward(Vector2.ZERO, drag * delta)

func apply_knockback(dir: Vector2, force: float) -> void:
	knockback = dir * force

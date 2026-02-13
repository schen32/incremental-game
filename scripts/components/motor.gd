extends Node2D
class_name Motor

@onready var body: CharacterBody2D = get_parent()

var external_velocity := Vector2.ZERO
var frozen := false

func request_knockback(v: Vector2) -> void:
	external_velocity = v

func freeze() -> void:
	frozen = true

func unfreeze() -> void:
	frozen = false

func _physics_process(_delta: float) -> void:
	if frozen:
		body.velocity = Vector2.ZERO
		body.move_and_slide()
		external_velocity = Vector2.ZERO
		return

	body.velocity += external_velocity
	body.move_and_slide()
